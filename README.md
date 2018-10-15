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

Add to the preprocess__script-master folder the scripts found in this repository.

# Usage

```PATH_hic_pro_results```= directory where to find the matrix and abs files. <br/>
```PATH_output_folder```= folder where you want to have the results. <br/>
```name_experiment```= give a name to your files. <br/>
```chromosome_sizes.bed```=give the full path and name of your chromosome sizes bedfile. <br/>
```PATH_arrowhead```= directory where to find "blocks.bed" file. <br/>
```black_list.bed```= bedfile of the genomic black list. <br/>
```PATH_NCHG``` = directory of NCHG (not the preprocess_scripts-master, just the parent directory of NCHG). <br/>
```LADS.bed```= your LADs bedfile. <br/>

Use the following script if you have LADS: <br/>
```./automat_chrom3D.LADS.sh PATH_hic_pro_results PATH_output_folder name_experiment chromosome_sizes.bed PATH_arrowhead black_list.bed PATH_NCHG LADS.bed```

Otherwise: <br/>
```./automat_chrom3D.LADS.sh PATH_hic_pro_results PATH_output_folder name_experiment chromosome_sizes.bed PATH_arrowhead black_list.bed PATH_NCHG```

