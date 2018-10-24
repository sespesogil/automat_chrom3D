
#!/bin/bash

module load boost/1.60.0 chimera/1.6.2 python py_packages bedtools

dir=$1   # path to hic_pro_results
chrom3D=$2  #path where the chrom3D files will be
name=$3 #given name to the experiment
chromosome_size=$4 #chromosome_size
domains_50kb=$5  #Arrowhead path
black_list=$6 #black list 
NCHG_dir=$7
LADS=$8

(sleep 10 & )

mkdir $2

find $dir -name '*50000.matrix' -exec cp {} $chrom3D  \;
find $dir -name '*1000000.matrix' -exec cp {} $chrom3D  \;
find $dir -name '*50000_abs.bed' -exec cp {} $chrom3D  \;
find $dir -name '*1000000_abs.bed' -exec cp {} $chrom3D  \;

matrix_intra=$chrom3D/*50000.matrix
abs_intra=$chrom3D/*50000_abs.bed

$NCHG_dir/preprocess_scripts-master/conv_hicpro_mat_intra.sh $matrix_intra $abs_intra $name

mv $NCHG_dir/preprocess_scripts-master/$name.intra.intermediate.bedpe $chrom3D/

mkdir $chrom3D/intra_chr_RAWobserved

bash $NCHG_dir/preprocess_scripts-master/make_intrachr_rawObserved_50kb.sh $chromosome_size $chrom3D/$name.intra.intermediate.bedpe

mv $NCHG_dir/preprocess_scripts-master/intra_chr_RAWobserved $chrom3D/

## creating interchromosomal 

matrix_inter=$chrom3D/*1000000.matrix
abs_inter=$chrom3D/*1000000_abs.bed

$NCHG_dir/preprocess_scripts-master/conv_hicpro_mat_inter.sh $matrix_inter $abs_inter $name

mv $NCHG_dir/preprocess_scripts-master/$name.inter.intermediate.bedpe $chrom3D/

bash $NCHG_dir/preprocess_scripts-master/make_interchr_rawObserved_1MB.sh $chromosome_size $chrom3D/$name.inter.intermediate.bedpe

mv $NCHG_dir/preprocess_scripts-master/inter_chr_RAWobserved $chrom3D/

###########################################################################
### Arrowhead (Aggregation of Hi-C contact counts for all pairs of TADs)###
###########################################################################

bash $NCHG_dir/preprocess_scripts-master/arrowhead_to_domains.sh $domains_50kb/50000_blocks.bedpe $chromosome_size

cat $domains_50kb/*.chr*.domains > $domains_50kb/sample_Arrowhead_domainlist.domains

# Compute intra-chromosomal interaction counts between TADs

bash $NCHG_dir/preprocess_scripts-master/intrachr_NCHG_input_auto.sh 50000_blocks $chromosome_size 50kb $domains_50kb $chrom3D

mv $NCHG_dir/preprocess_scripts-master/intrachr_bedpe $chrom3D/

cat $chrom3D/intrachr_bedpe/chr*.bedpe/chr*.bedpe > $chrom3D/intrachr_bedpe/sample_50kb.domain.RAW.bedpe


#(i) Calculate the P-value and odds ratio for each pair of TADs

$NCHG_dir/NCHG -m 50000 -p $chrom3D/intrachr_bedpe/sample_50kb.domain.RAW.bedpe > $chrom3D/intrachr_bedpe/sample_50kb.domain.RAW.bedpe.out

cd $NCHG_dir/preprocess_scripts-master

$NCHG_dir/preprocess_scripts-master/NCHG_fdr_oddratio_calc_intra.sh $chrom3D

# Create the Model Setup File (GTrack)

bash $NCHG_dir/preprocess_scripts-master/make_gtrack.sh $chrom3D/intrachr_bedpe/sample_50kb.domain.RAW.bedpe.sig $domains_50kb/sample_Arrowhead_domainlist.domains $chrom3D/intrachr_bedpe/$name.gtrack

# (ii) Add LAD information to the GTrack (OPTIONAL)

bash make_gtrack_incl_lad.sh $chrom3D/intrachr_bedpe/$name.gtrack $LADS $chrom3D/intrachr_bedpe/$name.wLADS.gtrack 

# (iii) Prepare inter-chromosomal Hi-C interaction counts

bash $NCHG_dir/preprocess_scripts-master/interchr_NCHG_input_auto_1MB.sh $chromosome_size $black_list 1mb $chrom3D > $chrom3D/$name.inter.bedpe

# (iv) Call significant inter-chromosomal interactions
$NCHG_dir/NCHG -i -p $chrom3D/$name.inter.bedpe > $chrom3D/$name.inter.bedpe.out

# (v) Calculate FDR and filter significant interactions
cd $NCHG_dir/preprocess_scripts-master

$NCHG_dir/preprocess_scripts-master/NCHG_fdr_oddratio_calc_inter.sh $chrom3D $name


# (vi) Add significant inter-chromosomal interaction information to the GTrack

bash $NCHG_dir/preprocess_scripts-master/add_inter_chrom_beads.sh $chrom3D/intrachr_bedpe/$name.wLADS.gtrack $chrom3D/$name.inter.bedpe.sig $chrom3D/$name.inter_intra.gtrack
# (vii) Modify the Model Setup File to make a diploid model

$NCHG_dir/preprocess_scripts-master/make_diploid.sh $chrom3D $name



