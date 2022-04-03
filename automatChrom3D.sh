################  LOADING REQUIRED TOOLS ########   MODIFY ACCORDINGLY TO YOUR HPC system
module load boost
module load python/2.7.9 
module load bedtools 
module load R

###################################################

dir=$(echo $1 | cut -f2 -d"=")
chrom3D=$(echo $8 | cut -f2 -d"=")
res_intra=$(echo $2 | cut -f2 -d"=")
res_inter=$(echo $3 | cut -f2 -d"=")
sex=$(echo $4 | cut -f2 -d"=")
stats=$(echo $5 | cut -f2 -d"=")
thresold_intra=$(echo $6 | cut -f2 -d"=")
thresold_inter=$(echo $7 | cut -f2 -d"=")
name=$(echo $9 | cut -f2 -d"=")
chromosome_size=$(echo ${10} | cut -f2 -d"=")
domains=$(echo ${11} | cut -f2 -d"=")
blocks=$(echo ${12} | cut -f2 -d"=")
black_list=$(echo ${13} | cut -f2 -d"=")
NCHG_dir=$(echo ${14} | cut -f2 -d"=")
LADS=$(echo ${15} | cut -f2 -d"=")
specie=$(echo ${16} | cut -f2 -d"=")
cytoband=$(echo ${17} | cut -f2 -d"=")


mkdir -p $chrom3D

matrix_intra=*_$res_intra.matrix
abs_intra=*_$res_intra\_abs.bed
matrix_inter=*_$res_inter.matrix
abs_inter=*_$res_inter\_abs.bed

find $dir -name $(echo $matrix_intra) -exec cp {} $chrom3D  \;
find $dir -name $(echo $abs_intra) -exec cp {} $chrom3D  \;
find $dir -name $(echo $matrix_inter) -exec cp {} $chrom3D  \;
find $dir -name $(echo $abs_inter) -exec cp {} $chrom3D  \;

