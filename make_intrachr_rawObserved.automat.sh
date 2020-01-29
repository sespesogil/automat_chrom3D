#!/bin/bash

CHRS=$(cut -f 1 $1)
is=( $CHRS )
N=$((${#is[@]}-1))
res=$3

for i in $(seq 0 $N)
do
	chrI=${is[$i]}
	mkdir ./intra_chr_RAWobserved
	mkdir ./intra_chr_RAWobserved/${chrI}.${res}.RAWobserved
	awk -v CHRI=$chrI '{if($1==CHRI && $4==CHRI) print $2 "\t" $5 "\t" $7}' $2 > ./intra_chr_RAWobserved/${chrI}.${res}.RAWobserved/${chrI}.${res}.RAWobserved
done
