#! /bin/bash

#Retourne la liste complete des fichiers (NON RECURSIF)
function afficherElts()
{	
	OLD_IFS=$IFS
	res=`find $1 -maxdepth 1 -name "*"`	
	res=`echo "$res" | tr "\n$" ":"` #remplace saut de ligne par :
	
}

#Affiche le nom d'un element en particulier (Par défaut: SANS SON CHEMIN)
#3 arguments: Affiche le chemin complet
function afficherElt()
{
	afficherElts $1
	
	
	res=`echo "$res"|cut -d: -f$2` #recupere l'element en question
	if (test $# -eq 3)
	then
		res=`echo "$res"|sed "s/.*\\///g"` #coupe le chemin 
	fi
	echo "$res"
	
}

	


#ls -l | awk '{print $1":"$2":"$3}'

#awk 'END {print NR}' fichier 	#imprime le nombre total de lignes du fichiers

#ls -al | sed -n 3p #imprimer 3e ligne

#res= `ls -al`
#print "$res"

#afficherElt 4


afficherElts $1
afficherElt $1 5 1
afficherElt $1 5

#afficherEltChemin $1 5
