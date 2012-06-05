main() {

    ORIGEN=$1
#El destino si es solo el directorio debe terminar con la "/" dado que el mv lo interpreta como un archivo sino termina con "/"
    DESTINO=$2

    #Si trajo máde dos parametros entonces trajo el tipo de mensaje
    if [ $# \> 2 ] 
    then
        COMANDO=$3
    else
        COMANDO="mover"
    fi

    #Valido que el origen exista.
    if [ ! -e "$ORIGEN" ]; then
        echo "No existe el archivo de origen."
        bash loguearT.sh $COMANDO "E" "No existe el archivo de origen."
        exit 3
    fi

    #Corto el nombre del archivo
    NOMBREARCHIVO=${ORIGEN##*/}

    bash loguearT.sh $COMANDO "I" "Nombre de archivo origen: $NOMBREARCHIVO"
    bash loguearT.sh $COMANDO "I" "Nombre del origen completo: $ORIGEN"
    #Valido que el Origen y el destino no sean iguales
    #En esta comparacióeo que no sean iguales teniendo en cuenta el directorio y el nombre de archivo

    #Valido que el directorio destino exista!, Lo hago ahora porque recien ahora me asegure de tener el directorio sin nombre de archivo
    #Valido que el origen exista.
    if [ ! -e "$DESTINO" ]; then
        echo "No existe el directorio destino."
        bash loguearT.sh $COMANDO "E" "No existe el directorio destino."
        exit 4
    fi
    DIRORIGEN=${ORIGEN%/*}
    if [ $DIRORIGEN == $DESTINO ] 
    then
        bash loguearT.sh $COMANDO "E" "Origen y Destino son iguales"
        exit 0
    fi

        #Obtengo el nombre del archivo sin la extension
        NOMBREARCHIVOCORTO=${NOMBREARCHIVO%%.*}
		SECDESTINO=`ls -l $DESTINO | grep "$NOMBREARCHIVOCORTO" | awk '{for (i = 1; i < 9; i++) $i = ""; sub(/^ */, ""); print}' | tail -n 1`
		
		EXTDESTINO=${SECDESTINO##*.}
		if [ -z "$SECDESTINO" ]; then
			SECUENCIA=0
			#echo "0: $SECUENCIA"
		else
			let SECUENCIA=$EXTDESTINO+1
			#echo "1O+: $SECUENCIA"
		fi
	#	echo "$SECUENCIA"
		DESTINOCOMPL="$DESTINO/$NOMBREARCHIVOCORTO.$SECUENCIA"
		
		mv $ORIGEN $DESTINOCOMPL

    if [ $? == 0 ]; then
        #Si tengo máde dos parametros entonces tengo el comando, por lo tanto genero log para el comando.
        if [ $# \> 2 ]; then
            bash loguearT.sh $COMANDO "I" "Mover exitoso desde $ORIGEN hacia $DESTINO"
        fi
        #Grabo en el log de mover el resultado
        bash loguearT.sh "moverT" "I" "Mover exitoso desde $ORIGEN hacia $DESTINO"
        exit 0
    else
        #grabo en el log de movor el error.
        bash loguearT.sh $COMANDO "E" "Ocurrio un error moviendo: $ORIGEN hacia $DESTINO"
        exit 1
    fi
}

#Menos de 2 parametros o mas de 3 esta mal
if [ $# \< 2 -o $# \> 3 ]
then
        echo "Uso: moverT origen destino [comando invocador]"
        exit 2;
fi

main $1 $2 $3
