#!/bin/bash

# Grupo: 13
# Name: logT.sh
# Usage: ...
#
#
#

#Ayuda
USAGE="USAGE: logT command [message_type] message\
                "

#chequea y trunca si es necesario el archivo en caso de que llegue al tamaño maximo.
truncate() {

    SIZE=0
    #Obtengo el tamani del archivo, si es que este existe.
    if [ -e "$LOGDIR/$COMMAND.$LOGEXT" ]
    then
          SIZE=`du -sk "$LOGDIR/$COMMAND.$LOGEXT"`
          SIZE=`echo $SIZE | cut -f 1 -d ' '`
    fi

    AUXMAX=`expr $LOGSIZE \* 1024`
    
    #Si es mas grande que el tamani maximo permitido, entonces lo trunco.
    if [ $SIZE -gt $AUXMAX ]
    then
          TOTAL_LINES=`wc -l $LOGDIR/$COMMAND.$LOGEXT | cut -f 1 -d ' '`
          CUTLINES=`expr $TOTAL_LINES \/ 2`
          echo -e "`tail -n $CUTLINES "$LOGDIR/$COMMAND.$LOGEXT"`" > "$LOGDIR/$COMMAND.$LOGEXT"
          echo "$DATE-$USER-I-LOG EXCEEDED." >> "$LOGDIR/$COMMAND.$LOGEXT"
    fi

    return 0
}

#Funcion principal.
#Parametros
#     Parametro 1 (obligatorio): COMMAND
#     Parametro 2 (obligatorio): Tipo de MSG
#     Parametro 3 (obligatorio): MSG
main() {

    COMMAND=$1
    MSGTYPE=$2
    DATE=`date "+%Y%m%d_%H:%M:%S"`
    USER=`whoami`
    
    #Si MSG tiene mas de 140 caracteres lo trunco
    MSG=`echo $3 | sed 's/\(^.\{140\}\).*/\1/'`

    case $COMMAND in

    'instalar')
                #Para cuando el COMMAND sea INSTALAR el log va al directorio default segun enunciado: logdir
                echo "$DATE-$USER-$COMMAND-$MSGTYPE-$MSG." >> "$GRUPO/logdir/$COMMAND.$LOGEXT";;
    *)
                #Trunco el archivo en caso de que sea mas grande que lo permitido.
                truncate
                #Escribo en el log.
                echo "$DATE-$USER-$COMMAND-$MSGTYPE-$MSG." >> "$LOGDIR/$COMMAND.$LOGEXT";;
    esac
}

# Chequea que la variable logdir sea un directorio valido (salvo en el caso de la instalacion)
if [ ! -d "$LOGDIR" ] && [ ! $COMMAND == "instalar" ]  ; then
   echo "No existe el directorio [$LOGDIR]"
   exit 1
fi

#Tiene que tener tres parametros obligatoriamente.
if [ $# \< 3 ] || [ $# \> 3 ]; then
    echo $USAGE
    exit 2
fi

main "$1" "$2" "$3"
exit 0

