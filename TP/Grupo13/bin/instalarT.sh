#!/bin/bash

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	instalarT.sh		#
#	Estado: <<INCOMPLETO>>		#
#	Porcentaje completo: 99%	#
#					#
#########################################

##########################################################################################################################################
# NOTAS:
# + En el achivo instalarT.conf las primeras 10 líneas SIEMPRE son:
#   1-GRUPO 2-ARRIDIR 3-RECHDIR 4-BINDIR 5-MAEDIR 6-REPODIR 7-LOGDIR 8-LOGEXT 9-LOGSIZE 10-DATASIZE
# + La línea que uso para leer el estado de instalación es la N° 21 del arch de configuración
# + Se permite cualquier nombre de SubDirectorio dado por el usuario. Los caracteres no alfanuméricos se borran y los espacios se 
#   cambian por guión bajo "_"
##########################################################################################################################################

#######################
## Variables creadas ##
#######################
PATHACTUAL=$(pwd)			# ../grupo13/instalador
GRUPO=${PATHACTUAL%/*}			# Le saco el "/instalador"
CONFDIR="$GRUPO/confdir"		# Le agergo el "/confdir"
ARCHCONF="$CONFDIR/instalarT.conf"	# Le agergo el "/instalarT.conf"
LOGINST="$CONFDIR/instalarT.log"	# Le agergo el "/instalarT.log"
LINEAESTADOINSTALACION=21		# La línea que uso para leer el estado de instalación es la N° 21 del arch de configuración

######################
## Funciones usadas ##
######################

# Usará el loguearT. Mientras, hago un "echo" de "$1". "$2" es opcional y representa el tipo de mensaje, por defecto será informativo
function log	
{
  if [ -z $2 ] ; then  # ./loguearT.sh "instalar" "I" "Soy una prueba" "/home/mart/ssoo1c-2012/TP/Grupo13/confdir/instalarT.log"
	. loguearT.sh "instalar" "I" "$1" "$LOGINST" &
	echo "$1"
  else
    if [ "$2" == "SE" ] ; then 
        . loguearT.sh "instalar" "SE" "$1" "$LOGINST" &
       	echo "[Error Severo]: $1"
    fi
    if [ "$2" == "E" ] ; then 
        . loguearT.sh "instalar" "E" "$1" "$LOGINST" &
       	echo "[Error]: $1"
    fi
    if [ "$2" == "A" ] ; then 
        . loguearT.sh "instalar" "A" "$1" "$LOGINST" &
       	echo "[Alerta]: $1"
    fi
  fi
}

# Verifica si $1 es un archivo existente con permisos +rw para el usuario y sino lo crea. Devuelve 0 si estaba creado y 1 si no lo estaba
function chequeoArchivo	
{
if [ -f $1 ]; then
   #echo "El archivo $1 existe."
   chmod a+rw $1	# Le doy permiso a todos de hacer cualquier cosa con el archivo
   return 0
else
   #echo "El archivo $1 No existe."
   touch $1		# Como el archivo no existe, lo creo (vacío)
   chmod a+rw $1	# Le doy permiso a todos de hacer cualquier cosa con el archivo
   return 1
   #echo "Archivo $1 creado."
fi
}

# Creo el directorio de configuración, donde se guarda el archivo de configuración y el log de instalación
function crearDirectorioConfig
{
  crearDirectorio "$CONFDIR"
}


# Verifico que se encuentre el archivo de log para el instalarT
function inicioArchivoLog
{
  chequeoArchivo $1
  log "Comando InstalarT Inicio de Ejecución"
}

# Verifico que se encuentre el archivo de configuración
function chequeoArchivoConfig
{
  chequeoArchivo $1
  if [ $? -eq 1 ]; then	# Si la variable es 1, el archivo se creó de cero, entonces escribo unas lineas en blanco para que luego se puedan leer
    for i in {1..21}	# Voy a escribir 21 lineas en blanco
    do
      echo "" >> $1
    done
  fi
  PATHACTUAL=$(pwd)			# ../grupo13/<DirectorioDeInstalación>
  GRUPO=${PATHACTUAL%/*}		# Le saco el "/<DirectorioDeInstalación>"
  guardarEntrada "DIR" "grupo" "$GRUPO"
}

# Carga el estado de la instalación a partir del archivo de configuración pasado en $1
function cargarEstado   
{
  chequeoArchivo $1
  ESTADO=$(sed "${LINEAESTADOINSTALACION}!d" $1)	# El delimitador del sed es el "#". Borra todas las líneas, menos la que necesito
  if [ "$ESTADO" == "" ]; then	# Si la variable está vacia lo tomo como que no se hizo nada
    ESTADO="P00"
  fi

  CODSALIDA=$(echo $ESTADO | sed 's/^P[0-1][0-9]$/OK/g')  # Valida que sea de "P00" hasta "P19"
  CODSALIDA=$(echo $CODSALIDA | sed 's/ /_/g')  # Cambio los espacios por "_"

  if [ ! $CODSALIDA == "OK" ] ; then
    log "Error leyendo el estado de instalación. Se interrumpe el script."
    exit 1
  fi
  ESTADO=${ESTADO#*P}	# Le saco la "P"
  return $ESTADO
}

# COMPLETAR
function instalarEstado
{
  if [ "$1" == "0" ]; then
    instalar01
  else
    log "TP SO7508 1er cuatrimestre 2012. Tema T Copyright © Grupo 13"
    log "Librería del Sistema: $CONFDIR"
    log "Sus archivos y subdirectorios son:"
    listarArchivos $CONFDIR

    if [ "$1" -ge "1" ]; then
      echo "" > /dev/null
    fi
    if [ "$1" -eq "1" ]; then
      echo "" > /dev/null
    fi
    if [ "$1" -ge "2" ]; then
      echo "" > /dev/null
    else
      echo "" > /dev/null
    fi
    if [ "$1" -eq "2" ]; then
      echo "" > /dev/null
    fi
    if [ "$1" -ge "3" ]; then
      log "Componentes Existentes:" # Acá Arrancan los componentes y el primero tiene que estar siempre así que imprimo el msj a partir de acá
      obtenerEntrada "ARRIDIR"
      log "Directorio de arribo de archivos externos: $ARRIDIR"
    else
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
      log "Directorio de arribo de archivos externos: No Definido"
    fi
    if [ "$1" -eq "3" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "4" ]; then
      echo "" > /dev/null
    else
      echo "" > /dev/null
    fi
    if [ "$1" -eq "4" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "5" ]; then
      echo "" > /dev/null
    else
      echo "" > /dev/null
    fi
    if [ "$1" -eq "5" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "6" ]; then
      obtenerEntrada "RECHDIR"
      log "Directorio de grabación de los archivos externos rechazados: $RECHDIR"
    else
      log "Directorio de grabación de los archivos externos rechazados: No Definido"
    fi
    if [ "$1" -eq "6" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "7" ]; then
      obtenerEntrada "BINDIR"
      log "Directorio de instalación de los ejecutables: $BINDIR"
      listarArchivos $BINDIR
    else
      log "Directorio de instalación de los ejecutables: No Definido"
    fi
    if [ "$1" -eq "7" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "8" ]; then
      obtenerEntrada "MAEDIR"
      log "Directorio de instalación de los archivos maestros: $MAEDIR"
      listarArchivos $MAEDIR
    else
      log "Directorio de instalación de los archivos maestros: No Definido"
    fi
    if [ "$1" -eq "8" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "9" ]; then
      obtenerEntrada "LOGDIR"
      log "Directorio de grabación de los logs de auditoria: $LOGDIR"
    else
      log "Directorio de grabación de los logs de auditoria: No Definido"
    fi
    if [ "$1" -eq "9" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "10" ]; then
      echo "" > /dev/null
    else
      echo "" > /dev/null
    fi
    if [ "$1" -eq "10" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "11" ]; then
      obtenerEntrada "REPODIR"
      log "Directorio de grabación de los reportes de salida: $REPODIR"
    else
      log "Directorio de grabación de los reportes de salida: No Definido"
    fi
    if [ "$1" -eq "11" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "12" ]; then
      echo "" > /dev/null
    else
      echo "" > /dev/null
    fi
    if [ "$1" -eq "12" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "13" ]; then
      echo "" > /dev/null
    else
      echo "" > /dev/null
    fi
    if [ "$1" -eq "13" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "14" ]; then
      log "Estructuras de directorio y archivos: Creados"
    else
      log "Estructuras de directorio y archivos: No Creados"
    fi
    if [ "$1" -eq "14" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi

    if [ "$1" -ge "15" ] ; then # "15" sería el estado de instalación al 100%. Como está implementado, tambien se aceptan: 16,17,18,19
      log "Estado de la instalacion: COMPLETA"
      log "Proceso de Instalación Cancelado"
      instalarFin
    else
      log "Archivos temporarios no borrados"
      log "Estado de la instalacion: INCOMPLETA"
      log "¿Desea completar la instalacion? (Si-No)"
      OPC=$(($1+1))	# Le sumo 1 a "$1" para instalar el paquete siguiente al que ya está instalado
      select SN in "Si" "No"; do
          case $SN in
              Si ) elegirInstalar $OPC; break;;
              No ) instalarFin; break;;
          esac
      done
    fi

  fi
}

# Chequeo perl y me meto en un case donde muestra lo que se hizo antes y despues arranco con lo que se va a hacer
function elegirInstalar
{
  chequeoPerl  
  confirmarInstalación
  CONFIRMA=$?  # Si=0, No=1
  if [ "$CONFIRMA" == "1" ]; then
    instalarFin    
  fi  

  # Instalo los paquetes faltantes, empezando desde "$1"
  case $1 in
  2)
    instalar02
    ;;
  3)
    instalar03
    ;;
  4)
    instalar04
    ;;
  5)
    instalar05
    ;;
  6)
    instalar06
    ;;
  7)
    instalar07
    ;;
  8)
    instalar08
    ;;
  9)
    instalar09
    ;;
  10)
    instalar10
    ;;
  11)
    instalar11
    ;;
  12)
    instalar12
    ;;
  13)
    instalar13
    ;;
  14)
    instalar14
    ;;
  15)
    instalar15
    ;;
  *)
    instalarFin		# Este caso no se va a dar a menos que el archivo se corrompa. en ese caso lo llevo al fin de la instalación
    ;;
  esac 

}

#3. Ejecuta los pasos del punto (3): chequeo de perl
function instalar01
{
#  echo instalar01
  chequeoPerl

  guardarEstadoInstalacion "P01"
  instalar02
}

#4. Brindar la información de la Instalación
function instalar02
{
#  echo instalar02
  log "Directorio de Trabajo para la instalacion: $GRUPO"
  log "Sus archivos y subdirectorios son:"
  listarArchivos $GRUPO
  log "Librería del Sistema: $CONFDIR"
  log "Sus archivos y subdirectorios son:"
  listarArchivos $CONFDIR
  log "Estado de la instalacion: PENDIENTE"
  log "Para completar la instalación Ud. Deberá:"
  log "Definir el directorio de arribo de archivos externos"
  log "Definir el espacio mínimo libre para el arribo de archivos externos"
  log "Definir el directorio de grabación de los archivos externos rechazados"
  log "Definir el directorio de instalación de los ejecutables"
  log "Definir el directorio de instalación de los archivos maestros"
  log "Definir el directorio de grabación de los logs de auditoria"
  log "Definir la extensión y tamaño máximo para los archivos de log"
  log "Definir el directorio de grabación de los reportes de salida"

  guardarEstadoInstalacion "P02"
  instalar03
}

#5. Definir el directorio de arribo de archivos externos
function instalar03
{
#  echo instalar03

  obtenerEntrada "ARRIDIR"
  if [ -z $ARRIDIR ] ; then
    DEFECTO="${GRUPO}/arribos"
  else
    DEFECTO=$ARRIDIR
  fi
  SUBDIRDEFECTO=${DEFECTO##*/}
  TIPO="DIR"
  NOMBRE="arribos"
  MSG="Defina el nombre de Sub-directorio de arribo de archivos externos. (Para definir el Sub-directorio por defecto <$SUBDIRDEFECTO> presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  guardarEstadoInstalacion "P03"
  instalar04
}

