import math
import sys
from statsmodels.sandbox.stats import multicomp


with open(sys.argv[1]) as infileH:
  infile = infileH.readlines()

method = str(sys.argv[2])
log_ratio = float(sys.argv[3])
fdr_thres = float(sys.argv[4])

infile = [x.strip() for x in infile]

pval = []
padj = []
processline = []
for line in infile:
  line = line.split()
  pval.append(float(line[6]))
  if(float(line[9]) == 0 or float(line[10]) == 0):
    logratio = 0.0
  else:
    logratio = math.log(float(line[9]),2) - math.log(float(line[10]),2)

  line = ' '.join(line) + ' ' + str(logratio)
  processline.append(line)

padj = list(multicomp.multipletests(pval,method=method))

for i in range(len(processline)):
  line = processline[i] + " " + str(padj[1][i])
  line  = line.split()
  if(float(line[11]) >= log_ratio and float(line[12]) <= fdr_thres):
    print line[0] + "\t" + line[1] + "\t" + line[2] + "\t" + line[3] + "\t" + line[4] + "\t" + line[5] + "\t" + line[12] 
