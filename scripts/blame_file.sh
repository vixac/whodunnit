echo " YOU ASKED FOR $1 with a pipe of output into nowhere"
x=$(git blame -lfnwM $1)
echo "$x"
