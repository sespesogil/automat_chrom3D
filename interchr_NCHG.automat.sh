CHRS=$(cut -f 1 $1)
blacklist=$2
res=$3
is=( $CHRS )
js=( $CHRS )
N=$((${#is[@]}-1))

p=$4

RES=1000000

awk -v RES=$RES '{if($2-RES<0) print $1 "\t" $2 "\t" $3+RES; else print $1 "\t" $2-RES "\t" $3+RES}' $2 > blacklist.tmp


for i in $(seq 0 $(($N-1)))
do
  for j in $(seq $(($i+1 <= $N ? $i+1: $i)) $N)
    do     
      chrI=${is[$i]};
      chrJ=${js[$j]};
      chrJ2=$(echo $chrJ | sed -e 's/chr//')
      awk -v RES=$RES -v CHRI=$chrI -v CHRJ=$chrJ '{printf("%s\t%s\t%s\t%s\t%s\t%s\t%d\n",CHRI,$1,$1+RES,CHRJ,$2,$2+RES,$3)}' $p/inter_chr_RAWobserved/$chrI\_$chrJ2\_inter.RAWobserved/$chrI\_$chrJ2\_inter.RAWobserved
    done
done | bedtools pairtobed -type neither -a stdin -b blacklist.tmp | python cap_chr_end.py $1
rm blacklist.tmp
