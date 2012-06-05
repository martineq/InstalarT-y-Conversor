#!/bin/bash

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	grabarParqueT.sh	#
#					#
#########################################


###########################################################
# 1. Verificar si se puede iniciar la ejecución del comando (inicialización de ambiente realizada,
# y que no haya otro GrabarParqueT corriendo).
# 2. Inicializar el Log
# 3. Procesar Un Archivo recibido
# 4. Verificar que no sea un archivo duplicado
# 5. Ordenar el archivo
# 6. Mover el archivo recibido en $grupo/inst_procesadas empleando la función moverT para
# evitar su reprocesamiento
# 7. Grabar el archivo ordenado, si ya existe, un archivo ordenado del mismo nombre, reemplazarlo
# 8. Procesar Un Archivo ordenado
# 9. Verificar que el bloque este completo
# 10. Verificar registro cabecera
# 11. Verificar registros de detalle
# 12. Verificar contenido de los campos y otras verificaciones que se consideren pertinentes
# 13. Si todas las verificaciones fueron superadas grabar un registro en el archivo de parque
# 14. Contabilizar la cantidad de registros validados ok
# 15. Seguir con el siguiente bloque hasta terminar el archivo ordenado
# 16. Grabar en el cuantos archivos se leyeron de $grupo/inst_recibidas, cuantos archivos se
# ordenaron, cuantos se rechazaron-
# 18. Grabar en el log cuantos registros se leyeron, cuantos se rechazaron y cuantos se
# grabaron en algún parque instalado.
# 19. Grabar en el log el total de control. Cerrar el Log.
###########################################################


# Usage: see below

#source global.sh
COMANDO="grabarParque"

INSTREC="$GRUPO/inst_recibidas"
INSTORD="$GRUPO/inst_ordenadas"
INSTPROC="$GRUPO/inst_procesadas"
PRODUCTOS="$MAEDIR/prod.mae"
CLIENTES="$MAEDIR/cli.mae"
SUCURSALES="$MAEDIR/sucu.mae"

LINEA_ORD=()

# Para desarrollo unicamente
DEBUG=0



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

# Compara las fechas de AUX_OPDATE y OPDATE
# Devuelve 1 si AUX es mayor y 0 si es menor.
comparaFechas(){

	AUX_ANIO=`echo "$AUX_OPDATE" | cut -f3 -d'/'`
	AUX_MES=`echo "$AUX_OPDATE" | cut -f2 -d'/'`
	AUX_DIA=`echo "$AUX_OPDATE" | cut -f1 -d'/'`
	ANIO=`echo "$OPDATE" | cut -f3 -d'/'`
	MES=`echo "$OPDATE" | cut -f2 -d'/'`
	DIA=`echo "$OPDATE" | cut -f1 -d'/'`

	if [ $AUX_ANIO -gt $ANIO ] || ( [ $AUX_ANIO -eq $ANIO ] && [ $AUX_MES -gt $MES ] ) \
		|| ( [ $AUX_ANIO -eq $ANIO ] && [ $AUX_MES -eq $MES ] && [ $AUX_DIA -gt $DIA ] ) ; then
		echo 1
		return
	fi

	if [ $AUX_ANIO -lt $ANIO ] || ( [ $AUX_ANIO -eq $ANIO ] && [ $AUX_MES -lt $MES ] ) \
		|| ( [ $AUX_ANIO -eq $ANIO ] && [ $AUX_MES -eq $MES ] && [ $AUX_DIA -lt $DIA ] ) ; then
		echo 0
		return
	fi
	echo 2
	return	
}


