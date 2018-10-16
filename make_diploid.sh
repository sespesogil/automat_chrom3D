DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"



chrom3D_dir=$1
name_id=$2



python make_diploid_gtrack.py $chrom3D_dir/$name_id.inter_intra.gtrack >  $chrom3D_dir/$name_id.inter_intra.diploid.gtrack
