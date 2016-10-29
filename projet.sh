#! /bin/bash

#Retourne la liste complete des fichiers (NON RECURSIF)
function afficherElts()
{	
	OLD_IFS=$IFS
	res=`find $1 -maxdepth 1 -name "*"`	
	res=`echo "$res" | tr "\n$" ":"` #remplace saut de ligne par :
	
}

#Affiche le nom d'un element en particulier (Par défaut: CHEMIN COMPLET)
#$1: liste	$2:elt a recup	$3:chemin complet?
#3 arguments: Affiche le nom sans son chemin

function afficherElt()
{
	
	res=`echo "$1"|cut -d: -f$2` #recupere l'element en question
	if (test $# -eq 3)
	then
		res=`echo "$res"|sed "s/.*\\///g"` #coupe le chemin 
	fi
	#echo "$res"
	
}

#compare taille entre elt1 et elt2
#OK si elt1>elt2 sinon KO
#Nom sans chemin complet
function cmpNom()
{
	if (test $1 \> $2)
		then echo OK
	else
		echo KO
	fi
}

#Switch l'elt1 avec l'elt2 dans la liste
#donne les indices
#$1: liste	$2:i1	$3:i2
#i1 DOIT ETRE INFERIEUR a i2
function switchElt()
{
	
	#i1 DOIT ETRE INFERIEUR a i2
	if (test $2 \> $3)
	then
		i1=$3
		i2=$2
	else
		i1=$2
		i2=$3
	fi
	
	
	afficherElt "$1" $i1
	elt1=$res
	afficherElt "$1" $i2
	elt2=$res
	
	echo "elt 1: $elt1"
	echo "elt 2: $elt2"
	
	res="$1"
	res=`echo "$res"|sed "s#$elt2#$elt1#"` #doit remplacer delimiteur car des slash dans la variable
	res=`echo "$res"|sed "s#$elt1#$elt2#"`
	echo "$res" 
}


###				MERDIER
##########################################
#ls -l | awk '{print $1":"$2":"$3}'
#awk 'END {print NR}' fichier 	#imprime le nombre total de lignes du fichiers
#ls -al | sed -n 3p #imprimer 3e ligne
##########################################


afficherElts $1
liste=$res
#afficherElt "$liste" 5 1
#afficherElt "$liste" 2

echo "$liste"



switchElt "$liste" 2 3


#afficherEltChemin $1 5
