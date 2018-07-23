#!/bin/bash

filecreate(){
echo -n "Enter the filename: "
read filename
cat >> $filename.txt
}
snippetcreation(){
snippetans=true
while($snippetans)
do
	filecreate
	echo -n "Do you want to create another file?"
	read snippetanotherans
	echo -n "$snippetanotherans"
	snippetanotherans=${snippetanotherans,,}
	echo -n "$snippetanotherans"
	
	if [[ $snippetanotherans == "no" || $snippetanotherans == "n" ]]
	then 
		snippetans=false
	fi
done
}

echo -n "Is it a snippet component?" 
read ans
if [[ $ans == "yes" ]]
then
	snippetcreation
else 
	exit
fi