#6. Definir el espacio mínimo libre para el arribo de archivos externos
function instalar04
{
#  echo instalar04
  
  obtenerEntrada "DATASIZE"
  if [ -z $DATASIZE ] ; then
    DEFECTO="100"
  else
    DEFECTO=$DATASIZE
  fi
  TIPO="NUM"
  NOMBRE="espacioExternos"
  MSG="Defina el espacio mínimo libre para el arribo de archivos externos en Mbytes. (Para usar $DEFECTO Mb presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  guardarEstadoInstalacion "P04"
  instalar05
}

#7. Verificar espacio en disco
function instalar05
{
#  echo instalar05

  obtenerEntrada "DATASIZE"
  obtenerEntrada "ARRIDIR"
  crearDirectorio "$ARRIDIR"
  if [ $? -eq 1 ] ; then
    log "El directorio <${ARRIDIR}> no pudo ser creado" "SE"
    exit 1
  else
    log "Directorio <${ARRIDIR}> creado"
  fi



  DISPONIBLE=$(df "$ARRIDIR" --block-size=1M | sed '2!d' | awk '{ print $4 }')
  if [ $DISPONIBLE -lt $DATASIZE ] ; then
    log "Insuficiente espacio en disco." "SE"
    log "Espacio disponible: $DISPONIBLE Mb"
    log "Espacio requerido $DATASIZE Mb"
    log "Cancele la instalación e inténtelo mas tarde o vuelva a intentarlo con otro valor."
    instalar04
  else
    log "El directorio <${ARRIDIR}> tiene el espacio mínimo requerido"
  fi

  guardarEstadoInstalacion "P05"
  instalar06
}
#8. Definir el directorio de grabación de los archivos rechazados
function instalar06
{
#  echo instalar06

  obtenerEntrada "RECHDIR"
  if [ -z $RECHDIR ] ; then
    DEFECTO="${GRUPO}/rechazados"
  else
    DEFECTO=$RECHDIR
  fi
  SUBDIRDEFECTO=${DEFECTO##*/}
  TIPO="DIR"
  NOMBRE="rechazados"
  MSG="Defina el nombre de Sub-directorio de grabación de los archivos externos rechazados. (Para definir el Sub-directorio por defecto <$SUBDIRDEFECTO> presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  guardarEstadoInstalacion "P06"
  instalar07
}
#9. Definir el directorio de instalación de los ejecutables
function instalar07
{
#  echo instalar07

  obtenerEntrada "BINDIR"
  if [ -z $BINDIR ] ; then
    DEFECTO="${GRUPO}/bin"
  else
    DEFECTO=$BINDIR
  fi
  SUBDIRDEFECTO=${DEFECTO##*/}
  TIPO="DIR"
  NOMBRE="bin"
  MSG="Defina el nombre de Sub-directorio de grabación de instalación de los ejecutables. (Para definir el Sub-directorio por defecto <$SUBDIRDEFECTO> presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  guardarEstadoInstalacion "P07"
  instalar08
}

#10. Definir el directorio de instalación de los archivos maestros
function instalar08
{
#  echo instalar08

  obtenerEntrada "MAEDIR"
  if [ -z $MAEDIR ] ; then
    DEFECTO="${GRUPO}/mae"
  else
    DEFECTO=$MAEDIR
  fi
  SUBDIRDEFECTO=${DEFECTO##*/}
  TIPO="DIR"
  NOMBRE="archivosMaestros"
  MSG="Defina el nombre de Sub-directorio de grabación de instalación de los archivos maestros. (Para definir el Sub-directorio por defecto <$SUBDIRDEFECTO> presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  guardarEstadoInstalacion "P08"
  instalar09
}

#11. Definir el directorio de grabación de los logs de auditoria
function instalar09
{
#  echo instalar09

  obtenerEntrada "LOGDIR"
  if [ -z $LOGDIR ] ; then
    DEFECTO="${GRUPO}/log"
  else
    DEFECTO=$LOGDIR
  fi
  SUBDIRDEFECTO=${DEFECTO##*/}
  TIPO="DIR"
  NOMBRE="log"
  MSG="Defina el nombre de Sub-directorio de grabación de instalación de los logs de auditoria. (Para definir el Sub-directorio por defecto <$SUBDIRDEFECTO> presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  guardarEstadoInstalacion "P09"
  instalar10
}

#12. Definir la extensión y tamaño máximo para los archivos de log
function instalar10
{
#  echo instalar10

  obtenerEntrada "LOGEXT"
  if [ -z $LOGEXT ] ; then
    DEFECTO="log"
  else
    DEFECTO=$LOGEXT
  fi
  TIPO="EXT"
  NOMBRE="extensionLog"
  MSG="Defina la extensión para los archivos de log (Para usar <$DEFECTO> presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  obtenerEntrada "LOGSIZE"
  if [ -z $LOGSIZE ] ; then
    DEFECTO="400"
  else
    DEFECTO=$LOGSIZE
  fi
  obtenerEntrada "LOGEXT"
  TIPO="NUM"
  NOMBRE="tamanioLog"
  MSG="Defina el tamaño máximo para los archivos <$LOGEXT> en Kbytes. (Para usar $DEFECTO Kb presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  guardarEstadoInstalacion "P10"
  instalar11
}

#13. Definir el directorio de grabación de los reportes de salida
function instalar11
{
#  echo instalar11

  obtenerEntrada "REPODIR"
  if [ -z $REPODIR ] ; then
    DEFECTO="${GRUPO}/reportes"
  else
    DEFECTO=$REPODIR
  fi
  SUBDIRDEFECTO=${DEFECTO##*/}
  TIPO="DIR"
  NOMBRE="reportes"
  MSG="Defina el nombre de Sub-directorio de grabación de instalación de los reportes de salida. (Para definir el Sub-directorio por defecto <$SUBDIRDEFECTO> presione enter):"
  definirValor "$TIPO" "$NOMBRE" "$MSG" "$DEFECTO"

  guardarEstadoInstalacion "P11"
  instalar12
}

#14. Mostrar estructura de directorios resultante y valores de parámetros configurados
function instalar12
{
#  echo instalar12

  clear
  log "TP SO7508 1er cuatrimestre 2012. Tema T Copyright © Grupo 13"
  obtenerEntrada "GRUPO"
  log "Directorio de Trabajo: $GRUPO"
  obtenerEntrada "CONFDIR"
  log "Librería del Sistema: $CONFDIR"
  obtenerEntrada "ARRIDIR"
  log "Directorio de arribo de archivos externos: $ARRIDIR"
  obtenerEntrada "DATASIZE"
  log "Espacio mínimo libre para el arribo de archivos externos: $DATASIZE Mb"
  obtenerEntrada "RECHDIR"
  log "Directorio de grabación de los archivos externos rechazados: $RECHDIR"
  obtenerEntrada "BINDIR"
  log "Directorio de instalación de los ejecutables: $BINDIR"
  obtenerEntrada "MAEDIR"
  log "Directorio de instalación de los archivos maestros: $MAEDIR"
  obtenerEntrada "LOGDIR"
  log "Directorio de grabación de los logs de auditoria: $LOGDIR"
  obtenerEntrada "LOGEXT"
  log "Extensión para los archivos de log: $LOGEXT"
  obtenerEntrada "LOGSIZE"
  log "Tamaño máximo para los archivos de log: $LOGSIZE Kb"
  obtenerEntrada "REPODIR"
  log "Directorio de grabación de los reportes de salida: $REPODIR"
  log "Estado de la instalacion: LISTA"
  log "Los datos ingresados son correctos? (Si-No)"
  select SN in "Si" "No"; do
      case $SN in
          Si ) guardarEstadoInstalacion "P12" ; instalar13 ; break;;
          No ) clear ; guardarEstadoInstalacion "P02" ; instalar03 ; break;;
      esac
  done
}

#15. Confirmar Inicio de Instalación
function instalar13
{
#  echo instalar13
  confirmarInstalación
  CONFIRMA=$?
  if [ $CONFIRMA -eq 0 ] ; then
    guardarEstadoInstalacion "P13"
    instalar14 
  else
    instalarFin
  fi

}

#16. Instalación
function instalar14
{
#  echo instalar14

  log "Creando Estructuras de directorio..."
  log "$ARRIDIR"

  obtenerEntrada "RECHDIR"
  crearDirectorio "$RECHDIR"
  if [ $? -eq 1 ] ; then
    log "El directorio <$RECHDIR> no pudo ser creado" "SE"
    exit 1
  else
    log "$RECHDIR"
  fi

  obtenerEntrada "BINDIR"
  crearDirectorio "$BINDIR"
  if [ $? -eq 1 ] ; then
    log "El directorio <$BINDIR> no pudo ser creado" "SE"
    exit 1
  else
    log "$BINDIR"
  fi

  obtenerEntrada "MAEDIR"
  crearDirectorio "$MAEDIR"
  if [ $? -eq 1 ] ; then
    log "El directorio <$MAEDIR> no pudo ser creado" "SE"
    exit 1
  else
    log "$MAEDIR"
  fi

  obtenerEntrada "LOGDIR"
  crearDirectorio "$LOGDIR"
  if [ $? -eq 1 ] ; then
    log "El directorio <$LOGDIR> no pudo ser creado" "SE"
    exit 1
  else
    log "$LOGDIR"
  fi

  obtenerEntrada "REPODIR"
  crearDirectorio "$REPODIR"
  if [ $? -eq 1 ] ; then
    log "El directorio <$REPODIR> no pudo ser creado" "SE"
    exit 1
  else
    log "$REPODIR"
  fi

  obtenerEntrada "GRUPO"
  crearDirectorio "${GRUPO}/inst_recibidas"
  if [ $? -eq 1 ] ; then
    log "El directorio <${GRUPO}/inst_recibidas> no pudo ser creado" "SE"
    exit 1
  else
    log "${GRUPO}/inst_recibidas"
  fi

  crearDirectorio "${GRUPO}/inst_ordenadas"
  if [ $? -eq 1 ] ; then
    log "El directorio <${GRUPO}/inst_ordenadas> no pudo ser creado" "SE"
    exit 1
  else
    log "${GRUPO}/inst_ordenadas"
  fi

  crearDirectorio "${GRUPO}/inst_rechazadas"
  if [ $? -eq 1 ] ; then
    log "El directorio <${GRUPO}/inst_rechazadas> no pudo ser creado" "SE"
    exit 1
  else
    log "${GRUPO}/inst_rechazadas"
  fi

  crearDirectorio "${GRUPO}/inst_procesadas"
  if [ $? -eq 1 ] ; then
    log "El directorio <${GRUPO}/inst_procesadas> no pudo ser creado" "SE"
    exit 1
  else
    log "${GRUPO}/inst_procesadas"
  fi

  crearDirectorio "${GRUPO}/parque_instalado"
  if [ $? -eq 1 ] ; then
    log "El directorio <${GRUPO}/parque_instalado> no pudo ser creado" "SE"
  else
    log "${GRUPO}/parque_instalado"
  fi

  chmod -R 777 $PATHACTUAL  # Versión octal de chmod

# Mover los archivos maestros al directorio MAEDIR mostrando el siguiente mensaje
  log "Instalando Archivos Maestros..."
  cantidadArchivos=`ls -1 *.mae 2>/dev/null | wc -l`
  if [ $cantidadArchivos != 0 ]; then 
    cp ${PATHACTUAL}/*.mae "$MAEDIR"
  fi 

# Mover los ejecutables y funciones al directorio BINDIR mostrando el siguiente mensaje
  log "Instalando Programas y Funciones..."
  cantidadArchivos=`ls -1 *.sh 2>/dev/null | wc -l`
  if [ $cantidadArchivos != 0 ]; then 
    cp ${PATHACTUAL}/*.sh $BINDIR
  fi

  cantidadArchivos=`ls -1 *.pl 2>/dev/null | wc -l`
  if [ $cantidadArchivos != 0 ]; then 
    cp ${PATHACTUAL}/*.pl $BINDIR
  fi

# Actualizar el archivo de configuración mostrando el siguiente mensaje
  log "Actualizando la configuración del sistema..."
  guardarEstadoInstalacion "P14"
  instalar15
}

#17. Borrar archivos temporarios, si se hubiesen generado
function instalar15
{
#  echo instalar15
  #COMPLETAR ¿Se crearon archivos temporarios? --> Borrarlos
  #Borrar TODo lo que haya en al carpeta "instaladora"
  guardarEstadoInstalacion "P15"
  instalarFin
}

#18. Mostrar mensaje de fin de instalación
function instalarFin
{
  log "Instalación concluida."
  # Cerrar el archivo InstalarT.log
  exit 0 #Terminar el proceso
}

# Define el valor que se quiere usar en el archivo de config. Se elige el 'tipo' de VAR a través de $1 y el 'nombre' de la variable través de $2
# Valores posibles de $1: "DIR" , "NUM" o "EXT"
# Muestra el mensaje y loguea enviado en $3
# El valor por defecto es pasado en $4
function definirValor
{
  log "$3"
  read VAL
  VAL=$(echo $VAL | sed 's/ /_/g' | sed -e 's/[^0-9A-Za-z_]//g')  # Cambio los caracteres no alfanumericos espacios por "_"

  case $1 in
    DIR)
    if [ ! -z $VAL ] ; then
      if [ "$2" == "grupo" ]; then  # Hago la excepción porque "grupo" tiene la ruta completa
        guardarEntrada "$1" "$2" "$VAL"
      else
        guardarEntrada "$1" "$2" "$GRUPO/$VAL"
      fi
    else
      guardarEntrada "$1" "$2" "$4"  # Acá el directorio y su valor coinciden (el caso por default)
    fi
    ;;

    NUM)
    if [ ! -z $VAL ] ; then
      if [ $VAL -eq $VAL 2> /dev/null ]; then  # Verifica que sea un valor numérico
        guardarEntrada "$1" "$2" "$VAL"
      else
        definirValor "$1" "$2" "$3" "$4"	# Si puso un valor inválido, lo hago definir de vuelta  
      fi
    else
      guardarEntrada "$1" "$2" "$4"  # Caso por default
    fi
    ;;

    EXT)
    if [ ! -z $VAL ] ; then
      guardarEntrada "$1" "$2" "$VAL"
    else
      guardarEntrada "$1" "$2" "$4"  # Caso por default
    fi
    ;;

  esac
}

function guardarEntrada  # $1 es el tipo de valor, $2 es el nombre de la variable a cambiar y $3 es el valor que se cambiará.
{
  case $2 in	# Posibles valores: grupo, arribos, rechazados, bin, archivosMaestros, reportes, log, extensionLog, tamanioLog, espacioExternos
  grupo)
    LINEA=1
    DIR=GRUPO
    ;;
  arribos)
    LINEA=2
    DIR=ARRIDIR
    ;;
  rechazados)
    LINEA=3
    DIR=RECHDIR
    ;;
  bin)
    LINEA=4
    DIR=BINDIR
    ;;
  archivosMaestros)
    LINEA=5
    DIR=MAEDIR
    ;;
  reportes)
    LINEA=6
    DIR=REPODIR
    ;;
  log)
    LINEA=7
    DIR=LOGDIR
    ;;
  extensionLog)
    LINEA=8
    DIR=LOGEXT
    ;;
  tamanioLog)
    LINEA=9
    DIR=LOGSIZE
    ;;
  espacioExternos)
    LINEA=10
    DIR=DATASIZE
    ;;
  esac 

  NUEVAENTRADA="$DIR=$3=$(whoami)=$(date)"
  sed -e "${LINEA}s#.*#${NUEVAENTRADA}#" $ARCHCONF > "${ARCHCONF}_tmp"  # El delimitador del sed es el "#" porque en la ruta se usan barras invertidas
  mv "${ARCHCONF}_tmp" "$ARCHCONF"
  #log "El valor $3 fue guardado"
}

function obtenerEntrada	# Obtengo el valor de la entrada especificada en $1
{
  case $1 in
  GRUPO)
    GRUPO=$(sed "1!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  ARRIDIR)
    ARRIDIR=$(sed "2!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  RECHDIR)
    RECHDIR=$(sed "3!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  BINDIR)
    BINDIR=$(sed "4!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  MAEDIR)
    MAEDIR=$(sed "5!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  REPODIR)
    REPODIR=$(sed "6!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  LOGDIR)
    LOGDIR=$(sed "7!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  LOGEXT)
    LOGEXT=$(sed "8!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  LOGSIZE)
    LOGSIZE=$(sed "9!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  DATASIZE)
    DATASIZE=$(sed "10!d" $ARCHCONF | sed 's/^[^=]*=\([^=]*\)=.*$/\1/')
    ;;
  esac 
}


function guardarEstadoInstalacion	# Guardo el estado de instalación pasado en $1
{
  sed -e "${LINEAESTADOINSTALACION}s#.*#${1}#" $ARCHCONF > "${ARCHCONF}_tmp"  # El delimitador del sed es el "#" 
  mv "${ARCHCONF}_tmp" "$ARCHCONF"
}

function crearDirectorio	# Crea el directorio de la ruta $1
{
  if [ ! -d "$1" ]; then
    mkdir $1
    if [ ! -d "$1" ]; then
      log "Error al crear el directorio <$1>"
      return 1
    else
#      log "Directorio <$1> creado."
      chmod -R 777 $1
      return 0
    fi
  else
#    log "Directorio <$1> creado."
    chmod -R 777 $1
    return 0
  fi
}


function listarArchivos # Lista todos los archivos y subdirectorios de un directorio especificado en $1
{
  # Sin el log:
  # find ./ -maxdepth 1 -printf "%A@ %f\0" | sort -z -n | while read -d '' date line; do echo "$line" | grep -v '\./' ; done

  P=$1		# Ruta donde se hace el find
  D=${P##*/}	# Se saca el nombre del directorio que se usa para buscar, ya que buscamos sub-directorios y archivos
  find $P -maxdepth 1 -printf "%A@ %f\0" | sort -z -n | while read -d '' date line; do TXT=$(echo "$line" | grep -v "$D") ; if [ ! -z $TXT ] ; then log "$TXT" ; fi ; done
}

function confirmarInstalación # Pregunta si se inicia la instalación. Devuelve Si=0 No=1
{
  log "Iniciando Instalacion. Esta Ud, seguro? (Si-No)"
  select SN in "Si" "No"; do
      case $SN in
          Si ) return 0; break;;
          No ) return 1; break;;
      esac
  done
}

