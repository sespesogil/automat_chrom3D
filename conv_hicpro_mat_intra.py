
import sys

matrix_fname = sys.argv[1]
abs_fname = sys.argv[2]

with open(abs_fname) as af:
  afl = af.readlines()


abs_dict = {}
for l in afl:
  l = l.rstrip()
  l = l.split()
  abs_dict[l[3]] = l[0] + "\t" + str(l[1]) + "\t" + str(l[2])

with open(matrix_fname) as mf:
  mfl = mf.readlines()

for l in mfl:
  l = l.rstrip()
  l = l.split()
  print abs_dict[l[0]] + "\t" + abs_dict[l[1]] + "\t" + str(l[2])
