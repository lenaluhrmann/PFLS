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
bin_count=1
    mag_count=1

    for i in $(seq 1 $(echo $completness | wc -w)); do
        c_value=$(echo $completness | cut -d' ' -f$i)
        co_value=$(echo $contamination | cut -d' ' -f$i)

        if (( $(echo "$c_value > 50.00" | bc -l) )) && (( $(echo "$co_value < 5.00" | bc -l) )); then
            classification="MAG"
            new_file_name="${name}_MAG_$(printf "%03d" $mag_count).fa"
            mag_count=$((mag_count + 1))
        elif (( $(echo "$co_value < 5.00" | bc -l) )); then
            classification="BIN"
            new_file_name="${name}_BIN_$(printf "%03d" $bin_count).fa"
            bin_count=$((bin_count + 1)) 
        fi
        cp "${directory}checkm.txt" "../COMBINED-DATA/${name}-CHECKM.txt"
        cp "${directory}gtdb.gtdbtk.tax" "../COMBINED-DATA/${name}-GTDB-TAX.txt"
        cp "${directory}bins/bin-unbinned.fasta" "../COMBINED-DATA/${name}_UNBINNED.fa"
        cp "${directory}bins/bin-unbinned.fasta" "../COMBINED-DATA/${new_file_name}"
        for fasta in "${directory}bins/"*; do
            file_name="${fasta#${directory}bins/}"
            if [[ "$file_name" =~ ^bin-[0-9].* ]]; then
                current_dna=$(basename "$directory")
                current_number=$(echo "$current_dna" | sed 's/[^0-9]*//g') 
                next_number=$((current_number + 1))
                next_dna_dir=$(echo "$directory" | sed "s/$current_dna/DNA$next_number/")
                target_dir="../EXC-004/RAW-DATA/$next_dna_dir/bins"
                mkdir -p "$target_dir"
                new_file_name="$target_dir/${classification}-${file_name}"
                mv "$fasta" "$new_file_name"
            fi
        done
    done
done
