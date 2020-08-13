
all_files="output/all_files_output.txt"
filtered_files="output/filtered_files.txt"
./scripts/all_files.sh > $all_files 
swift run WhoFiles --list-of-files $all_files --suffixes "plist" > $filtered_files
