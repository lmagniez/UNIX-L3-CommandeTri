#! /bin/bash

#Retourne la liste complete des fichiers (NON RECURSIF)
function afficherElts()
{	
	
	res=`find $1 -maxdepth 1 -name "*"`	
	res=`echo "$res" | tr "\n$" ":"` #remplace saut de ligne par :
	
}

function afficherEltsRec()
{	
	
	res=`find $1 -name "*"`	
	res=`echo "$res" | tr "\n$" ":"` #remplace saut de ligne par :
	
	echo $res
	
	
}

#Affiche le nom d'un element en particulier (Par défaut: CHEMIN COMPLET)
#$1: liste	$2:elt a recup	$3:chemin complet?
#3 arguments: Affiche le nom sans son chemin
function afficherElt()
{
	t=`expr $2 + 1`
	res=`echo "$1"|cut -d: -f$t` #recupere l'element en question
}

############################################
############################################
############################################
############################################
############################################


#A partir d'un chemin complet, retourne le nom du fichier
function getNom()
{
	res=`echo "$1"|sed "s/.*\\///g"`
}

#A partir d'un chemin complet, retourne la taille du fichier
function getTaille()
{
	res=`stat -c %s "$1"`
	#echo $res
}


#A partir d'un chemin complet, retourne la date de derniere modification du fichier
function getDate()
{
	res=`stat -c %y "$1"`
	#echo $res
}


#A partir d'un chemin complet, retourne le nb de lignes d'un fichier, 0 si un dossier
function getLine()
{
	if (test -f "$1")
	then
		res=`wc -l < "$1"`
	else
		res=0
	fi
	
	#echo $res
}


#A partir d'un chemin complet, l'extension du fichier, si pas d'extension, renvoie le nom (ordre alphabetique)
function getExtension()
{

	if (test -f $1)
	then
		res=`echo "$1"|sed 's/.*\.//g'`
	else
		res=`echo "$1"|sed "s/.*\\///g"`
	fi
	
	echo $res
}


function getProprio()
{
	res=`stat -c %U "$1"`
}

function getGroupe()
{
	res=`stat -c %G "$1"`

}

#stat -c "id propriétaire: %u , nom propriétaire: %U" ./projet.sh
#stat -c "id groupe: %g , nom groupe: %G" ./projet.sh

############################################
############################################
############################################
############################################
############################################


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
	elif (test $taille1 -eq $taille2)
		then res="OO"
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
	nom1="$res"
	getNom "$2"
	nom2="$res"
	
	if (test "$nom1" \> "$nom2")
		then res="OK"
	elif (test "$nom1" = "$nom2")
		then res="OO"
	else
		res="KO"
	fi
}

#compare date entre elt1 et elt2
#OK si d1>d2 sinon KO (ok si d1 est plus récent)
#Nom AVEC chemin complet
function cmpDate()
{
	
	getDate "$1"
	d1="$res"
	getDate "$2"
	d2="$res"
	
	if (test "$d1" \> "$d2")
		then res="OK"
	elif (test "$d1" = "$d2")
		then res="OO"
	else
		res="KO"
	fi
}


#compare date entre elt1 et elt2
#OK si l1>l2 sinon KO (ok si l1 a plus de lignes)
#Nom AVEC chemin complet
function cmpLine()
{
	
	getLine "$1"
	l1=$res
	getLine "$2"
	l2=$res
	
	if (test $l1 -gt $l2)
		then res="OK"
	elif (test $l1 -eq $l2)
		then res="OO"
	else
		res="KO"
	fi
}

#compare nom entre elt1 et elt2
#OK si elt1>elt2 sinon KO
#Nom AVEC chemin complet
function cmpExtension()
{
	
	getExtension "$1"
	nom1="$res"
	getExtension "$2"
	nom2="$res"
	
	if (test "$nom1" \> "$nom2")
		then res="OK"
	elif (test "$nom1" = "$nom2")
		then res="OO"
	else
		res="KO"
	fi
}


function cmpProprio
{
	getProprio "$1"
	nom1="$res"
	getProprio "$2"
	nom2="$res"
	
	if (test "$nom1" \> "$nom2")
		then res="OK"
	elif (test "$nom1" = "$nom2")
		then res="OO"
	else
		res="KO"
	fi
}

