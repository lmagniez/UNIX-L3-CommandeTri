#! /bin/bash

#Retourne la liste complete des fichiers (NON RECURSIF)
function afficherElts()
{	
	
	res=`find $1 -maxdepth 1 -name "*"`	
	res=`echo "$res" | tr "\n$" ":"` #remplace saut de ligne par :
	
}

#Affiche le nom d'un element en particulier (Par défaut: CHEMIN COMPLET)
#$1: liste	$2:elt a recup	$3:chemin complet?
#3 arguments: Affiche le nom sans son chemin
function afficherElt()
{
	res=`echo "$1"|cut -d: -f$2` #recupere l'element en question
}

#A partir d'un chemin complet, retourne le nom du fichier
function getNom()
{
	res=`echo "$1"|sed "s/.*\\///g"`
}

#A partir d'un chemin complet, retourne la taille du fichier
function getTaille()
{
	res=`stat -c %s $1`
	#echo $res
}


#compare taille entre elt1 et elt2
#OK si tailleelt1>tailleelt2 sinon KO
#Nom AVEC chemin complet
function cmpTaille()
{
	
	getTaille "$1"
	taille1=$res
	getTaille "$2"
	taille2=$res
	
	if (test $taille1 -gt $taille2)
		then res="OK"
	else
		res="KO"
	fi
}


#compare nom entre elt1 et elt2
#OK si elt1>elt2 sinon KO
#Nom AVEC chemin complet
function cmpNom()
{
	
	getNom "$1"
	nom1=$res
	getNom "$2"
	nom2=$res
	
	if (test "$nom1" \> "$nom2")
		then res="OK"
	else
		res="KO"
	fi
}

#taille de la liste
function len()
{
	OLD_IFS=$IFS
	IFS=':'
	cpt=0
	for i in $1
	do
		cpt=`expr $cpt + 1`
	done
	IFS=$OLD_IFS
	res=$cpt
}

#Switch l'elt1 avec l'elt2 dans la liste
#donne les indices
#$1: liste	$2:i1	$3:i2
#i1 DOIT ETRE INFERIEUR a i2
function switchElt()
{
	
	
	#i1 DOIT ETRE INFERIEUR a i2
	if (test $2 -gt $3)
	then
		i1=$3
		i2=$2
	else
		i1=$2
		i2=$3
	fi
	
	
	afficherElt "$1" $i1
	elt1="$res"
	afficherElt "$1" $i2
	elt2="$res"
	
	res="$1"
	res=`echo "$res"|sed "s#$elt2:#$elt1:#"` #doit remplacer delimiteur / par # car / present dans la variable 
	res=`echo "$res"|sed "s#$elt1:#$elt2:#"`
	
}

#Prend une liste en parametre
#$1: liste	$2: nom fonction comparaison
function triBulle()
{
	liste=$1
	len "$liste"
	
	long=$res
	
	#tant qu'on a plus de deux elts
	while [ $long -gt 2 ] 
	do
		
		i=2
		#parcoure les elt et switch pour emmener le max a la fin
		while [ $i -lt $long ]
		do
			afficherElt "$liste" $i
			elt1="$res"
			afficherElt "$liste" `expr $i + 1` 
			elt2="$res"
			
			
			$2 "$elt1" "$elt2"
			
			
			if (test "$res" = "OK")
			then
				switchElt "$liste" $i `expr $i + 1` 
				liste="$res"
			fi
			
			
			
			
			
			i=`expr $i + 1`
		done
	    long=`expr $long - 1`
	done
	
	afficherNoms "$liste"
		
	
	
}

function afficherNoms()
{
	OLD_IFS=$IFS
	IFS=":"
	for i in $1
	{
		getNom $i
		nom=$res
		getTaille $i
		taille=$res
		
		echo "$nom	taille: $taille"
	}
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

#echo "$liste"

#len "$liste"

#cmpNom "test2" "test" 

#switchElt "$liste" 3 4

#switchElt "$liste" 9 11


getTaille ~/Bureau/TDSHELL/
getTaille ./projet.sh

cmpTaille ./projet.sh ~/Bureau/TDSHELL/ 
echo $res

echo ">>>>>>>>TRI NOM"
triBulle "$liste" "cmpNom"


echo ">>>>>>>>TRI TAILLE"
triBulle "$liste" "cmpTaille"

#afficherEltChemin $1 5
