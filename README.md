# automat_chrom3D
This is a wrapper of the gtrack diploid preparation files pipeline to run chrom3D (https://github.com/Chrom3D/pipeline)

# Required dependencies 
- Python 2.7 
- pybedtools
- statsmodels
- bedtools
- [NCHG](http://folk.uio.no/jonaspau/hic/NCHG_hic.zip)

Download and install NCHG 

```curl -O http://folk.uio.no/jonaspau/hic/NCHG_hic.zip ``` 
\  ```unzip NCHG_hic.zip ```
\  ```cd NCHG_hic ``` 
\  ```make ``` 
\  ```export PATH=$PATH:${PWD} ```   


# Usage

```./automat_chrom3D.sh hic_pro_results_PATH output_folder_PATH name_experiment chromosome_size_PATH arrowhead_PATH black_list_PATH NCHG_PATH```

