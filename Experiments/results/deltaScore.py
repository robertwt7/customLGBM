import sys
import sklearn
import pandas as pd

if len(sys.argv) != 5:
	print("usage: {} <Baseline> <Run File> <Metrics> <Output>".format(sys.argv[0]))
	exit(1)

bpath = sys.argv[1]
rpath = sys.argv[2]
metrics = sys.argv[3]
output = sys.argv[4]

first = pd.read_csv(bpath)
second = pd.read_csv(rpath)

arr = []
for index, row in first.iterrows():
	arr.append(round(second[metrics][index] - row[metrics],4))

second['Delta' + metrics] = arr

second.to_csv(output, index=False, float_format='%.5f')
