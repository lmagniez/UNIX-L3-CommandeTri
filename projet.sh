#! /bin/bash

############################################
############################################
#		FONCTIONS GET ELEMENTS/LISTE	   #
############################################
############################################

#Retourne la liste complete des fichiers (NON RECURSIF)
#$1:chemin du fichier (relatif ou absolu)
function afficherElts()
{	
	
	res=`find $1 -maxdepth 1 -name "*"`	
	res=`echo "$res" | tr "\n$" ":"` #remplace saut de ligne par :
	
}

#Retourne la liste complete des fichiers (RECURSIF)
#$1:chemin du fichier (relatif ou absolu)
function afficherEltsRec()
{	
	
	res=`find $1 -name "*"`	
	res=`echo "$res" | tr "\n$" ":"` #remplace saut de ligne par :
	
	#echo $res
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
#	FONCTIONS GET (A PARTIR D'UN CHEMIN	   #
############################################
############################################


#A partir d'un chemin complet/relatif, retourne le nom du fichier (./test/aa -> aa)
#$1:chemin
function getNom()
{
	res=`echo "$1"|sed "s/.*\\///g"`
}

#A partir d'un chemin complet/relatif, retourne la taille du fichier
#$1:chemin
function getTaille()
{
	res=`stat -c %s "$1"`
	#echo $res
}


#A partir d'un chemin complet/relatif, retourne la date de derniere modification du fichier
#$1:chemin
function getDate()
{
	res=`stat -c %y "$1"`
	#echo $res
}


#A partir d'un chemin complet/relatif, retourne le nb de lignes d'un fichier, 0 si un dossier
#$1:chemin
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


#A partir d'un chemin complet/relatif, l'extension du fichier, si pas d'extension, renvoie le nom (ordre alphabetique)
#$1:chemin
function getExtension()
{

	getNom $1

	if (test -f $1)
	then
		res=`echo "$res"|sed 's/.*\.//g'`
	else
		res=`echo "$res"|sed "s/.*\\///g"`
	fi
	
	#echo $res
}

#Chemin complet/relatif -> propriétaire
#$1:chemin
function getProprio()
{
	res=`stat -c %U "$1"`
}

#Chemin complet/relatif -> groupe
#$1:chemin
function getGroupe()
{
	res=`stat -c %G "$1"`

}

#recupere la valeur d'un type
#change la velur de res 
#Nom AVEC chemin complet
function recupValeur(){
	#d,f,l,b,c,t,s
	if (test -d $1)
		then
		res=7
		val="d"
	elif (test -f $1)
		then
		res=6
		val="f"
	elif (test -l $1)
		then
		res=4
		val="l"
	elif (test -b $1)
		then
		res=3
		val="b"
	elif (test -c $1)
		then
		res=2
		val="c"
	elif (test -t $1)
		then
		res=1
		val="t"
	elif (test -s $1)
		then
		res=0
		val="s"
	fi
}


############################################
############################################
#		FONCTIONS DE COMPARAISONS 		   #
#		(A PARTIR DE 2 CHEMINS)			   #
############################################
############################################


#compare taille entre elt1 et elt2
#OK si tailleelt1>tailleelt2 sinon KO
#Nom AVEC chemin complet/relatif
#$1:chemin elt1 	$2:chemin elt2
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
#Nom AVEC chemin complet/relatif
#$1:chemin elt1 	$2:chemin elt2
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
#Nom AVEC chemin complet/relatif
#$1:chemin elt1 	$2:chemin elt2
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
#Nom AVEC chemin complet/relatif
#$1:chemin elt1 	$2:chemin elt2
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
#Nom AVEC chemin complet/relatif
#$1:chemin elt1 	$2:chemin elt2
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

#compare type entre elt1 et elt2
#OK si le premier element doit etre mis avant le deuxieme (ex : dossier avant fichier)
#Nom AVEC chemin complet
function cmpType()
{
	recupValeur $1
	num1=$res
	recupValeur $2
	num2=$res
	if (test $num1 -gt $num2)
		then res="OK"
	else
		res="KO"
	fi
}


############################################
############################################
#			MANIPULATIONS DE LISTES 	   #
############################################
############################################



#taille de la liste
#$1:liste
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
#			TRI A BULLE (NON UTILISE)	   #
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
#	TRI FUSION (Pour plusieurs options)    #
############################################
############################################

#lance le tri fusion pour chaque arguments
#$1:liste $2:inv? $3-$#:cmpFoncs
function tri_fusion()
{
	echo -n "
Tri en Cours"
	
	
	liste="$1"
	inv=$2
	
	shift
	shift
	
	len "$liste"	
	long=`expr $res - 1`
	
	#echo $1
	tri_fusion2 "$liste" "$1" 1 $long $inv
	liste="$res"
	echo -n " ."
	#####################
	#	PLUSIEURS ARGS	#
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
		
		
		
		#echo "tab:" -$tab-
		#echo "lastCmpFunc:" $lastCmpFunc
		#echo "cmpFun:" $actualCmp
		
		
		#initialise la table a null(contiendra toutes les partitions pour le cmpActuel)
		newtab=""
		
		#echo "newtab:" -$newtab-
		
		#pour chaque partitions du tableau (de cmpPrecedent)
		while (test "$tab" != "")
		do
			IFS=" "
			#echo "TAB:"$tab
			
			#recupere debut et fin et les supprime 
			deb=`echo "$tab"|cut -d: -f1`
			fin=`echo "$tab"|cut -d: -f2`
			tab=`echo "$tab"|sed "s|[^:]*[:]*||"` 
			tab=`echo "$tab"|sed "s|[^:]*[:]*||"` 
			IFS=":"
			
			#echo "deb"-$deb- "fin"-$fin-
			
			
			#cherche les nouvelles partitions de liste et execute les tris 
			rechercher_sim "$liste" "$newtab" "$deb" "$fin" "$lastCmpFunc" "$actualCmp" $inv
			liste="$res"
			
			#tabRes=`echo $tabRes|sed "s|^:*||"` #supprimer ':' de trop 
			newtab="$newtab":"$tabRes"
			newtab=`echo $newtab|sed "s|^:*||"` #supprimer ':' de trop 
			
		done 
		
		tab=`echo $newtab|sed "s|^:*||"` #supprimer ':' de trop 
		lastCmpFunc="$actualCmp" #le cmpActuel devient le cmpPrecedent
		
		echo -n " ."
		
	done
	
	IFS=$OLD_IFS
	
	#echo ">>>>>>$cmps<<<<<<"
	echo "
	"
	afficher2 $liste $cmps
	
}


#rechercher elements similaires
#ajoute dans un nouveau tab

#On parcoure la liste de debut a fin, et on regarde les elements a la suite étant identiques selon lastCmpFunc
#On en fait des tas qu'on va trier juste ensuite avec newCmpFunc
#On stocke les tas pour pouvoir partitionner au prochain appel (si d'autres criteres de tris)

#lastCmpFunc deviendra newCmpFunc et newCmp et le prochain element dans la liste de cmps

#$1:liste $2:tab $3:deb $4:fin $5:lastCmpFunc $6:newCmpFunc $7:inv?
function rechercher_sim()
{
	#echo "rechercherSim" "$2" "$3" "$4" "$5" "$7"
	
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
			#echo ">>>>> $i $cpt"
			
			#si on est bien dans la partition
			if (test $cpt -ge $debRech -a $cpt -le $finRech) 
			then
				
				e1=`expr $debutMotif + 1`
				e2=`expr $cpt + 1`
				elt1=`echo "$liste"|cut -d: -f$e1`
				elt2=`echo "$liste"|cut -d: -f$e2`
				
				#echo $elt1 $elt2
				
				$5 $elt1 $elt2
				aff=$res
				#echo $aff
				
				if(test $aff != "OO")#fin du motif, on l'ajoute au tableau et execute le tri
				then
					#ajoute pas si on a un motif d'une seule case (singleton)
					if(test $debutMotif -ne `expr $cpt - 1`)
					then
						IFS=$OLD_IFS
						tabRes=$tabRes:"$debutMotif:"`expr $cpt - 1`
						tri_fusion2 "$liste" "$6" $debutMotif `expr $cpt - 1` $7
						liste="$res"
						IFS=":"
					fi
					debutMotif=`expr $cpt`
				fi
				#echo $cpt
			fi
			
			
		fi
		cpt=`expr $cpt + 1`
	done
	
	#derniere itération: on ajoute le dernier motif s'il n'est pas un singleton
	IFS=$OLD_IFS
	if(test $debutMotif -ne `expr $finRech`)
	then
		
		tabRes=$tabRes:"$debutMotif:"$finRech
		tri_fusion2 "$liste" "$6" $debutMotif $finRech $7
		liste="$res"
	fi
	tabRes=`echo $tabRes|sed "s|^:*||"` #supprimer ':' de trop 
	
	
	
	#echo "tabRES!!!!! "$tabRes
	res="$liste"
	
}


#lance le tri fusion pour les indices debut à fin en utilisant la fonction cmpFonc
#$1:liste $2:cmpFonc $3:debut $4:fin $5:rec?(0/1)
function tri_fusion2()
{
	
	#echo triFUSION -$2- -$3- -$4- inv -$5-
	
	if [ $long -gt 0 ]
	then
		tri_fusion_bis "$1" "$2" $3 $4 $5
		liste="$res"
	fi
	
	#afficher2 "$liste" "$2"
	res="$liste"
}

#$1:liste $2:cmpFonc $3:deb  $4:fin $5:rec?(0/1)
function tri_fusion_bis()
{	
	
	liste=$1
	deb=$3
	fin=$4
	if [ $deb -ne $fin ]
	then
	
		#partition1
		milieu=`expr \( $4 + $3 \) / 2`
		tri_fusion_bis "$liste" "$2" $3 $milieu $5 #deb milieu
		liste="$res"
		
		#partition2
		milieu=`expr \( $4 + $3 \) / 2` #doit recalculer (SINON utilise milieu de fonction rec)
		tri_fusion_bis "$liste" "$2" `expr $milieu + 1` $4 $5 #milieu+1 fin
		liste="$res"
		
		#fusion
		milieu=`expr \( $4 + $3 \) / 2` #doit recalculer (SINON utilise milieu de fonction rec)
		fusion "$liste" "$2" $3 $milieu $4 $5 #fusion deb milieu fin
		liste="$res"
	fi
	
	#afficherNoms "$liste"
	
	res="$liste"
	
}

#$1:liste $2:cmpFonc $3:deb $4:milieu $5:fin $6:rec?(0:1)
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
			
			if (test "$6" = 0)
			then
				cmpVal="KO"
			else
				cmpVal="OK"
			fi
			
			
			if (test "$res" = $cmpVal)
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
#		Fonctions affichage				   #
############################################
############################################

#Affiche pour une liste son chemin et l'ensemble des elts utilisés pour la comparaison
#afficher2 "./aa:./test:./test/aa" "CmpNom CmpProprio CmpDate"
#	-> Affiche chemin, nom, proprio et date pour chaque elt
#N'affiche pas les caractéristiques du premier elt: dossier source
#$1:liste $2:cmpFuncs 
function afficher2()
{	
	func=" "
	affiche=""
	elt=""
	
	OLD_IFS=$IFS
	IFS=":"
	
	#echo $1
	
	listeCpy=$1
	
	first=`echo "$listeCpy"|cut -d: -f1` #recupere et affiche premier elt
	echo "Dossier: $first"
	listeCpy=`echo "$listeCpy"|sed "s|[^:]*[:]*||"` #supprimer premier elt
	
	
	for i in $listeCpy
	{
		
		resultat="$i	"
		
		for j in $2
		do
			if (test $j = "cmpNom")
			then 
				getNom $i
				resultat=$resultat" 	nom: $res"
			elif (test $j = "cmpTaille")
			then
				getTaille $i
				resultat=$resultat"		taille: $res"
			elif (test $j = "cmpDate")
			then
				getDate $i
				resultat=$resultat"		date: $res" 
			elif (test $j = "cmpLine")
			then
				getLine $i
				resultat=$resultat"		nbLignes: $res"	
			elif (test $j = "cmpProprio")
			then
				getProprio $i
				resultat=$resultat"		proprio: $res" 
			elif (test $j = "cmpGroupe")
			then
				getGroupe $i
				resultat=$resultat"		groupe: $res" 
			elif (test $j = "cmpExtension")
			then
				getExtension $i
				resultat=$resultat"		extension: $res" 
			elif (test $j = "cmpType")
			then
				recupValeur $i
				resultat=$resultat"		type: $val"
			fi
		done
		
		echo "$resultat"
	}
	
	IFS=$OLD_IFS
	
}




###				MERDIER
##########################################
#ls -l | awk '{print $1":"$2":"$3}'
#awk 'END {print NR}' fichier 	#imprime le nombre total de lignes du fichiers
#ls -al | sed -n 3p #imprimer 3e ligne
##########################################




############################################
############################################
#					MAIN				   #
############################################
############################################


recur=0
decrois=0

test $# -gt 4 && echo "Trop d'argument au maximum" && exit 1

eval "rep=\${$#}"
test ! -d "$rep" && echo "$rep n'est pas un dossier ! " && exit 1


function verifdoublon(){
	chaine=$1
	var=`echo ${chaine} | grep "$2" | wc -l`
	if( test $var -ne 0 )
	then
		echo "Doublon dans les options" && exit 1
	fi
}


#verification sil tous les tiret son correct pour les options
for ((i=1;i<$#;i++));
do 
	eval "val=\${$i}"
	case "$val" in 
  		-*)
   		;;
   		*-)
			echo "Le tiret est mal place" && exit 1
   		;;
   		*) 
			echo "Il manque des tirets" && exit 1
		;;
	esac
