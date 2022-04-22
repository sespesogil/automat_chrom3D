#!/bin/bash

# Arg1 - Arrowhead domainlist
# Arg2 - chromosome size --- Make sure it is sorted and chrY removed 


filename="${1%.*}"

tail -n +2 $1 | sort -k1,1 -k2,2n | awk -F"\t" '{print $1"\t"$2"\t"$3"\t""domains"}' - > ${filename}.merged.bed
sort -k1,1 -k2,2n $2 > genome
complementBed -i ${filename}.merged.bed -g genome | awk -F"\t" '{print $1"\t"$2"\t"$3"\t""gap"}' | cat - ${filename}.merged.bed | sort -k1,1 -k2,2n > ${filename}.domains
        
arr=( $(cut -f1 genome | sed 's/'chr'//g') )

for i in ${arr[@]}
do
  chromosome=chr$i
  awk '$1==chr' chr="$chromosome" ${filename}.domains >  ${filename}.$chromosome.domains
done
rm genome
