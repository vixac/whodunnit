
all_files="$WHO_DIR/output/all_files_output.txt"
filtered_files="$WHO_DIR/output/filtered_files.txt"
blame_output=$WHO_DIR/output/blame_output.txt
$WHO_DIR/scripts/all_files.sh > $all_files 
swift run --package-path $WHO_DIR WhoFiles --list-of-files $all_files --suffixes "swift plist" > $filtered_files
swift run --package-path $WHO_DIR Whodunnit $filtered_files > $blame_output
echo "Whodunnit complete! Your output is waiting for you in $blame_output"

