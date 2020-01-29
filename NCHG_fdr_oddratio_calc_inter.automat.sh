
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"


chrom3D_dir=$1
name_id=$2
stats=$3
thresold=$4

python NCHG_fdr_oddratio_calc.py $chrom3D_dir/$name_id.inter.bedpe.out $stats 2 $thresold > $chrom3D_dir/$name_id.inter.bedpe.sig







