#!/bin/bash

# Arg1 - Arrowhead domainlist
# Arg2 - chromosome size --- Make sure it is sorted and chrY removed 


filename="${1%.*}"
sed 's/'chr'//g' $1 | sort -k1,1 -k2,2n - | mergeBed -i - | awk '{print "chr"$1 "\t" $2 "\t" $3 "\tdomain"}' - > TAD.consensus.merged.bed
sort -k1,1 -k2,2n $2 > genome
complementBed -i TAD.consensus.merged.bed -g genome | cat - TAD.consensus.merged.bed | sort -k1,1 -k2,2n - | awk '{if($4=="domain") print $0; else print $1 "\t" $2 "\t" $3 "\tgap"}'  > TADconsensus.GapDomains

arr=( $(cut -f1 genome | sed 's/'chr'//g') )

for i in ${arr[@]}
do
  chromosome=chr$i
  awk '$1==chr' chr="$chromosome" TADconsensus.GapDomains >  TADconsensus.$chromosome.domains
done
rm genome
