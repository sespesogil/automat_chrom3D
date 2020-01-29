CHRS=$(cut -f 1 $1)
is=( $CHRS )
js=( $CHRS )
N=$((${#is[@]}-1))

for i in $(seq 0 $(($N-1)))
do
  for j in $(seq $(($i+1 <= $N ? $i+1: $i)) $N)
  do
    chrI=${is[$i]};
    chrJ=${js[$j]};
    chrJ2=$(echo $chrJ | sed -e 's/chr//')
    mkdir ./inter_chr_RAWobserved/
    mkdir ./inter_chr_RAWobserved/$chrI\_$chrJ2\_inter.RAWobserved/    
    awk -v RES=$RES -v CHRI=$chrI -v CHRJ=$chrJ '{if($1==CHRI && $4==CHRJ) print $2 "\t" $5 "\t" $7}' $2 > ./inter_chr_RAWobserved/$chrI\_$chrJ2\_inter.RAWobserved/$chrI\_$chrJ2\_inter.RAWobserved
  done
done