# redefined and assign new name
for file in $chrom3D/*_abs.bed ; do
mv "$file" "${file/_abs/}";
done
abs_intra=*$res_intra.bed

checkNCHG="$NCHG_dir/preprocess_scripts/"
if [ -d "$checkNCHG" ]; then
  echo "Preprocessing cis interactions reads..."
else
  echo "Error: ${checkNCHG} not found. "
  exit 1
fi

$NCHG_dir/preprocess_scripts/conv_hicpro_mat_intra.sh $chrom3D/$matrix_intra $chrom3D/$abs_intra $name

mv $NCHG_dir/preprocess_scripts/$name.intra.intermediate.bedpe $chrom3D/

if [ $sex = "female" ]
then
        echo "female sex selected, processing ..."
        awk '$1!="chrY" && $4!~"chrY"' $chrom3D/$name.intra.intermediate.bedpe > $chrom3D/$name.intra.intermediate.formatted.bedpe
elif [ $sex = "none" ]
then
        echo "none sex selected, processing ..."
        awk '$1!="chrY" && $4!~"chrY"' $chrom3D/$name.intra.intermediate.bedpe > $chrom3D/temp.cis
        awk '$1!="chrX" && $4!~"chrX"' $chrom3D/temp.cis > $chrom3D/$name.intra.intermediate.formatted.bedpe
        rm $chrom3D/temp.cis
else
        echo "male sex selected, processing ..."
        mv $chrom3D/$name.intra.intermediate.bedpe $chrom3D/$name.intra.intermediate.formatted.bedpe
fi

#s2

mkdir $chrom3D/intra_chr_RAWobserved

echo "$res_intra intrachromosomal resolution selected, processing..."
bash $NCHG_dir/preprocess_scripts-master/make_intrachr_rawObserved.automat.sh $chromosome_size $chrom3D/$name.intra.intermediate.formatted.bedpe $res_intra 2> /dev/null
mv $NCHG_dir/preprocess_scripts-master/intra_chr_RAWobserved $chrom3D/
$NCHG_dir/preprocess_scripts-master/conv_hicpro_mat_inter.temp.sh $chrom3D/$matrix_inter $chrom3D/$abs_inter $name 2> /dev/null
mv $NCHG_dir/preprocess_scripts-master/$name.inter.intermediate.bedpe $chrom3D/

if [ $sex = "female" ]
then
        echo "female sex selected, processing ..."
        awk '$1!="chrY" && $4!~"chrY"' $chrom3D/$name.inter.intermediate.bedpe > $chrom3D/$name.inter.intermediate.formatted.bedpe
elif [ $sex = "none" ]
then
        echo "none sex selected, processing ..."
        awk '$1!="chrY" && $4!~"chrY"' $chrom3D/$name.inter.intermediate.bedpe > $chrom3D/temp.trans
        awk '$1!="chrX" && $4!~"chrX"' $chrom3D/temp.trans > $chrom3D/$name.inter.intermediate.formatted.bedpe
        rm $chrom3D/temp.trans
else
        echo "male sex selected, processing ..."
        mv $chrom3D/$name.inter.intermediate.bedpe $chrom3D/$name.inter.intermediate.formatted.bedpe
fi

bash $NCHG_dir/preprocess_scripts-master/make_interchr_rawObserved.automat.sh $chromosome_size $chrom3D/$name.inter.intermediate.formatted.bedpe 2> /dev/null
mv $NCHG_dir/preprocess_scripts-master/inter_chr_RAWobserved $chrom3D/

cd $NCHG_dir/preprocess_scripts-master
echo "Evaluating TADs..."

tail -n +2 $domains/$blocks.bedpe > temp
awk 'NF > 0 { print "chr"$1 "\t" $2"_"$3 "\t" ($3 - $2) }' temp > diff.bed
awk '{dups[$1]++} END{for (num in dups) {print num,dups[num]}}' diff.bed > diff.counts.bed
sort -k1,1 -V -s diff.counts.bed > diff.counts.sorted.bed
sed  -s '1i CHR coordinates substraction' diff.bed > diff.head.bed
sed  -i '1i CHR TADnumber' diff.counts.sorted.bed
awk 'BEGIN {max = 0} {if ($3>max && $3!= ">") max=$3} END {print max}' temp
echo "Maximun domain found of size: $(awk -v max=0 '{if($3>max){want=$3; max=$3}}END{print want} ' diff.bed) bp in... "
echo "$(awk -v max=0 '{if($3>max){want=$1; max=$3}}END{print want} ' diff.bed)"
awk '$1!="chrY" && $4!~"chrY"' diff.bed > temp.diff
awk '$1!="chrX" && $4!~"chrX"' temp.diff >  diff.autosomes.bed
echo "Maximun domain found in autosomes of size: $(awk -v max=0 '{if($3>max){want=$3; max=$3}}END{print want} ' diff.autosomes.bed) bp in ..."
echo "$(awk -v max=0 '{if($3>max){want=$1; max=$3}}END{print want} ' diff.autosomes.bed)"


Rscript $NCHG_dir/preprocess_scripts-master/TADev.R
mv ./TADsizedistribution.pdf $chrom3D/$name.TADsizedistribution.pdf
mv ./TADs_per_chromosome.pdf $chrom3D/$name.TADs_per_chromosome.pdf

bash $NCHG_dir/preprocess_scripts-master/arrowhead_to_domains.sh $domains/$blocks.bedpe $chromosome_size
cat $domains/*.chr*.domains > $domains/sample_Arrowhead_domainlist.domains

bash $NCHG_dir/preprocess_scripts-master/intrachr_NCHG_input_auto.sh $blocks $chromosome_size $res_intra $domains $chrom3D 2> /dev/null
mv $NCHG_dir/preprocess_scripts-master/intrachr_bedpe $chrom3D/
cat $chrom3D/intrachr_bedpe/chr*.bedpe/chr*.bedpe > $chrom3D/intrachr_bedpe/sample.$res_intra.domain.RAW.bedpe

#####  CYTOBAND

if [ $specie = "human" ]
then
echo "human selected"
grep acen $cytoband | pairToBed -a $chrom3D/intrachr_bedpe/sample.$res_intra.domain.RAW.bedpe -b stdin -type neither > $chrom3D/intrachr_bedpe/sample.$res_intra.domain.RAW.no_cen.bedpe

elif [ $specie = "mouse" ]
then
echo "mouse selected"
cat $chrom3D/intrachr_bedpe/chr*.bedpe/chr*.bedpe > $chrom3D/intrachr_bedpe/sample.$res_intra.domain.RAW.no_cen.bedpe

fi


#####


$NCHG_dir/NCHG -m $res_intra -p $chrom3D/intrachr_bedpe/sample.$res_intra.domain.RAW.no_cen.bedpe > $chrom3D/intrachr_bedpe/sample.$res_intra.domain.RAW.bedpe.out

cd $NCHG_dir/preprocess_scripts-master


$NCHG_dir/preprocess_scripts-master/NCHG_fdr_oddratio_calc_intra.automat.sh $chrom3D $stats $thresold_intra $res_intra


bash $NCHG_dir/preprocess_scripts-master/make_gtrack.sh $chrom3D/intrachr_bedpe/sample.$res_intra.domain.RAW.bedpe.sig $domains/sample_Arrowhead_domainlist.domains $chrom3D/intrachr_bedpe/$name.woLADS.gtrack

if [ -z "$LADS" ]
then
   echo "\$LADS not provided"
   echo "excluding LADs as a model constrain"
else
  echo "\$LADS provided"
  echo "adding LADs as a model constrain"
  bash $NCHG_dir/preprocess_scripts-master/make_gtrack_incl_lad.sh $chrom3D/intrachr_bedpe/$name.woLADS.gtrack $LADS $chrom3D/intrachr_bedpe/$name.wLADS.gtrack
fi
# bash $NCHG_dir/preprocess_scripts-master/make_gtrack_incl_lad.sh $chrom3D/intrachr_bedpe/$name.woLADS.gtrack $LADS $chrom3D/intrachr_bedpe/$name.wLADS.gtrack

bash $NCHG_dir/preprocess_scripts-master/interchr_NCHG.automat.sh $chromosome_size $black_list $res_inter $chrom3D > $chrom3D/$name.inter.bedpe

$NCHG_dir/NCHG -i -p $chrom3D/$name.inter.bedpe > $chrom3D/$name.inter.bedpe.out

cd $NCHG_dir/preprocess_scripts-master

$NCHG_dir/preprocess_scripts-master/NCHG_fdr_oddratio_calc_inter.automat.sh $chrom3D $name $stats $thresold_inter

### LADS loop
if [ -z "$LADS" ]
then
   echo "\$LADS not provided"
   echo "excluding LADs as a model constrain"
   bash $NCHG_dir/preprocess_scripts-master/add_inter_chrom_beads_wo_lads.sh $chrom3D/intrachr_bedpe/$name.woLADS.gtrack $chrom3D/$name.inter.bedpe.sig $chrom3D/$name.inter_intra.gtrack
else
  echo "\$LADS provided"
  echo "adding LADs as a model constrain"
  bash $NCHG_dir/preprocess_scripts-master/add_inter_chrom_beads.sh $chrom3D/intrachr_bedpe/$name.wLADS.gtrack $chrom3D/$name.inter.bedpe.sig $chrom3D/$name.inter_intra.gtrack
fi

$NCHG_dir/preprocess_scripts-master/make_diploid.sh $chrom3D $name

if [ $sex = "female" ]
then
        grep -v chrY $chrom3D/$name.inter_intra.diploid.gtrack > $chrom3D/$name.inter_intra.female.diploid.gtrack
        rm $chrom3D/$name.inter_intra.diploid.gtrack
elif [ $sex = "none" ]
then
        grep -v chrX $chrom3D/$name.inter_intra.diploid.gtrack > $chrom3D/temp
        grep -v chrY $chrom3D/temp > $chrom3D/$name.inter_intra.autosomes.diploid.gtrack
        rm $chrom3D/temp
        rm $chrom3D/$name.inter_intra.diploid.gtrack
else
        grep -v chrX $chrom3D/$name.inter_intra.diploid.gtrack > $chrom3D/$name.inter_intra.male.diploid.gtrack
        rm $chrom3D/$name.inter_intra.diploid.gtrack
fi

rm $chrom3D/*0.matrix $chrom3D/*0.bed $NCHG_dir/preprocess_scripts-master/diff*