done

#recuperation des options
for ((i=1;i<$#;i++));
do 
	eval "val=\${$i}"
	case "$val" in 
  		-R)
			recur=1
   		;;
   		-d)
			decrois=1
   		;;
   		-*)
			str="---"
			str="$str""$val"	
			str=`echo $str | sed "s/^-*//"`
			for j in $(seq 1 ${#str}); do
				car=$(echo $str | cut -c$j)
				case "$car" in 
					n) 
						verifdoublon "$nsdketpg" "cmpNom"
						nsdketpg="$nsdketpg cmpNom"
					;;
					s) 
						verifdoublon "$nsdketpg" "cmpTaille"
						nsdketpg="$nsdketpg cmpTaille"
					;;
					m) 
						verifdoublon "$nsdketpg" "cmpDate"
						nsdketpg="$nsdketpg cmpDate"
					;;
					l) 
						verifdoublon "$nsdketpg" "cmpLine"
						nsdketpg="$nsdketpg cmpLine"
					;;
					e) 
						verifdoublon "$nsdketpg" "cmpExtension"
						nsdketpg="$nsdketpg cmpExtension"
					;;
					t) 
						verifdoublon "$nsdketpg" "cmpType"
						nsdketpg="$nsdketpg cmpType"
					;;
					p) 
						verifdoublon "$nsdketpg" "cmpProprio"
						nsdketpg="$nsdketpg cmpProprio"
					;;
					g) 
						verifdoublon "$nsdketpg" "cmpGroupe"
						nsdketpg="$nsdketpg cmpGroupe"
					;;
					*) 
						echo $car
						echo "Erreur Option" && exit 1
					;;
				esac
			done
		;;
	esac
done

if (test "$nsdketpg" = "");then 
	nsdketpg="cmpNom"
fi

nsdketpg=`echo $nsdketpg|sed "s|^ *||"` #supprimer ' ' de trop 


#echo "Options : $nsdketpg"
#echo "Recursif : $recur"
#echo "Decroissant : $decrois"





#Recupere liste (recursif ou non)
if [ $recur -eq 1 ]
then
	afficherEltsRec $rep
else
	afficherElts $rep
fi

liste1="$res"
liste="$liste1"


#shift


#afficherEltsRec $1
#tri_fusion "$liste" "cmpProprio"

liste="$liste1"



tri_fusion "$liste" $decrois $nsdketpg


#"cmpProprio" "cmpTaille" "cmpNom" 

#tri_fusion "$liste" 0 "cmpProprio" "cmpTaille" "cmpNom"





