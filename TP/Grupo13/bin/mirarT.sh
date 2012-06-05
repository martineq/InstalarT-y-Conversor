#!/bin/bash

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	mirarT.sh		#
#					#
#########################################

# ------------------------------------------------------------------------------------------------
#grupo: 13
#
#Sirve visualizar amigablemente del contenido del archivo de log correspondiente al comando pasado como parámetro..
#
# Opciones y Parámetros
#       Parámetro 1 (obligatorio): comando
#       Parámetro 2 (deseable): Algun tipo de filtro
#       -n xx: Muestra a partir de la linea xx.
#       -f xx: Muestra las entradas que cumplen con el filtro pedido. 
#
#Variables de entorno utilizadas.
#       $LOGDIR
#               Para escribir en el archivo de log, salvo el caso del comando "instalar" que va en un directorio fijo.
# ------------------------------------------------------------------------------------------------

#if [ "$1" != "instalar" ] ; then
#  source global.sh      
#fi


COMANDO="mirarT"
#LOGUEO EL COMIENZO DE EJECUCION COMO INFORMACION, y EXPLICITAR LOGDIR
bash loguearT.sh $COMANDO "I" "INICIO DE EJECUCION DE mirarT CON DIRECTORIO: $LOGDIR"

if [ $# \< 1 ] 
then 
        echo "Este programa recibe por lo menos 1 Parametro!"
        # LOGUEO EL ERROR!!!
        bash loguearT.sh $COMANDO "E" "Este programa recibe por lo menos 1 Parametro!"
    exit 2
fi

#si pido servicio a mirarT de instalar tengo que ir a un directorio fijo
if [ "$1" == "instalar" ]
then
  ARCHLOG="$GRUPO/log/$1.log"
else
  ARCHLOG="$LOGDIR/$1.log"
fi


if [ $# = 1 ]
then
    if [ "$1" == "-h" ] || [ "$1" == "-help" ] || [ "$1" == "--help" ]
    then
                echo "Este programa utiliza los filtros de grep para modificar las busquedas"
                exit 3
        else
                #Valido que el origen exista.
                if [ ! -e "$ARCHLOG" ] 
                then
                        echo "No existe el archivo de origen: $ARCHLOG"
                        bash loguearT.sh $COMANDO "E" "No existe el archivo de origen: $ARCHLOG" 
                        exit 4
                fi
                cat -n $ARCHLOG
    fi
else
        #Valido que el origen exista.
        if [ ! -e "$ARCHLOG" ] 
        then
                echo "No existe el archivo de origen: $ARCHLOG"
                bash loguearT.sh $COMANDO "E" "No existe el archivo de origen: $ARCHLOG" 
                exit 4
        fi
        
    #Muestro a partir de la linea $3
    if [ "$2" == "-n" ] 
        then
                DESDE=$3
                # Si DESDE no es numero, loguear como error
                if [ ` echo $3 | grep -v -e "[^0-9]" | wc -l ` -eq 0 ]
                then
                        echo "El valor requerido para numero de linea ($DESDE) no es numerico."
                        bash loguearT.sh $COMANDO "E" "El valor requerido para numero de linea ($DESDE) no es numerico"
                        exit 5
                fi
                tail -n "$DESDE" $ARCHLOG | cat -n -
    fi
    
    #Muestro todas las entradas que cumplen con el filtro para grep
    if [ "$2" == "-f" ] 
        then
                DESDE=$3
                grep $3 < $ARCHLOG | cat -n -
    fi  
fi

exit 0