validacionCabeceraDetalle(){

	#echo "Validando linea: $LINEA"
	QTY_FIELDS=`echo $LINEA | grep , -o | wc -l`
	if [ $QTY_FIELDS -gt 5 ] ; then
	  # Campo mal formado, se envia a rechazados
	  bash loguearT.sh "$COMANDO" "E" "Error validando archivo: $ARCHIVO, no posee el numero de campos indicados"
	  echo 1
	  return 1
	fi
	
	CUSTID=`echo $LINEA | cut -d "," -f 1`
	OPDATE=`echo $LINEA | cut -d "," -f 2`
	CPID=`echo $LINEA | cut -d "," -f 3`
	CSID=`echo $LINEA | cut -d "," -f 4`
	CSR=`echo $LINEA | cut -d "," -f 5`
	ITEMID=`echo $LINEA | cut -d "," -f 6`
	
	if [ ! -z $CUSTID ] && [ ! -z $OPDATE ] && [ ! -z $CPID ] \
	  && [ ! -z $CSID ] && [ ! -z $CSR ] && [ ! -z $ITEMID ] ; then
	  # Todos NO vacios
	  echo 0
	  return 0
	else
	  bash loguearT.sh "$COMANDO" "E" "Error validando archivo: $ARCHIVO, alguno de los campos obligatorios se encuentra vacio"
	  echo 1
	  return 1
	fi
	
	#TODO: Validar formato Cabecera y detalle con validarFormato
	
	echo 0	
}

cargaClientes(){
      TABLACLIENTES=( `cat "$CLIENTES" | sed 's#;.*##'`)
}

printClientes(){

for t in ${TABLACLIENTES[@]}
  do
  echo $t
done

}


cargaProductos(){
  TABLAPRODUCTOS=( `cat $PRODUCTOS | cut -d "," -f 2,3` )
}

cargaDescripciones(){
  OLDIFS=$IFS
  let i=0
	IFS=,
	[ ! -f $PRODUCTOS ] && { echo "$INPUT file not found"; exit 99; }
	while read a b c d e f csr it desc
		do
		#echo "en la posicion $i de la tabla puse $csr,$it,$desc"
        	TABLADESCRIPCIONES[$i]="$csr,$it,$desc"
		let i=$i+1
	done < $PRODUCTOS
  IFS=$OLDIFS
}


obtenerProducto(){
  CHEQPROD=`cat $PRODUCTOS | grep "^[^,]*,[^,]*,$CPID"`
  
  if [ -z "$CHEQPROD" ] ; then
    if [ $DEBUG -eq 1 ]; then
      bash loguearT.sh "DEBUG" "A" "Error al obtener el producto $CPID, el mismo no se encuentra en el archivo maestro"
    fi
    echo 1
    return 1
  fi
  
  #Valido que tenga registro cabecera detalle
#   CHEQITEM=`cat $PRODUCTOS | grep "^[^,]*,[^,]*,$CPID,[^,]*,[^,]*,[^,]*,N,$ITEMID"`
#   if [ -z "$CHEQITEM" ] ; then
#     if [ $DEBUG -eq 1 ]; then
#       bash loguearT.sh "DEBUG" "A" "Error no se encuentra registro cab. detalle en el archivo maestro para el el item $ITEMID"
#     fi
#     bash loguearT.sh "$COMANDO" "I" "El item: $ITEMID no posee un reg. cabecera detalle valido"
#     echo 1
#     return 1
#   fi
  
  
  echo 0
}


printProductos(){
for t in ${TABLAPRODUCTOS[@]}
  do
  echo $t
done
}

printDesc(){
for t in ${TABLADESCRIPCIONES[@]}
  do
  echo $t
done
}

validacionCampo(){
	#Valida la existencia del cliente en el archivo maestro
	if [ $DEBUG -eq 1 ]; then
	  bash loguearT.sh "DEBUG" "I" "validacionCampo>> linea = $LINEA"
	fi
 	CUSTID=`echo $LINEA | cut -d "," -f 1`
 	#CLIENTES=$MAEDIR/cli.mae
 	
        CHECKCLI=`cat $CLIENTES | grep "^$CUSTID;"`
	if [ $DEBUG -eq 1 ]; then
	  bash loguearT.sh "DEBUG" "I" "validacionCampo>> CUST ID: $CUSTID, CLI: $CHECKCLI"
	fi


	if [ -z "$CHECKCLI" ] ; then
 	  bash loguearT.sh "$COMANDO" "A" "Error en la validacion del archivo $ARCHIVO, el cliente $CUSTID no se encuentra en el archivo maestro"
 	  echo 1
 	  return 1
	fi
	echo 0
}

