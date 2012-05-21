#!/bin/bash

# Grupo: 13
# Name: logT.sh
# Usage: see below
#

source global.sh
COMANDO="grabarParque"

INSTREC="$GRUPO/inst_recibidas"
INSTORD="$GRUPO/inst_ordenadas"
INSTPROC="$GRUPO/inst_procesadas"
LINEA_ORD=()
chequeaVariables(){

  if [ "$LOGEXT" != "" ] && [ "$BINDIR" != "" ] && [ "$DATASIZE" != "" ] \
  && [ "$GRUPO" != "" ] && [ "$ARRIDIR" != "" ] && [ "$RECHDIR" != "" ] \
  && [ "$MAEDIR" != "" ] && [ "$REPODIR" != "" ] && [ "$LOGDIR" != "" ] \
  && [ "$LOGSIZE" != "" ]; then
    # Variables inicializadas correctamente
    echo 0
  else
    echo 1
  fi

}

chequeaArchivosMaestros(){

  CLIENTES=$MAEDIR/cli.mae
  SUCURSALES=$MAEDIR/sucu.mae
  PRODUCTOS=$MAEDIR/prod.mae

  #Chequeo que los archivos existan
  if [ ! -f $CLIENTES ] ; then
    #Error severo - No hay archivo maestros
    echo 1
    return
  fi
  
  if [ ! -f $SUCURSALES ] ; then
   #Error severo - No hay archivo maestros
   echo 1
   return
  fi
  
  if [ ! -f $PRODUCTOS ] ; then
    #Error severo - No hay archivo maestros
    echo 1
    return
  fi
  
  #Chequeo que los archivos tengan permisos de lectura al menos
  if [ ! -r "$CLIENTES" ] ; then
    #Error severo - No hay archivo maestros
    echo 1
    return
  fi
  
  if [ ! -r "$SUCURSALES" ] ; then
    #Error severo - No hay archivo maestros
    echo 1
    return
  fi
  
  if [ ! -r "$PRODUCTOS" ] ; then
    #Error severo - No hay archivo maestros
    echo 1
    return
  fi
  
  echo 0
  return
}


chequeaDirectorios(){

  # Chequeo que existan los directorios
  if [ ! -d "$GRUPO" ] && [ ! -d "$LOGDIR" ] && [ ! -d "$MAEDIR" ] \
  && [ ! -d "$ARRIDIR" ] && [ ! -d "$RECHDIR" ] && [ ! -d "$REPODIR" ] \
  && [ ! -d "$BINDIR" ] && [ ! -d "$INSTREC" ] && [ ! -d "$INSTORD" ] \
  && [ ! -d "$INSTPROC" ] ; then
    #echo "Directorios necesarios no creados"
    echo 1
    return
  fi
  echo 0
  return
}

chequearInstalacion(){

  # Chequeo el log de instalarT en busca de "Estado de la instalacion: LISTA"
  #TODO> mirarT
  echo 0
  return
}

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


