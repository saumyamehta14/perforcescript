#!/bin/bash

if [[ $USER != sapbd ]]
then
	ssh -l sapbd localhost
	echo -n "sapbd login successful."
fi


if [[ $PWD = "/home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot" ]]
then
	echo $PWD
else 
	cd /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot
	echo -n "Current working directory is $PWD"
fi

directory_create(){
	mkdir -p "$BASE/download/src/../../cp/src"
	cd "$BASE/download/src"
	echo -n "Please enter the url: "
	read URLPATH
	wget $URLPATH
	FILE=$(basename "$URLPATH")
	echo -n "File Extension is: $FILE"
	modificationtobasename="${BASE//^/-}"
}

copy_binary(){
	mv /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/download/src/ /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/download/bin/
	mv /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/cp/src/ /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/cp/bin/
	cp /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/download/bin/* /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/cp/bin/
}

binaryperforce(){
 cp /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/download/bin/* /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/cp/bin/
}

extract_sources_jar(){
if [[ "$FILE" == *".jar"* ]]; then
        #echo -n "Does it contain source code?"
        read jarsourceanswer
        if [[ "$jarsourceanswer" == "yes"|| "$jarsourceanswer" == "y" ]]
         then
                mkdir $BASE/cp/src/$modificationtobasename
                unzip $FILE -d ../../cp/src/$modificationtobasename
        else
           copy_binary
        fi
fi
}

extract_source(){

	if [[ "$FILE" == *".zip"* ]]; then
       		unzip $FILE -d ../../cp/src
	elif [[ "$FILE" == *".tar.gz"* ]] || [[ "$FILE" == *".tgz"* ]]; then
       		tar -xvzf $FILE -C ../../cp/src
	elif [[ "$FILE" == *".tar"* ]]; then
       		tar -xvf $FILE -C ../../cp/src
	elif [[ "$FILE" == *".tar.bz2"* ]]; then
        	tar -xvjf $FILE -C ../../cp/src
	else
        	echo -n "The name of the file is : $FILE"
        	echo -n "The format should be extract command and the name displayed in the above line "   #needs improvement
	        echo -n "Enter the command to extract: "
        	read extractanswer
        	$extractanswer -C ../../cp/src
	fi
}

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

snippetcreationfunction(){

 	cd /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot
        mkdir $BASE/cp/src/$modificationtobasename
        cd $BASE/cp/src/$modificationtobasename
        snippetcreation
        cd $BASE/cp/src
        zip -r $BASE/download/src/$modificationtobasename.zip $BASE/cp/src/$modificationtobasename

}


echo -n "Enter Component Name: " 
read component_name

echo -n "Enter Component Version: "
read component_version

BASE="$component_name^$component_version"
echo -n "Folder name : $BASE"


if [[ -d "/home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE" ]]
then
	echo -n "The Directory is already there. Please enter another name"
	exit
fi

directory_create

echo -n  "Is it Binary or Source Code? (Please answer b for binary, s for source code and sn for snippet)"
read binarysourceanswer
binarysourceanswer=${binarysourceanswer,,}

echo -n "$binarysourceanswer"
booleanbinarysourceanswer=true

if [[ $binarysourceanswer == "s" || $binarysourceanswer == "b" || $binarysourceanswer == "sn" ]]
then 
	booleanbinarysourceanswer=false
	echo -n "Inside a loop"
fi

echo -n "$booleanbinarysourceanswer"

while ($booleanbinarysourceanswer)
do

	echo -n "Enter either b or s or sn"
	echo -n  "Is it Binary or Source Code? (Please ans b for binary, s for source code and sn for snippet)"
	read binarysourceanswer

	if [[ $binarysourceanswer == "s" || $binarysourceanswer == "b" || $binarysourceanswer == "sn" ]]
	then
        	booleanbinarysourceanswer=false
	fi
done

if [[ $binarysourceanswer == "s" ]]
then
	extract_source

	scan=false
	if [ -e /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/cp/src/*/pom.xml ]
	then
		maven=true
		scan=true
	fi

	if [ -e /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/cp/src/*/package.json ]
	then
		npm=true
		scan=true
	fi

	if [ -e /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/cp/src/*/bower.json ]
	then
		npm=true
		scan=true
	fi

	if [[ $scan == "false" ]]
	then
		echo -n "Do you want a scan? (Please answer yes or no)"
		read wsdecisionans
		wsdecisionans=${wsdecisionans,,}
		if [[ $wsdecisionans == "yes" || $wsdecisionans == "y" ]]
		then
			
			echo -n "Please enter the URL of pom.xml for the file"
			read wsscanurl
			wget -O pom.xml $wsscanurl -P /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE/cp/src/*/
			maven=true		
		else
			echo -n "NO WS SCAN"
		fi
	fi
fi

if [[ $binarysourceanswer == "b" ]]
then
	copy_binary
fi

if [[ $binarysourceanswer == "sn" ]]
then
	snippetcreationfunction
fi

cd /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot

mkdir /home/blackduck/logging/$modificationtobasename

#perforce submit commands

find "/home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE" -type f -print | p4  -x - add | tee -a /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/logging/$modificationtobasename.txt
find "/home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/$BASE" -type f -print | p4  submit | tee -a /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/logging/$modificationtobasename.txt


if grep -q submitted /home/sapbd/blackduck/perforce1971/experiments/GTLC/CodePrint/CodePrintDepot/logging/$modificationtobasename.txt
then
	echo -n "Perforce path is : //experiments/GTLC/CodePrint/CodePrintDepot/$BASE"
else 
	echo -n "Perforce path not submitted properly. Please check error logs."
fi

if [[ "$maven" == "true" ]]
then
	cd $BASE/cp/src/*
	echo "WS SCAN WORKING DIRECTORY $PWD"
	echo "Component modified name $modificationtobasename"
	Pedigree-WS-Scan-Run-MAVEN+FSA.sh $modificationtobasename
fi

if [[ "$npm" == "true" ]]
then
	cd $BASE/cp/src/*
	echo "WS SCAN WORKING DIRECTORY IS $PWD"
	Pedigree-WS-Scan-Run-NPM+BOWER.sh
fi