chequeaArchivosMaestros(){

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
  if [ ! -z "$GRABAR_PID" ]; then
	bash loguearT.sh "$COMANDO" "SE" "$COMANDO se encuntra inicializado con PID: <$GRABAR_PID>"
	exit 1
  fi
  
  #Lee todos los archivos del directorio de arribos uno por uno
  ARCH_REC="$INSTREC/*"
  QTY_ARCH=`ls $INSTREC | wc -l`
  bash loguearT.sh "$COMANDO" "I" "Inicio de $COMANDO, cantidad de archivos a procesar: $QTY_ARCH"

  let QTYREGRECH=0
  let QTYREGOK=0
  let QTYARCHRECH=0
  
  for ARCHIVO in $ARCH_REC; 
    do
	bash loguearT.sh "$COMANDO" "I" "Procesando archivo: $ARCHIVO"
	
	# Si el directorio esta vacio termino la ejecucion
      if [ "$ARCHIVO" == "$ARCH_REC" ]; then
        bash loguearT.sh "$COMANDO" "I" "No restan mas archivos por procesar"
        break
      fi
	FILENAMEAUX=`echo $ARCHIVO | sed 's#.*\/##'`
	CHEQDUP=`ls -l $INSTPROC | grep $FILENAMEAUX `
	# Chequea duplicado en carpeta de procesados
	if [ ! -z "$CHEQDUP" ] ; then
		perl moverT.pl "$INSTREC/$FILENAMEAUX" "$RECHDIR/" $COMANDO
		bash loguearT.sh "$COMANDO" "A" "Archivo: $ARCHIVO dup., moviendo a $RECHDIR/"
		let QTYARCHRECH=$QTYARCHRECH+1
		continue
	fi
	
	let QTYLINEAS=0
	
    # Formato registros detalle/cabecera
    # Id del Cliente - numérico - CUSTOMER_ID
    # Fecha de Operación - Fecha - OPERATION_DATE
    # Id del Plan Comercial - numérico - COMMERCIAL_PLAN_ID
    # Id de la Clase de Servicio - numérico - CLASS_SERVICE_ID
    # Clase de Servicio requerida - caracter - CLASS_SERVICE_IS_REQUIRED
    # Id del Ítem de Producto - numérico - ITEM_ID
    # Separador: coma
      FILENAME=`echo $ARCHIVO | sed 's#.*\/##'`
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
		
		#DEBUG - echo "Linea auxiliar: $AUX_CUSTID,$AUX_OPDATE,$AUX_CPID,$AUX_CSID,$CSR,$ITEMID"
        LINEA_AUX="$CUSTID,$OPDATE,$CPID,$CSID,$CSR,$ITEMID"
        
		if [ -z $CUSTID ] || [ -z $OPDATE ] || [ -z $CPID ] \
		  || [ -z $CSID ] || [ -z $CSR ] || [ -z $ITEMID ] ; then
		  # Todos NO vacios
# 		  bash loguearT.sh "$COMANDO" "I" "Error en validacion de estructura de campos"
# 		  let QTYREGRECH=$QTYREGRECH+1
# 		  #Lo agrego a los rechazados
# 		  `echo $LINEA >> "$RECHDIR/$FILENAME"`
		  continue
		fi
		
		if [ -z $AUX_CUSTID ] || [ -z $AUX_OPDATE ] || [ -z $AUX_CPID ] \
		  || [ -z $AUX_CSID ] ; then
		  # Todos NO vacios
		  continue
		fi
		
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
		if [ $AUX_CUSTID -eq $CUSTID ] ; then
		  if [ `comparaFechas` -eq 1 ] ; then
			# AUX_DATE es mayor
			for (( j=$QTYLINEAS;j>$i;j--)); do
			  LINEA_ORD[$j]=`echo ${LINEA_ORD[$j-1]}`
			  #DEBUG - echo "Linea $j es ${LINEA_ORD[$j]}"	
			done
			LINEA_ORD[$i]=`echo $LINEA_AUX`
			#DEBUG - echo "Linea $i es: ${LINEA_ORD[i]}"
			let QTYLINEAS=$QTYLINEAS+1
			let i=$i+1
			break
		  fi
		  
		  if [ `comparaFechas` -eq 0 ] ; then
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
		fi
		  
		# Si son iguales comparo por Commercial Plan ID (CPID)
		if [ $AUX_OPDATE == $OPDATE ] ; then
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
		fi
		  
		# Si son iguales comparo por Class Service ID (CSID) 
		if [ $AUX_CPID -eq $CPID ] ; then
		  if [ $AUX_CSID -gt $CSID ] ; then
		    LINEA_AUX="$AUX_CUSTID,$AUX_OPDATE,$AUX_CPID,$AUX_CSID,$CSR,$ITEMID"

			for (( j=$QTYLINEAS;j>$i;j--)); do
			  LINEA_ORD[$j]=`echo ${LINEA_ORD[$j-1]}`
			done
			LINEA_ORD[$i]=`echo $LINEA_AUX`
			let QTYLINEAS=$QTYLINEAS+1
			let i=$i+1
			break
		  fi
		  
		  if [ $AUX_CSID -lt $CSID ] ; then
		    # Si es mayor debo avanzar salvo que sea el ultimo registro
		    let j=$i+1
		    if [ $j -eq $QTYLINEAS ] ; then
			  LINEA_ORD[$j]=`echo $LINEA_AUX`
			  let QTYLINEAS=$QTYLINEAS+1
			  let i=$i+1
		      break
		    fi
		    continue
		  fi
		  
		  # Si no pude diferenciar por CSID debo ingresar de todos modos el valor
		  # Antes tomo el recaudo de ver si no son el mismo, en ese caso no inserto
		  if [ $LINEA_AUX == ${LINEA_ORD[i]} ] ; then
			#Son iguales
			#echo "iguales 100%, no inserto"
			break
		  fi
		  
		  for (( j=$QTYLINEAS;j>$i;j--)); do
			LINEA_ORD[$j]=`echo ${LINEA_ORD[$j-1]}`
		  done
		  LINEA_ORD[$i]=`echo $LINEA_AUX`
		  let QTYLINEAS=$QTYLINEAS+1
		  let i=$i+1
		  break
		fi
	  done
	done

        FILENAME=`echo $ARCHIVO | sed 's#.*\/##'`

	# Grabar archivo ordenado en inst_ordenadas, si existe reemplazarlo
	if [ -f "$INSTORD/$FILENAME" ] ; then
	  # Vacio el archivo - eliminandolo -
	  `rm $INSTORD/$FILENAME`
	fi
	
	for (( i=0;i<$QTYLINEAS;i++)); do 
	  echo ${LINEA_ORD[i]} >> "$INSTORD/$FILENAME"
	done
	
	# Muevo para evitar el reprocesamiento
	perl moverT.pl "$INSTREC/$FILENAME" "$INSTPROC/" $COMANDO
  done
  
  # Comienzo el procesamiento de los archivos ordenados
  
  #Lee todos los archivos del directorio de arribos uno por uno
  ARCH_ORD="$INSTORD/*"
  QTY_ARCH=`ls $INSTORD | wc -l`
  bash loguearT.sh "$COMANDO" "I" "Inicio de $COMANDO, cantidad de archivos ordenados a procesar: $QTY_ARCH"

# Para reducir IO se puede usar este esquema que realiza una carga inicial y luego busca sobre memoria,
#   cargaClientes
#   cargaProductos
#   cargaDescripciones

	let DETALLE=0
	let CABECERA=0
	let OLDCUSTID=0
  if [ $QTY_ARCH -gt 0 ]; then
  for ARCHIVO in $ARCH_ORD
    do
	FILENAME=`echo $ARCHIVO | sed 's#.*\/##'`
	bash loguearT.sh "$COMANDO" "I" "Procesando archivo: $ARCHIVO"
	bash loguearT.sh "$COMANDO" "I" "Procesando filename $FILENAME"
	for LINEA in `cat $ARCHIVO`
	  do

	  # Validacion Cabecera y Detalle
	  if [ `validacionCabeceraDetalle` -eq 1 ] ; then
	      # Error en la validacion de la cabecera
	      bash loguearT.sh "$COMANDO" "A" "Rechazando el registro por error en cabecera"
	      let QTYREGRECH=$QTYREGRECH+1
	      #Lo agrego a los rechazados
	      `echo $LINEA >> "$RECHDIR/$FILENAME"`
	      let CABECERA=0
	      let DETALLE=0
	      let OLDCUSTID=0
	      continue
	  fi

	  # Validacion de cliente
	  if [ `validacionCampo` -eq 1 ] ; then
	      bash loguearT.sh "$COMANDO" "A" "Rechazando el registro por error en campo"
	      let QTYREGRECH=$QTYREGRECH+1
	      #Lo agrego a los rechazados
	      `echo $LINEA >> "$RECHDIR/$FILENAME"`
	      let CABECERA=0
	      let DETALLE=0
	      let OLDCUSTID=0
	      continue
	  fi
	  
	  CUSTID=`echo $LINEA | cut -d "," -f 1`
          CSR=`echo $LINEA | cut -d "," -f 5 | sed -e 's///g'`
          ITEMID=`echo $LINEA | cut -d "," -f 6 | sed -e 's///g'`
	  CPID=`echo $LINEA | cut -d "," -f 3`

	  PARQDIR="$GRUPO/parque_instalado"

	  # Valido el producto
	  if [ `obtenerProducto` -eq 1 ] ; then
	    let QTYREGRECH=$QTYREGRECH-1
	    bash loguearT.sh "$COMANDO" "I" "Codigo de producto no encontrado en archivo maestro"
	    #Lo agrego a los rechazados
	    `echo $LINEA >> "$RECHDIR/$FILENAME"`
	    let CABECERA=0
	    let DETALLE=0
	    let OLDCUSTID=0
	    continue
	  fi

	# Formo la linea nueva
	CHEQDESC=`cat $PRODUCTOS | grep ".*,$CSR,$ITEMID,[^,]*$"`
	if [ -z "$CHEQDESC" ] ; then
	  let QTYREGRECH=$QTYREGRECH+1
	  bash loguearT.sh "$COMANDO" "I" "Codigo de desc. de prod no encontrado en archivo maestro"
	  #Lo agrego a los rechazados
	  `echo $LINEA >> "$RECHDIR/$FILENAME"`
	  let CABECERA=0
	  let DETALLE=0
	  let OLDCUSTID=0
	  continue
	fi
		
	let QTYREGOK=$QTYREGOK+1

	if [ ! $CUSTID -eq $OLDCUSTID -a ! $OLDCUSTID -eq 0 ] ; then
	  bash loguearT.sh "$COMANDO" "I" "Error, bloque incompleto, se precisa un reg cab y otro detalle"
	  let QTYREGRECH=$QTYREGRECH+1
	  #Muevo el anterior a rechazados
	  `echo $LINEAANT >> "$RECHDIR/$FILENAME"`
	  let CABECERA=0
	  let DETALLE=0
	  let OLDCUSTID=0
	  
	fi
	
	if [ "$CSR" == "Y" -a $CUSTID -eq $OLDCUSTID ] || [ "$CSR" == "Y" -a $OLDCUSTID -eq 0 ]; then
	  let CABECERA=1
	  LINEAANT=$LINEA
	fi
	
	if [ "$CSR" == "N" -a $CUSTID -eq $OLDCUSTID ] || [ "$CSR" == "N" -a $OLDCUSTID -eq 0 ]; then
	  let DETALLE=1
	  DESC=`cat $PRODUCTOS | grep "^[^,]*,[^,]*,$CPID,[^,]*,[^,]*,[^,]*,Y," | head -n 1 | cut -d "," -f 9`
	  DESCDET=`cat $PRODUCTOS | grep "$CPID,[^,]*,[^,]*,[^,]*,N,$ITEMID,[^,]*$" | head -n 1 | cut -d "," -f 9`
	  PROD=`cat $PRODUCTOS | grep "^[^,]*,[^,]*,$CPID" | head -n 1 | cut -d "," -f 2`
          #Del nombre del archivo obtenfo el nombre de la suc (suc id en realidad)
	  BRANCHIDAUX=`echo $FILENAME | cut -d "-" -f2`
	  BRANCHID=`echo $BRANCHIDAUX | cut -d "." -f1`
	  LINEA_NUEVA="$BRANCHID,$CUSTID,$DESC,$DESCDET"
	  LINEAANT=$LINEA
	
	fi

	if [ $DEBUG -eq 1 ]; then
	  bash loguearT.sh "DEBUG" "Validacion parque_instalado"
	  bash loguearT.sh "DEBUG" "Linea: $LINEA"
	  bash loguearT.sh "DEBUG" "CPID: $CPID "
	  bash loguearT.sh "DEBUG" "ITEM_ID: $ITEMID"
	  bash loguearT.sh "DEBUG" "CSR: $CSR"
	  bash loguearT.sh "DEBUG" "DESC $DESC"
	  bash loguearT.sh "DEBUG" "DESCDET $DESCDET "
	  bash loguearT.sh "DEBUG" "PROD $PROD"
	  bash loguearT.sh "DEBUG" "A parqueInst $PROD >> $LINEA_NUEVA"
	fi
	  
	if [ $CABECERA -eq 1 -a $DETALLE -eq 1 ] ; then  
	  let CABECERA=0
	  let DETALLE=0
	  let OLDCUSTID=0
	  
	  case $PROD in
	    "INTERNETADSL")
	      echo $LINEA_NUEVA >> "$PARQDIR/INTERNETADSL"
	      bash loguearT.sh "$COMANDO" "I" "Grabando entrada en archivo $PARQDIR/INTERNETADSL"
	      ;;
	    "INTERNETCABLEMODEM")
	      
	      echo $LINEA_NUEVA >> "$PARQDIR/INTERNETCABLEMODEM"
	      bash loguearT.sh "$COMANDO" "I" "Grabando entrada en archivo $PARQDIR/INTERNETCABLEMODEM"
	      ;;
	    "INTERNETDIALUP")
	      echo $LINEA_NUEVA >> "$PARQDIR/INTERNETDIALUP"
	      bash loguearT.sh "$COMANDO" "I" "Grabando entrada en archivo $PARQDIR/INTERNETDIALUP"
	      ;;
	    "INTERNETINALAMBRICO")
	      echo $LINEA_NUEVA >> "$PARQDIR/INTERNETINALAMBRICO"
	      bash loguearT.sh "$COMANDO" "I" "Grabando entrada en archivo $PARQDIR/INTERNETINALAMBRICO"
	      ;;
	    "TVPORAIRE")
	      echo $LINEA_NUEVA >> "$PARQDIR/TVPORAIRE"
	      bash loguearT.sh "$COMANDO" "I" "Grabando entrada en archivo $PARQDIR/TVPORAIRE"
	      ;;
	    "TVPORCABLE")
	      echo $LINEA_NUEVA >> "$PARQDIR/TVPORCABLE"
	      bash loguearT.sh "$COMANDO" "I" "Grabando entrada en archivo $PARQDIR/TVPORCABLE"
	      ;;
	    *)
	      bash loguearT.sh "$COMANDO" "A" "Commercial Plan ID no reconocido"
	      ;;	  
	  esac
	fi
	  
	done
  done
  fi
  bash loguearT.sh "$COMANDO" "I" "Eliminando archivos ordenados temporales"
  `rm $INSTORD/* &> /dev/null`
  bash loguearT.sh "$COMANDO" "I" "Se leyeron $QTYREGOK registros correctamente"
  bash loguearT.sh "$COMANDO" "I" "Se detectaron $QTYREGRECH registros que han sido rechazados"
  bash loguearT.sh "$COMANDO" "I" "Se rechazaron $QTYARCHRECH archivos"
  

	
  
