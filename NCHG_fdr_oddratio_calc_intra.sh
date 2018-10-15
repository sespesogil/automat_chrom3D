
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"


chrom3D_dir=$1


python NCHG_fdr_oddratio_calc.py $chrom3D_dir/intrachr_bedpe/sample_50kb.domain.RAW.bedpe.out fdr_bh 2 0.01 > $chrom3D_dir/intrachr_bedpe/sample_50kb.domain.RAW.bedpe.sig







