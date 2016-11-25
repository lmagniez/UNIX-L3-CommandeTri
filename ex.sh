#!/bin/sh
#vincent valembois - loick magniez


tableau=( blanc noir rouge bleu vert jaune )

echo ${tableau[5]}


echo ${#tableau[*]}


tableau[6]=turquoise
echo ${#tableau[*]}


echo ${tableau[6]}