function cmpGroupe()
{
	getGroupe "$1"
	nom1="$res"
	getGroupe "$2"
	nom2="$res"
	
	if (test "$nom1" \> "$nom2")
		then res="OK"
	elif (test "$nom1" = "$nom2")
		then res="OO"
	else
		res="KO"
	fi
}

############################################
############################################
############################################
############################################
############################################



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
	res=`echo "$res"|sed "s|$elt2:|$elt1:|"` #doit remplacer delimiteur / par | car / present dans la variable 
	res=`echo "$res"|sed "s|$elt1:|$elt2:|"`
	
}

#Remplace l'elt d'indice i d'une liste
#$1: liste $2:i $3:elt
function changeElt()
{
	
	elt2=$3
	
	i=`expr $2 + 1` #on accede au ième element (indice+1)
	afficherElt "$1" $2
	elt1="$res"
	
	res="$1"
	res=`echo "$res" | sed "s|[^:]*|$elt2|$i"`
	
	
}



############################################
############################################
############################################
############################################
############################################


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
		
		i=1 #2
		#parcoure les elt et switch pour emmener le max a la fin
		while [ $i -lt `expr $long - 1` ]
		#while [ $i -lt $long ]
		do
			afficherElt "$liste" $i
			elt1="$res"
			afficherElt "$liste" `expr $i + 1` 
			elt2="$res"
			
			#fonction de comparaison
			
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
	
	afficher "$liste" "$2"
		
	
	
}

############################################
############################################
############################################
############################################
############################################

#lance le tri fusion pour chaque arguments
#$1:liste $2-$#:cmpFoncs
function tri_fusion()
{
	liste="$1"
	shift
	
	len "$liste"	
	long=`expr $res - 1`
	
	echo $1
	tri_fusion2 "$liste" "$1" 1 $long
	liste="$res"
	#####################
	####################PLUSIEURS ARGS
	#####################
	
	
	OLD_IFS=$IFS
	IFS=":"
	tab="1:"$long
	
	cmps=$*
	
	lastCmpFunc="$1"
	shift #enleve LastCmpFunc (ne sert plus)
	
	
	#####################
	#pour chaque cmpFonc#
	#####################
	
	for actualCmp in $*
	do

		echo "tab:" -$tab-
		echo "lastCmpFunc:" $lastCmpFunc
		echo "cmpFun:" $actualCmp
		
		
		#initialise la table a nulle(contiendra toutes les partitions)
		newtab=""
		
		echo "newtab:" -$newtab-
		
		#tab="1:2:3:4:5:6:7:8"
		#pour chaque partitions du tableau
		while (test "$tab" != "")
		do
			IFS=" "
			echo "TAB:"$tab
			
			#recupere debut et fin et les supprime 
			deb=`echo "$tab"|cut -d: -f1`
			fin=`echo "$tab"|cut -d: -f2`
			tab=`echo "$tab"|sed "s|[^:]*[:]*||"` 
			tab=`echo "$tab"|sed "s|[^:]*[:]*||"` 
			IFS=":"
			
			echo "deb"-$deb- "fin"-$fin-
			
			
			#cherche les nouvelles partitions de liste et execute les tris 
			rechercher_sim "$liste" "$newtab" "$deb" "$fin" "$lastCmpFunc" "$actualCmp" 
			liste="$res"
			
			#tabRes=`echo $tabRes|sed "s|^:*||"` #supprimer ':' de trop 
			newtab="$newtab":"$tabRes"
			newtab=`echo $newtab|sed "s|^:*||"` #supprimer ':' de trop 
			
		echo "
		
		
		---------------------------------------------------
		---------------------------------------------------
		---------------------------------------------------
		
		"
			
		done 
		
		tab=`echo $newtab|sed "s|^:*||"` #supprimer ':' de trop 
		
		
		
		lastCmpFunc="$actualCmp"
		
	done
	
	IFS=$OLD_IFS
	
	echo ">>>>>>>>>>>>>>>
	
	
	
	$cmps
	<<<<<<<<<<<<<"
	
}


