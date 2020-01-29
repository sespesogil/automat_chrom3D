
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"


chrom3D_dir=$1
stats=$2
thresold=$3
res=$4

python NCHG_fdr_oddratio_calc.py $chrom3D_dir/intrachr_bedpe/sample.$res.domain.RAW.bedpe.out $stats 2 $thresold > $chrom3D_dir/intrachr_bedpe/sample.$res.domain.RAW.bedpe.sig







