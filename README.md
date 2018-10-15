# automat_chrom3D
This is a wrapper of the gtrack diploid preparation files pipeline to run chrom3D (https://github.com/Chrom3D/pipeline)

# Required dependencies 
- Python 2.7 
- pybedtools
- statsmodels
- bedtools
- [NCHG](http://folk.uio.no/jonaspau/hic/NCHG_hic.zip)

Download and install NCHG 

```curl -O http://folk.uio.no/jonaspau/hic/NCHG_hic.zip ``` <br/>
```unzip NCHG_hic.zip ``` <br/>
```cd NCHG_hic ```  <br/>
```make ```  <br/>
```export PATH=$PATH:${PWD} ```   

Add to the preprocess__script-master folder the following scripts found in this repository.

# Usage

Use the following script if you have LADS:
```./automat_chrom3D.LADS.sh hic_pro_results_PATH output_folder_PATH name_experiment chromosome_size_PATH arrowhead_PATH black_list_PATH NCHG_PATH LADS.bed```

Otherwise:
```./automat_chrom3D.woLADS.sh hic_pro_results_PATH output_folder_PATH name_experiment chromosome_size_PATH arrowhead_PATH black_list_PATH NCHG_PATH LADS.bed```

