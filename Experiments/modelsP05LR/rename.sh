leaves=(15 31 63)                                                                                         
trees=(100 300 500 1000 1500)                                                                             
feat_fractions=(0.6 0.8 0.9)
                                                                                                          
for leave in ${leaves[@]}                                                                                 
do                                                                                                        
        for tree in ${trees[@]}                                                                           
        do                                    
		for feat in ${feat_fractions[@]}
                do                                            
			mv "$leave Leaves $tree Trees $feat feat_fraction.txt" "$leave.$tree.$feat.Leaves.tree.Featfrac.txt"
        	done
	done                                                                                              
done                                                                                                      
