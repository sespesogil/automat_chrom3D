import sys

chrsize_file=str(sys.argv[1])

f=open(chrsize_file)
chrsize={}
for l in f:
  chrsize[l.split()[0]] = int(float(l.split()[1]))

for n in sys.stdin:
  n = n.split()
  if int(n[2]) > chrsize[n[0]]:
    n[2] = chrsize[n[0]]
  if int(n[5]) > chrsize[n[3]]:
    n[5] = chrsize[n[3]] 
  n = map(str,n)
  print '\t'.join(n) 
