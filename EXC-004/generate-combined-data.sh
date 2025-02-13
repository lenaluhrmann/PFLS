mkdir -p "COMBINED-DATA"
cd RAW-DATA

for directory in D*/;
do
    translation=$(grep "^${directory%/}" sample-translation.txt)
    name=$(echo "$translation" | awk '{print $2}')
    cp "${directory}checkm.txt" "../COMBINED-DATA/${name}-CHECKM.txt"
    cp "${directory}gtdb.gtdbtk.tax" "../COMBINED-DATA/${name}-GTDB-TAX.txt"
    cp "${directory}bins/bin-unbinned.fasta" "../COMBINED-DATA/${name}_UNBINNED.fa"
	completness=$(awk 'NR>=3 {print $13}' "${directory}checkm.txt" | tr -s '\n' ' ')
    contamination=$(awk 'NR>=3 {print $14}' "${directory}checkm.txt" | tr '\n' ' ')

	for value in $completness; do
    if (( $(echo "$value > 50.00" | bc -l) )); then
        echo "$value ist ein MAG"
    fi
done
	for value in $contamination; do
	    if (( $(echo "$value < 5.00" | bc -l) )); then
       	 echo "$value ist ein bin"
    fi
done
done 
exit

    for fasta in ${directory}bins/*;
        do 
            file_name="${fasta#${directory}bins/}"
            if [[ "$file_name" =~ ^bin-[0-9].* ]];
            then 
                
                echo $file_name
            fi

        done
done 

