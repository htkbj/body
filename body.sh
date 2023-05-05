#!/bin/bash

# Number of Lines
NoL=5

eXiT=false

# Store the last arg as file if file exists
FILE=$(echo "$@" | perl -pe 's/.* (.*)$/$1/g')
if ! [[ $(ls $FILE) == "$FILE" ]]
then
	echo "Error muther fucker"
	exit 1
fi

# Number of lines in the file with the grepped string
lines=$(grep -n $1 $FILE | perl -pe 's/\:.*\n/ /' | sed 's/ $//')

FLen=$(cat $FILE | wc -l)

for i in $lines
do
	ULim=$(($i+$NoL))
	LLim=$(($i-$NoL))
	[[ $(($i<$NoL)) == "1" ]] && LLim=0 
	[[ $(($i+$NoL>$FLen)) == "1" ]] && ULim=$FLen

	
	awk "NR>=$LLim&&NR<=$(($i-1))" $FILE
	grep --color=auto $1 $FILE
	awk "NR>=$(($i+1))&&NR<=$ULim" $FILE
	
	if ! [[ $(echo $lines | perl -pe 's/ /\n/g' | wc -l) == 1 ]]
	then	
		echo
		echo "---------"
		echo
	fi
done
