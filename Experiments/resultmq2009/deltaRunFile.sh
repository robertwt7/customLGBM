script="./deltaScore.py"


for entry in ./evalPerQ*
do
	if [ $entry != "./evalPerQueryBM25" ]; then
		temp=$(echo $entry | cut -d'y' -f 2 | cut -d'Y' -f 2)
		python3 $script evalPerQueryBM25 $entry ndcg@5 ./deltaNDCG/$temp-bm25
	fi
done
