FASTA_FILE=$1
num_seq=$(grep -c ">" "$FASTA_FILE")
length_seq=$(awk '!/>/{sum += length($1)} END {print sum}' "$FASTA_FILE")
longest_seq=$(awk '!/>/ {if (length > max) max = length} END {print max}' "$FASTA_FILE")
shortest_seq=$(awk '!/>/ {if (min == 0 || length < min) min = length} END {print min}' "$1") 
average_length=$(awk "BEGIN {print $length_seq/$num_seq}")
gc_content=$(grep -v ">" "$1" | grep -o "[GCgc]" | wc -l)
gc_percent=$(awk "BEGIN {print ($gc_content/$length_seq)*100}")

echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_seq"
echo "Total length of sequences: $length_seq"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_seq"
echo "Average sequence length: $average_length"
echo "GC Content (%): $gc_percent"
