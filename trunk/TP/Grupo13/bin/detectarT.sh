chequeaProceso(){

  #El Parametro 1 es el proceso que voy a buscar
  PROC=$1
  PROC_LLAMADOR=$2

  #Busco en los procesos en ejecucion y omito "grep" ya que sino siempre se va a encontrar a si mismo
  # -w es para que busque coincidencia exacta en la palabra porque sino estamos obteniendo cualquier cosa.
  PID=`ps ax | grep -v $$ | grep -v grep | grep -v -w "$PROC_LLAMADOR" | grep $PROC`
  PID=`echo $PID | cut -f 1 -d ' '`
  echo $PID
  
}

agregarVariablePath(){
  #echo $PATH
  NEWPATH=`pwd`
  export PATH=$PATH:$NEWPATH
  #echo $PATH
}



#main()


# esto se va a comentar luego. Inicia afuera
LOOP=true
CANT_LOOP=0
ESPERA=1
#ARRIDIR="./TP/ssoo1c-2012/TP/Grupo13/inst_recibidas/"
ARRIDIR="../arribos/"
DIRMAE="/home/lucas/TP/ssoo1c-2012/TP/Grupo13/maestro"
ARCHIVO="$DIRMAE/sucu.mae"
grupo="/home/lucas/TP/ssoo1c-2012/TP/Grupo13"
RECHDIR="../inst_rechazadas"


if ([ ! -d $RECHDIR ]) then
   echo "No existe Directorio de Rechazos $RECHDIR"
   exit 1
fi

if ([ ! -d "$grupo/inst_recibidas" ]) then
   echo "No existe Directorio de recibidos $grupo/inst_recibidas"
   exit 1
fi

while [ $CANT_LOOP -lt 1 ]
do
   if ([ -d $ARRIDIR ]) then
        ARCHIVOS=`ls -p $ARRIDIR | grep -v '/$'`
        for PARAM in $ARCHIVOS
        do    
            #Obtengo Sucursal y mes
            REGION=`echo "$PARAM" | cut -f 1 -d '-'`
            SUCURSAL=`echo "$PARAM" | cut -f 2 -d '-'`
	    if ([ -f $ARCHIVO ]) then
 	       a=0
    	       a=`cut -f1,3 -d',' $ARCHIVO | grep $REGION,$SUCURSAL -n | cut -f1 -d':'`

	       if ([ $a ]) then
                   START_DATE=`head -$a $ARCHIVO | tail -1 | cut -f7 -d','`
                   END_DATE=`head -$a $ARCHIVO | tail -1 | cut -f8 -d','` 


	           #FECHA ACTUAL PARA COMPARAR
                   DATE=`date +%y%m%d`
                   DATE=`echo "20$DATE"`

	           #FECHA DE INICIO SUCURSAL
                   ANO=`echo "$START_DATE" | cut -f3 -d'/'`
	           MES=`echo "$START_DATE" | cut -f2 -d'/'`
	           DIA=`echo "$START_DATE" | cut -f1 -d'/'`
	           START_DATE=`echo $ANO$MES$DIA`
	       
                   if ( [ $END_DATE ] ) then
	              #FECHA DE FIN SUCURSAL
                      ANO=`echo "$END_DATE" | cut -f3 -d'/'`
	              MES=`echo "$END_DATE" | cut -f2 -d'/'`
	              DIA=`echo "$END_DATE" | cut -f1 -d'/'`
	              END_DATE=`echo $ANO$MES$DIA`	             
                   else
                      END_DATE=$DATE
                   fi
 		   if ( ([ $START_DATE -lt $DATE ]) || ([ $START_DATE -eq $DATE ]) ) && ( ([ $END_DATE -gt $DATE ]) || ([ $END_DATE -eq $DATE ]) ) then 
		      perl moverT.pl "$ARRIDIR$PARAM"  "$grupo/inst_recibidas"
#		      bash loguearT.sh "$COMANDO" "I" "Archivo $PARAM enviado"  
                   else
		      perl moverT.pl "$ARRIDIR$PARAM"  "$RECHDIR"
#	 	      bash loguearT.sh "$COMANDO" "I" "Archivo $PARAM rechazado por sucursal no vigente"  
                   fi
	       	else
  	           perl moverT.pl "$ARRIDIR$PARAM"  "$RECHDIR"		
#		   bash loguearT.sh "$COMANDO" "I" "Archivo $PARAM rechazado por nombre incorrecto"  
                fi
            else
               echo "No existe el archivo de sucursales"
            fi
        done
   else
     echo "No Existe $ARRIDIR!"
   fi

   let CANT_LOOP=CANT_LOOP+1



   ENRECIBIDOS=`ls -1 "$grupo/inst_recibidas" | wc -l | awk '{print $1}'`

   echo "ENRECIBIDOS $ENRECIBIDOS"
   if ([ $ENRECIBIDOS -gt 0 ]) then
      #Detecto si grabarParqueT esta corriendo	
      GRABARPARQUET_PID=`chequeaProceso grabarParqueT.sh $$`
      if [ -z "$GRABARPARQUET_PID" ]; then
#         bash grabarParqueT.sh
#         echo "grabarParqueT corriendo bajo el numero de proceso: <`chequeaProceso grabarParqueT.sh $$`>" 
	  echo "TODO BIEN"
      else
#         bash loguearT.sh "$COMANDO" "E" "Demonio grabarParqueT ya ejecutado bajo PID: <`chequeaProceso grabarParqueT.sh $$`>" 
#         echo "Error: grabarParqueT ya ejecutado bajo PID: <`chequeaProceso grabarParqueT.sh $$`>"
          echo "ERROR"
         exit 1
      fi
   fi



   sleep ${ESPERA}s
done

LOOP=0
   	
exit 0

