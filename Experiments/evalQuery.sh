#set -x                                                                                        
#!/bin/bash                                                                                    
BASEDIR="/research/remote/petabyte/users/robert/"                                              
EVALDIR="/research/remote/petabyte/users/robert/test-indri/trec_eval"                          
GDEVALDIR="/research/remote/petabyte/users/robert/trec-web-2013/src/eval/gdeval.pl"            
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"                                        
Out="resultsPerQuery.tsv"                                                                              
leaves=(15 31 63)                                                                              
trees=(100 300 500 1000 1500)                                                                  
feat_fractions=(0.6 0.8 0.9)           
LR="P1"                                                        
                                                                                               
echo "models,query,ndcg@5,LearningRate" > $Out                                                                    
                                                                                               
for leave in ${leaves[@]}                                                                      
do                                                                                             
        for tree in ${trees[@]}                                                                
        do                                                                                     
                for feat in ${feat_fractions[@]}                                               
                do                                                                             
                        temp="$leave.$tree.$feat"                                              
                        temp2=$($EVALDIR -m all_trec -q $BASEDIR/LightGBM/Experiments/qrels.yahooTest $BASEDIR/LightGBM/Experiments/predictions1LR/"$leave.$tree.$feat.Leaves.tree.Featfrac" | grep -e "ndcg_cut_5 " | awk -v model="$temp" -v rate="$LR" -v OFS=',' '{print model,$2,$3,rate}')
			echo "$temp2" >> $Out
                done                                                                           
        done                                               
done                                                                                           
                                                                                               
# $1 is a valid trec run file                                                                  
echo "DIR=$DIR"                                                                                

