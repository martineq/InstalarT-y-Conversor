#!/bin/bash
#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	instalarT.sh		#
#	Estado: <<INCOMPLETO>>		#
#					#
#########################################

# NOTAS:
# + En el achivo instalarT.conf las primeras 10 líneas SIEMPRE son:
#   1-GRUPO 2-ARRIDIR 3-RECHDIR 4-BINDIR 5-MAEDIR 6-REPODIR 7-LOGDIR 8-LOGEXT 9-LOGSIZE 10-DATASIZE
# + Por ahora no se verifica la ruta de directorios dada por el usuario

#######################
## Variables creadas ##
#######################
PATHACTUAL=$(pwd)			# ../grupo13/bin
GRUPO=${PATHACTUAL%/*}			# Le saco el "/bin"
CONFDIR="$GRUPO/confdir"		# Le agergo el "/confdir"
ARCHCONF="$CONFDIR/instalarT.conf"	# Le agergo el "/instalarT.conf"
LOGINST="$CONFDIR/instalarT.log"	# Le agergo el "/instalarT.log"
PAQINST="$CONFDIR/PaqInst.dat"		# Le agergo el "/PaqInst.dat"

######################
## Funciones usadas ##
######################

# Usará el loguearT. Mientras, hago un "echo" de "$1"
function log	
{
	echo "[LOG]: $1"
}

# Verifica si $1 es un archivo existente con permisos +rw para el usuario y sino lo crea
function chequeoArchivo	
{
if [ -f $1 ]; then
   #echo "El archivo $1 existe."
   chmod a+rw $1	# Le doy permiso a todos de hacer cualquier cosa con el archivo
else
   #echo "El archivo $1 No existe."
   touch $1		# Como el archivo no existe, lo creo (vacío)
   chmod a+rw $1	# Le doy permiso a todos de hacer cualquier cosa con el archivo
   #echo "Archivo $1 creado."
fi
}


# Ejecuta los pasos del punto (2) y llama a los del (3): A partir del archivo "$1" chequea que paquetes se instalaron
# Ejecuta los comandos de instalar
function cargarEstado   # Acá empezaría a leer el archivo y según lo que encontró se deriva a 2.1; 2.2; 2.3; 2.4 o 2.5
{
  chequeoArchivo $1
  ESTADO=$(cat $1)

  if [ "$ESTADO" == "" ]; then	# Si la variable está vacia lo tomo como que no se hizo nada
    ESTADO="P00"
  fi

  CODSALIDA=$(echo $ESTADO | sed 's/^P[0-1][0-9]$/OK/g')  # Valida que sea de "P00" hasta "P19"
  CODSALIDA=$(echo $CODSALIDA | sed 's/ /X/g')  # Cambio los espacios por X

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
    log "Componentes Existentes:"

    if [ "$1" -ge "1" ]; then
      log "Instalado P01"
    fi
    if [ "$1" -eq "1" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "2" ]; then
      log "Instalado P02"
    else
      log "Falta P02"
    fi
    if [ "$1" -eq "2" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "3" ]; then
      log "Instalado P03"
    else
      log "Falta P03"
    fi
    if [ "$1" -eq "3" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "4" ]; then
      log "Instalado P04"
    else
      log "Falta P04"
    fi
    if [ "$1" -eq "4" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "5" ]; then
      log "Instalado P05"
    else
      log "Falta P05"
    fi
    if [ "$1" -eq "5" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "6" ]; then
      log "Instalado P06"
    else
      log "Falta P06"
    fi
    if [ "$1" -eq "6" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "7" ]; then
      log "Instalado P07"
    else
      log "Falta P07"
    fi
    if [ "$1" -eq "7" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "8" ]; then
      log "Instalado P08"
    else
      log "Falta P08"
    fi
    if [ "$1" -eq "8" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "9" ]; then
      log "Instalado P09"
    else
      log "Falta P09"
    fi
    if [ "$1" -eq "9" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "10" ]; then
      log "Instalado P10"
    else
      log "Falta P10"
    fi
    if [ "$1" -eq "10" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "11" ]; then
      log "Instalado P11"
    else
      log "Falta P11"
    fi
    if [ "$1" -eq "11" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "12" ]; then
      log "Instalado P12"
    else
      log "Falta P12"
    fi
    if [ "$1" -eq "12" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "13" ]; then
      log "Instalado P13"
    else
      log "Falta P13"
    fi
    if [ "$1" -eq "13" ]; then
      log "Componentes faltantes:"  # Como ya reportó lo instalado y este era el último, Reporto los faltantes
    fi
    if [ "$1" -ge "14" ]; then
      log "Instalado P14"
    else
      log "Falta P14"
    fi

    if [ "$1" -ge "15" ] ; then # "15" sería el estado de instalación al 100%. Como está implementado, tambien se aceptan: 16,17,18,19
      log "Instalado P15"
      log "Estado de la instalacion: COMPLETA"
      log "Proceso de Instalación Cancelado"
      instalarFin
    else
      log "Falta P15" #COMPLETAR
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
  mostrarDirectorios  
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
    instalarFin		# Este caso no se va a dar a menos que el archivo sea corrompido. en ese caso lo llevo al fin de la instalación
    ;;
  esac 

}

#3. Ejecuta los pasos del punto (3): chequeo de perl
function instalar01
{
  echo instalar01

  chequeoPerl
  :>$PAQINST
  echo "P01" > $PAQINST
  instalar02
}

#4. Brindar la información de la Instalación
function instalar02
{
  echo instalar02

#COMPLETAR
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

  :>$PAQINST
  echo "P02" > $PAQINST
  instalar03
}

#5. Definir el directorio de arribo de archivos externos
function instalar03
{
  echo instalar03

  log "Defina el directorio (PESOSgrupo/arribos):"

# Proponer /arribos y si el usuario lo desea cambiar, permitírselo.
# El usuario puede ingresar un nombre simple como “/arribos” o un subdirectorio como /archivos/externos/arribos
# Reservar este path en la variable ARRIDIR

  :>$PAQINST
  echo "P03" > $PAQINST
  instalar04
}
#6. Definir el espacio mínimo libre para el arribo de archivos externos
function instalar04
{
  echo instalar04

  log "Defina el espacio mínimo libre para el arribo de archivos externos en Mbytes (100):"

# Proponer 100 Mb, Si el usuario lo desea cambiar, debe ingresar una cantidad que se interpreta como Mb. Reservar este valor en la variable DATASIZE.

  :>$PAQINST
  echo "P04" > $PAQINST
  instalar05
}
#7. Verificar espacio en disco
function instalar05
{
  echo instalar05

#  Chequear si en ARRIDIR hay disponibles por lo menos DATASIZE Mb. Si esto da error mostrar y grabar en el log el siguiente mensaje:
# SI HAY ERROR DE ESPACIO:
  log "Insuficiente espacio en disco."
  log "Espacio disponible: xx Mb."
  log "Espacio requerido DATASIZE Mb"
  log "Cancele la instalación e inténtelo mas tarde o vuelva a intentarlo con otro valor."
# Volver al punto anterior.

  :>$PAQINST
  echo "P05" > $PAQINST
  instalar06
}
#8. Definir el directorio de grabación de los archivos rechazados
function instalar06
{
  echo instalar06

  log "Defina el directorio de grabación de los archivos externos rechazados (PESOSgrupo/rechazados):"
#Proponer /rechazados y si el usuario lo desea cambiar, permitírselo. El usuario puede ingresar un nombre simple como “/rechazados” o un subdirectorio como /archivos/externos/rechazados Reservar este path en la variable RECHDIR

  :>$PAQINST
  echo "P06" > $PAQINST
  instalar07
}
#9. Definir el directorio de instalación de los ejecutables
function instalar07
{
  echo instalar07

  log "Defina el directorio de instalación de los ejecutables (PESOSgrupo/bin):"
# Proponer /bin y si el usuario lo desea cambiar, permitírselo. El usuario puede ingresar un nombre simple como “bin” o un subdirectorio como /tp/sistemas/bin Reservar este path en la variable BINDIR

  :>$PAQINST
  echo "P07" > $PAQINST
  instalar08
}

#10. Definir el directorio de instalación de los archivos maestros
function instalar08
{
  echo instalar08

  log "Defina el directorio de instalación de los archivos maestros (PESOSgrupo/mae):"
# Proponer /mae y si el usuario lo desea cambiar, permitírselo. El usuario puede ingresar un nombre simple como “mae” o un subdirectorio como /data/mae Reservar este path en la variable MAEDIR

  :>$PAQINST
  echo "P08" > $PAQINST
  instalar09
}

#11. Definir el directorio de grabación de los logs de auditoria
function instalar09
{
  echo instalar09

  log "Defina el directorio de grabación de los logs de auditoria (PESOSgrupo/log):"
# Proponer /log y si el usuario lo desea cambiar, permitírselo. El usuario puede ingresar un nombre simple como “log” o un subdirectorio: /data/log Reservar este path en la variable LOGDIR.

  :>$PAQINST
  echo "P09" > $PAQINST
  instalar10
}

#12. Definir la extensión y tamaño máximo para los archivos de log
function instalar10
{
  echo instalar10

  log "Defina la extensión para los archivos de log (.log):"
# Proponer .log, y si el usuario lo desea cambiar, permitírselo. Reservar este valor en la variable LOGEXT.

  log "Defina el tamaño máximo para los archivos $LOGEXT en Kbytes (400):"
# Proponer 400 KB, Si el usuario lo desea cambiar, debe ingresar una cantidad que se interpreta como Kb. Reservar este valor en la variable LOGSIZE.

  :>$PAQINST
  echo "P10" > $PAQINST
  instalar11
}

#13. Definir el directorio de grabación de los reportes de salida
function instalar11
{
  echo instalar11

  log "Defina el directorio de grabación de los reportes de salida (PESOSgrupo/reportes):"
# Proponer /reportes y si el usuario lo desea cambiar, permitírselo. El usuario puede ingresar un nombre simple como “reportes” o un subdirectorio como archivos/salida/reportes Reservar este path en la variable REPODIR.

  :>$PAQINST
  echo "P11" > $PAQINST
  instalar12
}

#14. Mostrar estructura de directorios resultante y valores de parámetros configurados
function instalar12
{
  echo instalar12

  clear
  log "TP SO7508 1er cuatrimestre 2012. Tema T Copyright © Grupo 13"
  log "Directorio de Trabajo: GRUPO"
  log "Librería del Sistema: CONFDIR"
  log "Directorio de arribo de archivos externos: ARRIDIR"
  log "Espacio mínimo libre para el arribo de archivos externos: DATASIZE Mb"
  log "Directorio de grabación de los archivos externos rechazados: RECHDIR"
  log "Directorio de instalación de los ejecutables: BINDIR"
  log "Directorio de instalación de los archivos maestros: MAEDIR"
  log "Directorio de grabación de los logs de auditoria: LOGDIR"
  log "Extensión para los archivos de log: LOGEXT"
  log "Tamaño máximo para los archivos de log: LOGSIZE Kb"
  log "Directorio de grabación de los reportes de salida: REPODIR"
  log "Estado de la instalacion: LISTA"
  log "Los datos ingresados son correctos? (Si-No)"

# Si el usuario indica Si, Continuar en el paso: “Confirmar Inicio de Instalación”
# 14.4. Si el usuario indica No
# 14.4.1. Limpiar la pantalla
# 14.4.2. Continuar en el paso: “Definir el directorio de arribo de archivos externos”
# En este caso, los valores default propuestos deben ser los contenidos en las variables:
# BINDIR, ARRIDIR, DATASIZE, LOGDIR, LOGEXT, LOGSIZE, etc

  :>$PAQINST
  echo "P12" > $PAQINST
  instalar13
}

#15. Confirmar Inicio de Instalación
function instalar13
{
  echo instalar13
  confirmarInstalación
  CONFIRMA=$?
# Si el usuario indica Si=0, Continuar en el paso siguiente (16. Instalación). Si el usuario indica No=1, ir a FIN

  :>$PAQINST
  echo "P13" > $PAQINST
  instalar14
}

#16. Instalación
function instalar14
{
  echo instalar14

  log "Creando Estructuras de directorio..."
# Las creo y desoues las muestro en pantalla con mostrarDirectorios
  mostrarDirectorios

# Mover los archivos maestros al directorio MAEDIR mostrando el siguiente mensaje
  log "Instalando Archivos Maestros"
# Mover los ejecutables y funciones al directorio BINDIR mostrando el siguiente mensaje
  log "Instalando Programas y Funciones"
# Actualizar el archivo de configuración mostrando el siguiente mensaje
  log "Actualizando la configuración del sistema"

# Se debe almacenar la información de configuración del sistema en el archivo InstalarT.conf en CONFDIR
# Si el archivo de configuración no existe, crearlo, si existe actualizar los valores que correspondan.
# Se debe grabar un registro para cada una de las siguientes variables:
# GRUPO, ARRIDIR, RECHDIR, BINDIR, MAEDIR, REPODIR, LOGDIR LOGEXT, LOGSIZE, DATASIZE.
# Se debe grabar 10 líneas en blanco (de la 11 a la 20) son líneas reservadas para futuras actualizaciones del paquete. Solo pueden ser usadas por un programa instalador o de actualización Líneas 21 y siguientes son de libre disponibilidad.

  :>$PAQINST
  echo "P14" > $PAQINST
  instalar15
}

#17. Borrar archivos temporarios, si se hubiesen generado
function instalar15
{
  echo instalar15

#17. Borrar archivos temporarios, si se hubiesen generado

  :>$PAQINST
  echo "P15" > $PAQINST
  instalarFin
}

#18. Mostrar mensaje de fin de instalación
function instalarFin
{
  log "Instalación concluida."
#Cerrar el archivo InstalarT.log
  exit 0 #Terminar el proceso
}


# Define el directorio que se quiere usar en el archivo de config. Se elige la variable a través de $1. Supongo una entrada de directorio válida
function definirDirectorio 
{
  log "Defina el nombre de Sub-directorio de arribo de archivos externos. (Para definir el Sub-directorio por defecto <$1> presione enter):"
  read VAL
  VAL=$(echo $VAL | sed 's/ /_/g')  # Cambio los espacios por "_"
  if [ ! -z $VAL ] ; then
    crearDirectorio "$GRUPO/$VAL"
    if [ $? -eq 1 ] ; then
      definirDirectorio $1  # Si puso algo inválido y por eso no se creó el directorio, lo hago definir de vuelta  
    fi
    guardarEntrada "$1" "$VAL"
  else
    crearDirectorio "$GRUPO/$1"
    guardarEntrada "$1" "$1"  # Acá el directorio y su valor coinciden (el caso por default)
  fi
}

function guardarEntrada  # $1 es el dir a cambiar y $2 es el valor del dir que se cambiará. Con él se decide que línea se sobreescribe
{

  case $1 in
  arribos)
    LINEA=2
    DIR=ARRIDIR
    ;;
#COMPLETAR con todos los casos
  esac 

  NUEVAENTRADA="$DIR=$GRUPO/$2=$(whoami)=$(date)"
  NUEVAENTRADA=$(echo $NUEVAENTRADA | sed 's/ /_/g')  # Cambio los espacios por "_"

  echo "linea |$LINEA| nuevaentrada |$NUEVAENTRADA|"
  sed -e "${LINEA}s#.*#${NUEVAENTRADA}#" $ARCHCONF > "${ARCHCONF}_tmp"  # El delimitador del sed es el "#" porque en la ruta se usan barras invertidas
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
      log "Directorio <$1> creado."
      return 0
    fi
  else
    log "Directorio <$1> creado."
    return 0
  fi
}

function mostrarDirectorios  # Muestra los directorios con datos
{
echo directorios
#Muestro los DIR con "log"
# $ARRIDIR
# $RECHDIR
# $BINDIR
# $MAEDIR
# $LOGDIR
# $REPODIR
# $grupo/inst_recibidas
# $grupo/inst_ordenadas
# $grupo/inst_rechazadas
# $grupo/inst_procesadas
# $grupo/parque_instalado
}

function listarArchivos # Lista todos los archivos y subdirectorios de un directorio especificado en $1
{
# Sin el log:
# find ./ -maxdepth 1 -printf "%A@ %f\0" | sort -z -n | while read -d '' date line; do echo "$line" | grep -v '\./' ; done

P=$1
D=${P##*/}
find $P -maxdepth 1 -printf "%A@ %f\0" | sort -z -n | while read -d '' date line; do TXT=$(echo "$line" | grep -v "$D") ; if [ ! -z $TXT ] ; then echo "$TXT" ; fi ; done

}

function confirmarInstalación # Pregunta si se inicia la instalación. Si=0 No=1
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
echo PATHACTUAL\: $PATHACTUAL
echo GRUPO\: $GRUPO
echo CONFDIR\: $CONFDIR
echo "LOGINST: $LOGINST"
echo ----------------------------------------------
}


#########################
## Inicio del programa ##
#########################
clear
#mostrarVariables
#log "Comando InstalarT Inicio de Ejecución"
#chequeoArchivo $LOGINST	# Verifico que se encuentre el archivo de log para el instalarT
#cargarEstado $PAQINST	# Ejecuta los pasos del punto (2).
#ESTADO=$?
#instalarEstado $ESTADO

definirDirectorio "arribos"

echo "Chau! =D"
exit 0

######################
## Fin del programa ##
######################

###Cosas por hacer###
# Reservar los nombre de los paths

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
#      echo yes we have perl on  PATH
#else
#      echo dang... no perl
#fi
#########################################################
