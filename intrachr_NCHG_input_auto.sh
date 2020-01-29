#!/bin/bash

base=$1
CHRS=$(cut -f 1 $2)
res=$3
is=( $CHRS )
N=$((${#is[@]}-1))

domains_50kb=$4
chrom3D=$5

for i in $(seq 0 $N)
do
  chrI=${is[$i]}
  mkdir ./intrachr_bedpe/
  mkdir ./intrachr_bedpe/${chrI}.${res}.domains.RAW.bedpe
  bash make_NCHG_input.sh $domains_50kb/${base}.${chrI}.domains $chrom3D/intra_chr_RAWobserved/${chrI}.${res}.RAWobserved/${chrI}.${res}.RAWobserved ${chrI} > ./intrachr_bedpe/${chrI}.${res}.domains.RAW.bedpe/${chrI}.${res}.domains.RAW.bedpe
done
