# conversor.sh
# script conversor de temperaturas - Sistemas Operativos 75.08
#
echo
echo "..::" Conversor de temperaturas "::.."
echo
if ( [ "$1" == "-h" ] || [ "$1" == "-H" ] || [ "$1" == "--help" ] )
then
	echo Ayuda.; echo El programa necesita 2 argumentos\:
	echo Primer parámetro\: \"c\" , para temperatura ingresada en grados Celsius o \"f\" , para temperatura ingresada en grados Fahrenheit.
	echo Segundo parámetro\: \<valor entero\> , para representar el valor numérico de la temperatura.
else	
	# Pregunto si tengos dos argumentos, si el primero es una "c" o una "f" y si el segundo está en un rango numérico antes de hacer la cuenta
	if [ $# -eq 2 ] && ( [ "$1" == "c" ] || [ "$1" == "f" ] ) && ( [ "$2" -ge "-100000000000" ] && [ "$2" -le "100000000000" ] )
	then
		if [ "$1" == "c" ]
		then	#Caso C -> F
			RES=$(echo "( 9 * $2 / 5 ) + 32" | bc)
			echo $2 grados Celsius equivalen a $RES grados Fahrenheit.
		else	#Caso F -> C
			RES=$(echo "5 * ( $2 - 32) / 9" | bc)
			echo $2 grados Fahrenheit equivalen a $RES grados Celsius.
		fi
	else
		echo Error en parámetros. Para ayuda consulte con el argumento \"-h\".
	fi
fi
echo
