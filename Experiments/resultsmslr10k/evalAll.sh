eval="/research/remote/petabyte/users/robert/Utilities/grdeval/target/release/grdeval"
#Change qrels to Test for test"
mslr="/research/remote/petabyte/users/robert/Utilities/ltr-baseline/mslr10k"
qrels=$mslr/dat/all.test.qrels
list=("run.all.jf.lmart.TRiskAwareSAROEval:1000:NDCG.1500.63.0.05" "run.all.jf.lmart.TRiskAwareSAROEval:5000:NDCG.1500.63.0.05" "run.all.jf.lmart.TRiskAwareSAROEval:10000:NDCG.1500.63.0.05")
name=("SARO1000" "SARO5000" "SARO10k")

for entry in {0..2}
do
	$eval -k 5 $qrels $mslr/run/${list[$entry]} | head -n -1 > evalPerQuery${name[$entry]}
done
