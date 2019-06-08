echo "alpha urisk trisk pvalue models" > all.Trisk.txt

for entry in ./evalPerQ*
do
	name=$(echo $entry | cut -d'y' -f 2 | cut -d'Y' -f 2)
	cat $entry \
	| awk -F ',' -v var=$name '{print $1,$2,$3,$4,var}' \
	| tail -n +2 >> all.Trisk.txt
done