#rechercher elements similaires
#ajoute dans un nouveau tab
#$1:liste $2:tab $3:deb $4:fin $5:lastCmpFunc $6:newCmpFunc 
function rechercher_sim()
{
	echo rechercherSim "$2" "$3" "$4" "$5"
	
	liste=$1
	tabRes=$2
	debRech=$3
	finRech=$4
	
	debutMotif=$debRech #init motif
	
	cpt=0
	for i in $liste
	do
		if (test $cpt -ne 0)
		then 
			echo ">>>>> $i $cpt"
			
			#si on est bien la partition
			if (test $cpt -ge $debRech -a $cpt -le $finRech) 
			then
				
				e1=`expr $debutMotif + 1`
				e2=`expr $cpt + 1`
				elt1=`echo "$liste"|cut -d: -f$e1`
				elt2=`echo "$liste"|cut -d: -f$e2`
				
				echo $elt1 $elt2
				
				$5 $elt1 $elt2
				aff=$res
				echo $aff
				
				if(test $aff != "OO")#fin du motif, on l'ajoute au tableau et execute le tri
				then
					echo HERE!
					#ajoute pas si on a un motif d'une seule case
					if(test $debutMotif -ne `expr $cpt - 1`)
					then
						IFS=$OLD_IFS
						tabRes=$tabRes:"$debutMotif:"`expr $cpt - 1`
						tri_fusion2 "$liste" "$6" $debutMotif `expr $cpt - 1`
						liste="$res"
						IFS=":"
					fi
					debutMotif=`expr $cpt`
					#`expr $cpt - 1`
				fi
				echo $cpt
			fi
			
			
		fi
		cpt=`expr $cpt + 1`
	done
	
	IFS=$OLD_IFS
	if(test $debutMotif -ne `expr $finRech`)
	then
		
		tabRes=$tabRes:"$debutMotif:"$finRech
		tri_fusion2 "$liste" "$6" $debutMotif $finRech
		liste="$res"
	fi
	tabRes=`echo $tabRes|sed "s|^:*||"` #supprimer ':' de trop 
	#IFS=":"
	
	
	
	echo "tabRES!!!!! "$tabRes
	
}


#lance le tri fusion pour les indices debut à fin en utilisant la fonction cmpFonc
#$1:liste $2:cmpFonc $3:debut $4:fin
function tri_fusion2()
{
	
	echo triFUSION -$2- -$3- -$4-
	
	if [ $long -gt 0 ]
	then
		tri_fusion_bis "$1" "$2" $3 $4
		liste="$res"
	fi
	
	afficher "$liste" "$2"
	res="$liste"
}

#$1:liste $2:cmpFonc $3:deb  $4:fin 
function tri_fusion_bis()
{	
	
	
	liste=$1
	deb=$3
	fin=$4
	if [ $deb -ne $fin ]
	then
	
		#partition1
		milieu=`expr \( $4 + $3 \) / 2`
		tri_fusion_bis "$liste" "$2" $3 $milieu #deb milieu
		liste="$res"
		
		#partition2
		milieu=`expr \( $4 + $3 \) / 2` #doit recalculer (SINON utilise milieu de fonction rec)
		tri_fusion_bis "$liste" "$2" `expr $milieu + 1` $4 #milieu+1 fin
		liste="$res"
		
		#fusion
		milieu=`expr \( $4 + $3 \) / 2` #doit recalculer (SINON utilise milieu de fonction rec)
		fusion "$liste" "$2" $3 $milieu $4 #fusion deb milieu fin
		liste="$res"
	fi
	
	#afficherNoms "$liste"
	
	res="$liste"
	
}

#$1:liste $2:cmpFonc $3:deb $4:milieu $5:fin 
function fusion()
{
	deb=$3
	deb2=`expr $milieu + 1` 
	milieu=$4
	fin=$5
	cpt1=$deb
	cpt2=`expr $milieu + 1`
	
	liste="$1" #utilise pour le resultat
	liste_copie="$1" #copie pour faire le tri
	
	for i in $(seq $deb $fin)
	do
		#tous les elts du premier tab utilisés
		if [ $cpt1 -eq $deb2 ]
		then
			break #tous les elts classés
		
		#tous les elts du second tab utilisés
		elif [ $cpt2 -eq `expr $fin + 1` ]
		then
			afficherElt "$liste_copie" $cpt1
			elt="$res"
			changeElt "$liste" $i "$elt"
			liste="$res"
			cpt1=`expr $cpt1 + 1`
		
		#comparaison 2 elts
		else			
			afficherElt "$liste_copie" $cpt1
			elt1="$res"
			afficherElt "$liste" $cpt2
			elt2="$res"
			 
			#cmp e1 e2
			$2 "$elt1" "$elt2"
			
			#tab[cp1]<tab[cpt2]?
			if (test "$res" = "KO")
			then
				#KO: true Change Elt1
				changeElt "$liste" $i "$elt1" 
				liste="$res"
				cpt1=`expr $cpt1 + 1`
			else
				#OK: false Change Elt2
				changeElt "$liste" $i "$elt2" 
				liste="$res"
				cpt2=`expr $cpt2 + 1`
			fi
		fi
	done
	
	res="$liste"
	
}

