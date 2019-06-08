eval="/research/remote/petabyte/users/robert/Utilities/grdeval/target/release/grdeval"
#Change qrels to Test for test
qrels="../qrels.yahooTest"

touch out.txt

for entry in ./test/tree*
do
	TMP5=$(mktemp -p .)
	#Change f to 4 for test set (folder test has 'e'), to 3 for valid
	name=$(echo $entry | cut -d'e' -f 4)
	($eval -k 5 $qrels $entry | tail -n 1 > $TMP5)
	echo -n "ndcg_5," >> out.txt
	echo -n $name"," >> out.txt
	awk -F, '{printf "%.4f\n", $3}' $TMP5 >> out.txt
	rm $TMP5
done
cat out.txt | sed -e 's/,/ /g' | sort -k2n > outsorted.tsv
