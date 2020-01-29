

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

matrix=$1
abs=$2
name=$3

python conv_hicpro_mat_inter.py $matrix $abs > $name.inter.intermediate.bedpe 


