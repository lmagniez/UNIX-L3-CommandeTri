#! /bin/bash

function afficherElt()
{	
	OLD_IFS=$IFS
	res=`find . -maxdepth 1 -name "*" | awk '{print $0":"}'`
	echo $res
	
	IFS=":"
	for i in $res
	do
		echo $i
	done
	
	IFS=$OLD_IFS
	
	
	#sed -n 3p 
	
}

#ls -l | awk '{print $1":"$2":"$3}'

#awk 'END {print NR}' fichier 	#imprime le nombre total de lignes du fichiers

#ls -al | sed -n 3p #imprimer 3e ligne

#res= `ls -al`
#print "$res"

#afficherElt 4


for i in `find . -maxdepth 1 -name "*"`
do
	echo $i
done

for i in `ls "$1"`
do
	echo "ok"
done 

afficherElt