# 1.Verificar si se puede iniciar la ejecución del comando (inicialización de ambiente realizada, 
# 	y que no haya otro GrabarParqueT corriendo). 
# 	a. Si no se puede iniciar, mostrar un mensaje explicativo y terminar la ejecución de este.
# 	b. Si se puede iniciar, seguir en el siguiente paso
#
# 2.Inicializar el Log
# 	Grabar en log: Inicio de GrabarparqueT: <cantidad de archivos a procesar>
#
# 3.Procesar Un Archivo recibido
# 	Los archivos de input se encuentran en $grupo/inst_recibidas
# 	Grabar en log: Archivo a Procesar: <nombre del archivo>
#
# 4.Verificar que no sea un archivo duplicado
# 	Analizar el directorio $grupo/inst_procesadas. Si en ese directorio existe un archivo de igual 
# 	nombre, entonces se lo considerará duplicado. En este caso, mover el archivo a RECHDIR 
# 	empleando la función moverT, grabar en log y seguir con el siguiente archivo recibido
# 	Si no está duplicado, seguir en el siguiente paso
#
# 5.Ordenar el archivo
#
# 6.Mover el archivo recibido en $grupo/inst_procesadas empleando la función moverT para 
# 	evitar su reprocesamiento
#
# 7. Grabar el archivo ordenado, si ya existe, un archivo ordenado del mismo nombre, reemplazarlo
#
# 8. Procesar Un Archivo ordenado
#
# 9.Verificar que el bloque este completo
# 	Si el bloque no supera la validación a este nivel, GRABAR EL BLOQUE COMPLETO:
# 	a. 	grabar el bloque completo en /inst_rechazadas/<región_id>-<branch_id>, si el archivo 
# 		no existe, crearlo, si ya existe, agregarle los nuevos registros.
# 	b. 	Contabilizar la cantidad de registros rechazados
# 	c. 	Seguir con el siguiente bloque
#
# 10.Verificar registro cabecera
# 	Si el registro no supera la validación a este nivel, grabar el bloque completo como se indica en 9 (a.b.c)
#
# 11. Verificar registros de detalle
# 	Si un registro no supera la validación a este nivel, grabar el bloque completo como se indica en 9 (a.b.c)
#
# 12. Verificar contenido de los campos y otras verificaciones que se consideren pertinentes
# 	Si un registro no supera la validación a este nivel, grabar el bloque completo como se indica en 9 (a.b.c)
#
# 13. Si todas las verificaciones fueron superadas grabar un registro en el archivo de parque instalado que corresponda:
# 		a. Si el tipo de producto asociado al COMMERCIAL_PLAN_ID es INTERNETADSL, grabar en $grupo/parque_instalado/INTERNETADSL
# 		b. Si el tipo de producto asociado al COMMERCIAL_PLAN_ID es INTERNETCABLEMODEM, grabar en $grupo/parque_instalado/INTERNETCABLEMODEM
# 		c. Si el tipo de producto asociado al COMMERCIAL_PLAN_ID es INTERNETDIALUP, grabar en $grupo/parque_instalado/INTERNETDIALUP
# 		d. Si el tipo de producto asociado al COMMERCIAL_PLAN_ID es INTERNETINALAMBRICO, grabar en $grupo/parque_instalado/INTERNETINALAMBRICO
# 		e. Si el tipo de producto asociado al COMMERCIAL_PLAN_ID es TVPORAIRE, grabar en $grupo /parque_instalado/TVPORAIRE
# 		f. Si el tipo de producto asociado al COMMERCIAL_PLAN_ID es TVPORCABLE , grabar en $grupo/parque_instalado/TVPORCABLE
#
# 14. Contabilizar la cantidad de registros validados ok
#
# 15. Seguir con el siguiente bloque hasta terminar el archivo ordenado
#
# 16. 	Fin de Archivo Ordenado: Cuando se termina de procesar un archivo de instalaciones ordenado, repetir desde el paso 4 
# 		hasta que se terminen todos los archivos recibidos.
#
# 17. Grabar en el cuantos archivos se leyeron de $grupo/inst_recibidas, cuantos archivos se ordenaron, cuantos se rechazaron-
#
# 18. Grabar en el log cuantos registros se leyeron, cuantos se rechazaron y cuantos se grabaron en algún parque instalado.
#
# 19. Grabar en el log el total de control = rechazados + (grabados en parque * 2). Cerrar el Log


#main()

  # For Debug Use: shows the vars on the current env.
  # printVariables
  
  bash loguearT.sh "$COMANDO" "I" "Comienzo de ejecucion de $COMANDO"


# INICIO: Validacion de ambiente
  if [ `chequeaVariables` -eq 1 ] ; then
    bash loguearT.sh "$COMANDO" "SE" "Variables no definidas durante la instalacion o no disponibles"
    echo "Error Severo: Variables no definidas durante la instalacion o no disponibles"
    exit 1
  fi

  if [ `chequearInstalacion` -eq 1 ] ; then
    bash loguearT.sh "$COMANDO" "SE" "Variables no definidas durante la instalacion o no disponibles"
    echo "Error Severo: Variables no definidas durante la instalacion o no disponibles"
    exit 1
  fi

  if [ `chequeaDirectorios` -eq 1 ] ; then
    bash loguearT.sh "$COMANDO" "SE" "Directorios necesarios no creados en la instalacion o no disponibles" 
    echo "Error Severo: Directorios necesarios no creados en la instalacion o no disponibles"
    exit 1
  fi

  if [ `chequeaArchivosMaestros` -eq 1 ] ; then
    bash loguearT.sh "$COMANDO" "SE" "Archivos maestros no accesibles/disponibles"
    echo "Error Severo: Archivos maestros no accesibles/disponibles"
    exit 1
  fi
