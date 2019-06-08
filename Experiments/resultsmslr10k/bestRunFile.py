import numpy as np
import pandas as pd
import sys
                                                                  
if len(sys.argv) != 4:                                            
        print("usage: {} <First> <Second> <Output".format(sys.argv[0]))
        exit(1)      

pd1 = pd.read_csv(sys.argv[1])
pd2 = pd.read_csv(sys.argv[2])

a = pd1.values
b = pd2.values
df = pd.DataFrame(np.where(a > b, a, b), index=pd1.index, columns=pd1.columns)                                             

df.to_csv(sys_argv[3], index=None)
