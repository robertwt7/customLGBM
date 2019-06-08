eval="/research/remote/petabyte/users/robert/Utilities/trisk/trisk_gdeval.sh"

for entry in ./evalPerQ*
do
	if [ $entry != "./evalPerQuerySOTABM25" ]; then
		$eval $entry evalPerQuerySOTABM25 ndcg@5 > triskValue/$entry"Trisk"
	fi
done
