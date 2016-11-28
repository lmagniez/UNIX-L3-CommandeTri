#! /bin/bash

#recupere la valeur d'un type
#change la velur de res 
#Nom AVEC chemin complet
function recupValeur(){
	#d,f,l,b,c,t,s
	if (test -d $1)
		then
		res=7
	elif (test -f $1)
		then
		res=6
	elif (test -l $1)
		then
		res=4
	elif (test -b $1)
		then
		res=3
	elif (test -c $1)
		then
		res=2
	elif (test -t $1)
		then
		res=1
	elif (test -s $1)
		then
		res=0
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

#test 
cmpType "../vincent" "projet2.sh" 
echo "Resultat comparaison type $res " 

################################
################################
################################
################################

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
   		*)
			str="$val"
			for j in $(seq 2 ${#str}); do
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
						verifdoublon "$nsdketpg" "cmpLigne"
						nsdketpg="$nsdketpg cmpLigne"
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

echo "Options : $nsdketpg"

echo "Recursif : $recur"

echo "Decroissant : $decrois"