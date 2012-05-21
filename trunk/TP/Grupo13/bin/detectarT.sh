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






#main()


# esto se va a comentar luego. Inicia afuera
LOOP=true
CANT_LOOP=0
ESPERA=1
#ARRIDIR="./TP/ssoo1c-2012/TP/Grupo13/inst_recibidas/"
ARRIDIR="../inst_recibidas/"
DIRMAE="/home/lucas/TP/ssoo1c-2012/TP/Grupo13/maestro"
ARCHIVO="$DIRMAE/sucu.mae"


#Detecto si detectarT esta corriendo
DETECTAR_PID=`chequeaProceso detectarT.sh $$`
if ([ -z "$DETECTAR_PID" ])then 
 while [ $CANT_LOOP -lt 5 ]
 do
   if ([ -d $ARRIDIR ]) then
        ARCHIVOS=`ls -p $ARRIDIR | grep -v '/$'`
        for PARAM in $ARCHIVOS
        do    
            #Obtengo Sucursal y mes
            REGION=`echo "$PARAM" | cut -f 1 -d '-'`
            SUCURSAL=`echo "$PARAM" | cut -f 2 -d '-'`
	    echo "Region: $REGION"
	    echo "Sucursal: $SUCURSAL"
	    if ([ -f $ARCHIVO ]) then
 	       a=0
    	       a=`cut -f1,3 -d',' $ARCHIVO | grep $REGION,$SUCURSAL -n | cut -f1 -d':'`

	       if ([ $a ]) then
              	   echo "a: $a"
                   START_DATE=`head -$a $ARCHIVO | tail -1 | cut -f7 -d','`
                   END_DATE=`head -$a $ARCHIVO | tail -1 | cut -f8 -d','` 


	           #FECHA ACTUAL PARA COMPARAR
                   DATE=`date +%y%m%d`
                   DATE=`echo "20$DATE"`
                   echo "DATE $DATE"

	           #FECHA DE INICIO SUCURSAL
                   ANO=`echo "$START_DATE" | cut -f3 -d'/'`
	           MES=`echo "$START_DATE" | cut -f2 -d'/'`
	           DIA=`echo "$START_DATE" | cut -f1 -d'/'`
	           START_DATE=`echo $ANO$MES$DIA`
 	           echo "START_DATE: $START_DATE"
	       
                   if ( [ $END_DATE ] ) then
	              #FECHA DE FIN SUCURSAL
                      ANO=`echo "$END_DATE" | cut -f3 -d'/'`
	              MES=`echo "$END_DATE" | cut -f2 -d'/'`
	              DIA=`echo "$END_DATE" | cut -f1 -d'/'`
	              END_DATE=`echo $ANO$MES$DIA`	             
                   else
                      END_DATE=$DATE
                   fi
		   echo "END_DATE: $END_DATE"
 		   if ( ([ $START_DATE -lt $DATE ]) || ([ $START_DATE -eq $DATE ]) ) && ( ([ $END_DATE -gt $DATE ]) || ([ $END_DATE -eq $DATE ]) ) then 
		      echo "ENTRA" 
                   else
                      echo "NO ENTRA"
                   fi
	       	else
		   echo "No Existe la combinación Región-sucursal"
                fi
            else
               echo "No encontre"
            fi
        done
   else
     echo "No Existe ARRIDIR!"
   fi

   let CANT_LOOP=CANT_LOOP+1
   echo "CANT_LOOP: $CANT_LOOP"
   sleep ${ESPERA}s
 done

 LOOP=0
   	
 exit 0

else
   echo "PID $DETECTAR_PID"
   echo "YA ESTA CORRIENDO detectarT.sh"
   exit 1
fi





