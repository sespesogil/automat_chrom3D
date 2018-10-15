
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"


chrom3D_dir=$1
name_id=$2

python NCHG_fdr_oddratio_calc.py $chrom3D_dir/$name_id.inter.bedpe.out fdr_bh 2 0.01 > $chrom3D_dir/$name_id.inter.bedpe.sig







