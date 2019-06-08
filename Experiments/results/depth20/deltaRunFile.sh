script="../deltaScore.py"


for entry in ./evalPerQ*
do
	if [ $entry != "./evalPerQuerySOTABM25" ]; then
		temp=$(echo $entry | cut -d'y' -f 2 | cut -d'Y' -f 2)
		python3 $script evalPerQuerySOTABM25 $entry ndcg@20 ./deltandcg20/$temp-bm25
	fi
done