# FIN: Validacion de ambiente

  #Detecto si grabarParque esta corriendo
  GRABAR_PID=`chequeaProceso grabarParque.sh $$`
  if [ ! -z "$DETECTAR_PID" ]; then
	bash loguearT.sh "$COMANDO" "SE" "$COMANDO se encuntra inicializado con PID: <$GRABAR_PID>"
	exit 1
  fi
  
  #Lee todos los archivos del directorio de arribos uno por uno
  ARCH_REC="$INSTREC/*"
  QTY_ARCH=`ls $INSTREC | wc -l`
  bash loguearT.sh "$COMANDO" "I" "Inicio de $COMANDO, cantidad de archivos a procesar: $QTY_ARCH"

  for ARCHIVO in $ARCH_REC; 
    do
	bash loguearT.sh "$COMANDO" "I" "Procesando archivo: $ARCHIVO"
	
	# Si el directorio esta vacio termino la ejecucion
      if [ "$ARCHIVO" == "$ARCH_REC" ]; then
        bash loguearT.sh "$COMANDO" "I" "No restan mas archivos por procesar"
        break
      fi
	
	
	# Chequea duplicado en carpeta de procesados
	if [ -f "$INSTPROC/$ARCHIVO" ] ; then
		perl moverT.pl "$INSTREC/$ARCHIVO" "$RECHDIR/" $COMANDO
		bash loguearT.sh "$COMANDO" "A" "Archivo: $ARCHIVO duplicado, moviendo a $INSTREC"
		continue
	fi

	let QTYLINEAS=0
	let QTYRECH=0
	let QTYOK=0
	
    # Formato registros detalle/cabecera
    # Id del Cliente - numérico - CUSTOMER_ID
    # Fecha de Operación - Fecha - OPERATION_DATE
    # Id del Plan Comercial - numérico - COMMERCIAL_PLAN_ID
    # Id de la Clase de Servicio - numérico - CLASS_SERVICE_ID
    # Clase de Servicio requerida - caracter - CLASS_SERVICE_IS_REQUIRED
    # Id del Ítem de Producto - numérico - ITEM_ID
    # Separador: coma
	
	for LINEA in `cat $ARCHIVO`
      do
      # Ordeno el archivo
      # CUSTOMER_ID (asc), OPERATION_DATE (de la mas antigüa a la más reciente), 
	  # COMMERCIAL_PLAN_ID (asc) y CLASS_SERVICE_IS_REQUIRED (desc). 
	  
	  CUSTID=`echo $LINEA | cut -d "," -f 1`
	  OPDATE=`echo $LINEA | cut -d "," -f 2`
	  CPID=`echo $LINEA | cut -d "," -f 3`
	  CSID=`echo $LINEA | cut -d "," -f 4`
	  CSR=`echo $LINEA | cut -d "," -f 5`
	  ITEMID=`echo $LINEA | cut -d "," -f 6`
		
	  # Pre chequeo si estan todos los campos y rechazo anticipadamente
	  # Tambien valido formatos TODO
	  # ...
	  
	  if [ $QTYLINEAS == 0 ] ; then
	    LINEA_ORD[$QTYLINEAS]=`echo "$CUSTID,$OPDATE,$CPID,$CSID,$CSR,$ITEMID"`
	    let QTYLINEAS=$QTYLINEAS+1
		continue
	  fi

	  for (( i=0;i<$QTYLINEAS;i++)); do  
		# Comienzo leyendo desde el ppio. si es menor puedo insertar sino continuo la busqueda
		let INDEX=$i
		AUX_CUSTID=`echo ${LINEA_ORD[INDEX]} | cut -d "," -f 1`
		AUX_OPDATE=`echo ${LINEA_ORD[INDEX]} | cut -d "," -f 2`
		AUX_CPID=`echo ${LINEA_ORD[INDEX]} | cut -d "," -f 3`
		AUX_CSID=`echo ${LINEA_ORD[INDEX]} | cut -d "," -f 4`
		
		#echo "Linea auxiliar: $AUX_CUSTID,$AUX_OPDATE,$AUX_CPID,$AUX_CSID,$CSR,$ITEMID"
        LINEA_AUX="$CUSTID,$OPDATE,$CPID,$CSID,$CSR,$ITEMID"
		#echo "linea aux a agregar es: $LINEA_AUX"
		# Primero comparo por CUST_ID
		if [ $AUX_CUSTID -gt $CUSTID ] ; then
		  #LINEA_AUX="$CUSTID,$OPDATE,$CPID,$CSID,$CSR,$ITEMID"
		    
		  #echo "cust id leido menor"
		  #for j in {$QTYLINEAS..$i} 
		  for (( j=$QTYLINEAS;j>$i;j--)); do
			#echo "en for j es: $j"	
			LINEA_ORD[$j]=`echo ${LINEA_ORD[$j-1]}`	
			#echo "Linea $j es ${LINEA_ORD[$j]}"			
		  done
		  LINEA_ORD[$i]=`echo $LINEA_AUX`
		  #echo "Linea $i es: ${LINEA_ORD[i]}"
		  let QTYLINEAS=$QTYLINEAS+1
		  let i=$i+1
		  break
		fi
		
		if [ $AUX_CUSTID -lt $CUSTID ] ; then
		  # Si es mayor debo avanzar salvo que sea el ultimo registro
		  let j=$i+1
                  #LINEA_AUX="$CUSTID,$OPDATE,$CPID,$CSID,$CSR,$ITEMID"
		  if [ $j -eq $QTYLINEAS ] ; then
			LINEA_ORD[$j]=`echo $LINEA_AUX`
			#echo "Linea $j es: ${LINEA_ORD[j]}"
			#echo "Linea $i es: ${LINEA_ORD[i]}"
			let QTYLINEAS=$QTYLINEAS+1
			let i=$i+1
		    break
		  fi
		  continue
		fi
				 
		# Si son iguales comparo por fecha
		#if [ $AUX_CUSTID -eq $CUSTID ] ; then
		  		  #TODO
		#fi
		  
		# Si son iguales comparo por Commercial Plan ID (CPID)
		#if [ $AUX_OPDATE -eq $OPDATE ] ; then
		  if [ $AUX_CPID -gt $CPID ] ; then
			for (( j=$QTYLINEAS;j>$i;j--)); do
			  LINEA_ORD[$j]=`echo ${LINEA_ORD[$j-1]}`
			  #echo "Linea $j es ${LINEA_ORD[$j]}"	
			done
			LINEA_ORD[$i]=`echo $LINEA_AUX`
			#echo "Linea $i es: ${LINEA_ORD[i]}"
			let QTYLINEAS=$QTYLINEAS+1
			let i=$i+1
			break
		  fi  
		  
		  if [ $AUX_CPID -lt $CPID ] ; then
		    # Si es mayor debo avanzar salvo que sea el ultimo registro
		    let j=$i+1
		    if [ $j -eq $QTYLINEAS ] ; then
			  LINEA_ORD[$j]=`echo $LINEA_AUX`
			  #echo "Linea $j es: ${LINEA_ORD[i]}"
			  let QTYLINEAS=$QTYLINEAS+1
			  let i=$i+1
		      break
		    fi
		    continue
		  fi
		#fi
		  
		# Si son iguales comparo por Class Service ID (CSID) 
		if [ $AUX_CPID -eq $CPID ] ; then
		  #echo "cpid iguales"
		  if [ $AUX_CSID -gt $CSID ] ; then
		    LINEA_AUX="$AUX_CUSTID,$AUX_OPDATE,$AUX_CPID,$AUX_CSID,$CSR,$ITEMID"
			#for j in {$QTYLINEAS..$i} 
			#  do
			for (( j=$QTYLINEAS;j>$i;j--)); do
			  LINEA_ORD[$j]=`echo ${LINEA_ORD[$j-1]}`
			  #echo "Linea $j es ${LINEA_ORD[$j]}"				  
			done
			LINEA_ORD[$i]=`echo $LINEA_AUX`
			#echo "Linea $i es: ${LINEA_ORD[i]}"
			let QTYLINEAS=$QTYLINEAS+1
			let i=$i+1
			break
		  fi
		  
		  if [ $AUX_CSID -lt $CSID ] ; then
		    # Si es mayor debo avanzar salvo que sea el ultimo registro
		    let j=$i+1
		    if [ $j -eq $QTYLINEAS ] ; then
			  LINEA_ORD[$j]=`echo $LINEA_AUX`
			  #echo "Linea $j es: ${LINEA_ORD[i]}"
			  let QTYLINEAS=$QTYLINEAS+1
			  let i=$i+1
		      break
		    fi
		    continue
		  fi
		  
		  #Si no pude diferenciar por CSID debo ingresar de todos modos el valor
		  # TODO deberia chequear que no sea el mismo y en ese caso abortarlo
			LINEA_AUX="$AUX_CUSTID,$AUX_OPDATE,$AUX_CPID,$AUX_CSID,$CSR,$ITEMID"
			for (( j=$QTYLINEAS;j>$i;j--)); do
			  LINEA_ORD[$j]=`echo ${LINEA_ORD[$j-1]}`
			  #echo "Linea $j es ${LINEA_ORD[$j]}"				  
			done
			LINEA_ORD[$i]=`echo $LINEA_AUX`
			#echo "Linea $i es: ${LINEA_ORD[i]}"
			let QTYLINEAS=$QTYLINEAS+1
			let i=$i+1
			break
		fi
		
	  done
	  #let QTYLINEAS=$QTYLINEAS+1	
	done
	
	let QTYOK=$QTYOK+1
	
	# Grabar archivo ordenado en inst_ordenadas, si existe reemplazarlo
	# TODO REMPLAZO
	for (( i=0;i<$QTYLINEAS;i++)); do 
	  FILENAME=`echo $ARCHIVO | sed 's/.*\///'`
	  echo "Guardando en archivo $INSTORD/$FILENAME"
	  echo ${LINEA_ORD[i]} >> "$INSTORD/$FILENAME"
	done
	
	# Muevo para evitar el reprocesamiento
	perl moverT.pl "$INSTREC/$FILENAME" "$INSTPROC/" $COMANDO
  done
  
  # Comienzo el procesamiento de los archivos
  
	
	





















































