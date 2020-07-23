# automat_chrom3D
LSF/TORQUE(MOAB) wrapper for mouse and human HiC gtrack diploid preparation to run chrom3D (https://github.com/Chrom3D/pipeline). 

See publications and visit the original [pipeline](https://github.com/Chrom3D/pipeline) from [Collas Lab](http://collaslab.org/) to learn more about the tool:

-[Paulsen et al.2017](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-1146-2) <br/>

-[Paulsen et al.2018](https://www.nature.com/articles/nprot.2018.009) 


# Major updates (January 2020) 

Active development is taking place to add more functionalities to this utility. This wrapper is an automated compilation of the scripts used by Collas lab with some modifications and adding the following characteristics to the previous Chrom3D pipeline:<br/>

- Possibility to create Mouse Chrom3D models 
- Sex chromosome correction
- TAD size and number evaluation 
- Intra and interchromosomal interaction frequency evaluation (still under development) 

# Required dependencies 
- Python 2.7 
- pybedtools
- statsmodels
- bedtools
- [NCHG](http://folk.uio.no/jonaspau/hic/NCHG_hic.zip)
- R 
- ggplot2

# Installation

Download and install NCHG 

```curl -O http://folk.uio.no/jonaspau/hic/NCHG_hic.zip ``` <br/>
```unzip NCHG_hic.zip ``` <br/>
```cd NCHG_hic ```  <br/>
```make ```  <br/>
```export PATH=$PATH:${PWD} ```   

Then 
``` cd path/NCHG/preprocess_scripts-master``` <br/>
``` git clone https://github.com/sespesogil/automat_chrom3D.git ``` <br/>
``` mv automat_chrom3D/* . ``` <br/>

Suggested: open all permissions to every file 

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
LADS=   # LADs bedfile
specie=    #(human or mouse accepted, specify) 
cytoBand=  # cytoBand bedfile (only for human)
```
Then run: 
```./automat_chrom3D.sh $(cat conf.txt)```

# Disclamer

The present pipepile evaluates the number and size of the TADs, as well as intra & interchromosomal distributions, as they are key parts for the 3D model generation. It is recommended to run the pipeline with different parameters in a first run. Resulting Gtracks with low number of beads in a given chromosome will fail a Chrom3D run (i.e chrY is very often giving problems, we recommend to set "female" or "none" in the sex argument of the configuration file (that will remove chrY to be considered) 

