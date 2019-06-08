eval="/research/remote/petabyte/users/robert/Utilities/trisk/trisk_gdeval.sh"

for entry in ./evalPerQ*
do
	if [ $entry != "./evalPerQueryBM25" ]; then
		$eval $entry evalPerQueryBM25 ndcg@5 > triskValue/$entry"Trisk"
	fi
done