############################################
############################################
############################################
############################################
############################################

#$1:liste $2:cmpFunc
function afficher()
{	
	func=" "
	affiche=""
	elt=""
	if (test $2 = "cmpTaille")
	then
		func="getTaille"
		affiche="taille:"
	elif (test $2 = "cmpDate")
	then
		func="getDate"
		affiche="date:"
	elif (test $2 = "cmpLine")
	then
		func="getLine"	
		affiche="nbLignes:"
	elif (test $2 = "cmpProprio")
	then
		func="getProprio"	
		affiche="proprio:"
	elif (test $2 = "cmpGroupe")
	then
		func="getGroupe"	
		affiche="groupe:"
	fi
	
	OLD_IFS=$IFS
	IFS=":"
	for i in $1
	{
		getNom "$i"
		nom=$res
		
		if(test $func != " ")
		then 
			$func "$i"
			elt=$res
		fi
		
		echo "$nom		$affiche $elt"
	}
	
	IFS=$OLD_IFS
	
}




###				MERDIER
##########################################
#ls -l | awk '{print $1":"$2":"$3}'
#awk 'END {print NR}' fichier 	#imprime le nombre total de lignes du fichiers
#ls -al | sed -n 3p #imprimer 3e ligne
##########################################




#echo $liste
#afficherElt "$liste" 1
#echo "1: "$res

#afficherElt "$liste" 2

#echo "$liste"

#len "$liste"

#cmpNom "test2" "test" 

#switchElt "$liste" 3 4

#switchElt "$liste" 9 11


#getTaille ~/Bureau/TDSHELL/
#getTaille ./projet.sh



#cmpTaille ./projet.sh ~/Bureau/TDSHELL/ 
#cmpNom	./.git ./README.md

#afficherNoms "$liste"


#getDate ./projet.sh
#d1=$res
#getDate ~/Bureau/TDSHELL/
#d2=$res


afficherElts $1
liste1="$res"

echo "liste1:" $liste1




echo ">>>>>>>>TRI NOM"


liste="$liste1"
tri_fusion "$liste" "cmpNom"

#liste="$liste1"
#triBulle "$liste" "cmpNom"


echo "$liste1"


echo ">>>>>>>>TRI TAILLE"
liste="$liste1"
tri_fusion "$liste" "cmpTaille"


#liste="$liste1"
#triBulle "$liste" "cmpTaille"

echo "

>>>>>>>>TRI DATE"

liste="$liste1"
tri_fusion "$liste" "cmpDate"

echo "

>>>>>>>>TRI Line"

liste="$liste1"
tri_fusion "$liste" "cmpLine"

echo "

>>>>>>>>TRI Extension"

liste="$liste1"
#tri_fusion "$liste" "cmpExtension"


getExtension ./projet.sh
echo $res
getExtension ~/Bureau
echo $res

#sed 's/.*\.//g' ~/Bureau


stat -c "id propriétaire: %u , nom propriétaire: %U" ./projet.sh
stat -c "id groupe: %g , nom groupe: %G" ./projet.sh

#afficherEltChemin $1 5

getProprio "./projet.sh"
echo $res

getGroupe "./projet.sh"
echo $res


#TRI RECURSIFS

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>"

afficherEltsRec ./test
liste1="$res"
liste="$liste1"
#tri_fusion "$liste" "cmpProprio"

liste="$liste1"

tri_fusion "$liste" "cmpProprio" "cmpTaille" "cmpNom" 

