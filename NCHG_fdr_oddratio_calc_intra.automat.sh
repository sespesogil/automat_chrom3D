DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"


chrom3D_dir=$1
stats=$2
thresold=$3
res=$4

input=$chrom3D_dir/intrachr_bedpe/sample.domain.RAW.bedpe.out

python NCHG_fdr_oddratio_calc.py $input $stats 2 $thresold > $chrom3D_dir/intrachr_bedpe/sample.domain.RAW.bedpe.sig





