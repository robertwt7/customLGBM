eval="/research/remote/petabyte/users/robert/Utilities/grdeval/target/release/grdeval"
#Change qrels to Test for test"
yahoo="/research/remote/petabyte/users/robert/Utilities/ltr-baseline/yahoo1"
qrels=$yahoo/dat/set1.test.qrels

list=("run.jf.lmart.TRiskAwareSAROEval:10000:NDCG.triskSARO.1500.63.0.05.0.5" "run.jf.lmart.URiskAwareEval:100:NDCG.triskSARO.1500.63.0.05.0.5" "run.jf.lmart.URiskAwareEval:5000:NDCG.triskSARO.1500.63.0.05.0.5")
name=("evalPerQueryURISK10k" "evalPerQueryURISK100" "evalPerQueryURISK5k")

for entry in {0..2}
do
	$eval -k 5 $qrels $yahoo/run/${list[$entry]} | head -n -1 > ./${name[$entry]}
done
