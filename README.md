# automat_chrom3D
LSF wrapper of the gtrack diploid preparation pipeline to run chrom3D (https://github.com/Chrom3D/pipeline).  

Current version was developped for mouse (disregarding centromeres). Future versions will include this parameter.

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
Add corresponding arguments to the conf.txt:

```
dir= #HiC-Pro results path 
res_intra=50000  # desired resolution of intra-chromosomal interactions 
res_inter=1000000 # desired resolution of inter-chromosomal interactions 
sex=  # options: female/male/none 
stats=   # options: bonferroni, sidak, holm-sidak, holm, simes-hochberg, hommel, fdr_bh, fdr_by, fdr_tsbh, fdr_tsbky 
thresold=  # multitest p-value thresold 
chrom3D= # output folder 
name=  # name of the experiment 
chromosome_size= # bedfile of chromosome sizes 
domains=  #Arrowhead path 
black_list=  #genomic blacklist bedfile path 
NCHG_dir=  # NCHG_hic path (i.e. ./programs/NCHG_hic) 
cytoBand=  # cytoBand bedfile 
LADS=   # LADs bedfile
```
Then run: 
```./automat_chrom3D.sh $(cat conf.txt)```

# Disclamer

We recomend to run the pipeline with different parameters in a first run. Resulting chromosomes with low number of beads will result in a failed run of Chrom3D (i.e chrY is very often giving problems, if so we recomend to set female or none in the sex argument, that will remove chrY to be considered) 


```PATH_hic_pro_results```= directory where to find the matrix and abs files. <br/>
```PATH_output_folder```= folder where you want to have the results. <br/>
```name_experiment```= give a name to your files. <br/>
```chromosome_sizes.bed```=give the full path and name of your chromosome sizes bedfile. <br/>
```PATH_arrowhead```= directory where to find "blocks.bed" file. <br/>
```black_list.bed```= bedfile of the genomic black list. <br/>
```PATH_NCHG``` = directory of NCHG (not the preprocess_scripts-master, just the parent directory of NCHG). <br/>
```LADS.bed```= your LADs bedfile. <br/>

Use the following script if you have LADS: <br/>
```./automat_chrom3D.mouse.LADS.sh PATH_hic_pro_results PATH_output_folder name_experiment chromosome_sizes.bed PATH_arrowhead black_list.bed PATH_NCHG LADS.bed```

Otherwise: <br/>  
```./automat_chrom3D.woLADS.sh PATH_hic_pro_results PATH_output_folder name_experiment chromosome_sizes.bed PATH_arrowhead black_list.bed PATH_NCHG```

