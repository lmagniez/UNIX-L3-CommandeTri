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
echo $res