# Verifica si se encuentra instalado Perl. Si no está instalado detiene el script.
function chequeoPerl	
{
VERSIONPERL=$(perl -V:version)
CODSALIDA=$?
VERSIONPERL=${VERSIONPERL#*\'}
VERSIONPERL=${VERSIONPERL%\'*}
if [ $CODSALIDA -eq 0 ] ; then
  perl -v | grep [Vv][5-9] > /dev/null # Miro si la línea tiene un "v5" (o mayor) y tomo su código de salida
  CODSALIDA=$?
  if [ $CODSALIDA -eq 0 ] ; then
    perlInstalado
  else
    perlNoInstalado
  fi
else
  perlNoInstalado
fi
}

# Emite en el log mensaje confirmando la versión de perl instalada
function perlInstalado	
{
  log "TP SO7508 1er cuatrimestre 2012. Tema T Copyright © Grupo 13"
  log "Perl versión: $VERSIONPERL"
}

# Emite en el log mensaje de error y cierra el script
function perlNoInstalado	
{
  log "TP SO7508 1er cuatrimestre 2012. Tema T Copyright © Grupo 13"
  log "Para instalar el TP es necesario contar con Perl 5 o superior instalado. Efectúe su instalación e inténtelo nuevamente."
  log ""
  log "Proceso de Instalación Cancelado"
  instalarFin
}

# Muestra algunas variables usadas en el script
function mostrarVariables	
{
echo ----------------------------------------------
echo "Variables usadas:"
echo "PATHACTUAL: $PATHACTUAL"
echo "GRUPO: $GRUPO"
echo "CONFDIR: $CONFDIR"
echo "LOGINST: $LOGINST"
echo ----------------------------------------------
}

#########################
## Inicio del programa ##
#########################
clear
crearDirectorioConfig		# Creo el directorio de configuración, donde se guarda el archivo de configuración y el log de instalación
inicioArchivoLog $LOGINST	# Verifico que se encuentre el archivo de log para el instalarT
chequeoArchivoConfig $ARCHCONF	# Verifico que se encuentre el archivo de configuración
cargarEstado $ARCHCONF		# Cargo el estado a partir del archivo de configuración
ESTADO=$?
#mostrarVariables
instalarEstado $ESTADO		# Instalo a partir del estado que devolvió el CargarEstado en "$?"

#echo "¡Chau! =D"
exit 0

######################
## Fin del programa ##
######################



#########################################################
# <<Machete>>
#########################################################
# Chequeo de directorio:
#
#if [ -d "$DIRECTORY" ]; then
#	echo "File $DIRECTORY exists."
#fi
#########################################################
# Chequeo de archivo:
#
#if [ -f $FILE ]; #then
#   echo "File $FILE exists."
#fi
# Con:
#[ -f archivo ] : Verdadero si existe archivo
#[ -r archivo ] : Verdadero si existe archivo y tiene permiso de lectura para el usuario
#[ -w archivo ] : Verdadero si existe archivo y tiene permiso de escritura para el usuario
#########################################################
# Crear directorio:
#mkdir -p "`dirname $foo`"
#touch "$foo"
#Coment:dirname works on arbitrary paths; it doesn't check whether the path is in use (whether the file pointed to exists).
#########################################################
# Crear un archivo nuevo y darle permisos
#echo > archivo.txt
#########################################################
# Dar todos los permisos de un archivo a todos los usuarios 
#chmod a+rwx archivo.txt
#########################################################
# Chequear si está Perl
#if perl < /dev/null > /dev/null 2>&1  ; then
#      echo hay perl!
#else
#      echo no hay perl )=
#fi
#########################################################
