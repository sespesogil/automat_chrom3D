#!/bin/bash

gtrack_w_lad=$1
inter_chr_sig=$2
out=$3

python inter_chrom_beads.py $gtrack_w_lad $inter_chr_sig | sort -k1,1 -k2,2n > gtrack_tmp
#sed -i  '1s/^/##gtrack version: 1.0\n##track type: linked segments\n###seqid\tstart\tend\tid\tradius\tperiphery\tedges\n/' $out
awk 'BEGIN{print "##gtrack version: 1.0\n##track type: linked segments\n###seqid\tstart\tend\tid\tradius\tperiphery\tedges"}1' gtrack_tmp > $out
rm gtrack_tmp
