
all_files="output/all_files_output.txt"
filtered_files="output/filtered_files.txt"
./scripts/all_files.sh > $all_files 
swift run WhoFiles --list-of-files $all_files --suffixes "swift plist" > $filtered_files
swift run Whodunnit $filtered_files > output/blame_output.txt

