#!/bin/bash
#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	instalarT.sh		#
#	Estado: <<INCOMPLETO>>		#
#					#
#########################################

#######################
## Variables creadas ##
#######################
PATHACTUAL=$(pwd)			# ../grupo13/bin
GRUPO=${PATHACTUAL%/*}			# Le saco el "/bin"
CONFDIR="$GRUPO/confdir"		# Le agergo el "/confdir"
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

  CODSALIDA=$(echo $ESTADO | sed 's/^P[0-1][0-9]$/OK/')  # Valida que sea de "P00" hasta "P19"
  CODSALIDA=$(echo $CODSALIDA | sed 's/ /X/')  # Cambio los espacios por X

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
    if [ "$1" -ge "2" ]; then
      log "Instalado P02"
    fi
    if [ "$1" -ge "3" ]; then
      log "Instalado P03"
    fi
    if [ "$1" -ge "4" ]; then
      log "Instalado P04"
    fi
    if [ "$1" -ge "5" ]; then
      log "Instalado P05"
    fi
    if [ "$1" -ge "6" ]; then
      log "Instalado P06"
    fi
    if [ "$1" -ge "7" ]; then
      log "Instalado P07"
    fi
    if [ "$1" -ge "8" ]; then
      log "Instalado P08"
    fi
    if [ "$1" -ge "9" ]; then
      log "Instalado P09"
    fi
    if [ "$1" -ge "10" ]; then
      log "Instalado P10"
    fi
    if [ "$1" -ge "11" ]; then
      log "Instalado P11"
    fi
    if [ "$1" -ge "12" ]; then
      log "Instalado P12"
    fi
    if [ "$1" -ge "13" ]; then
      log "Instalado P13"
    fi
    if [ "$1" -ge "14" ]; then
      log "Instalado P14"
    fi

    if [ "$1" -ge "15" ] ; then # "15" sería el estado de instalación al 100%. Como está implementado, tambien se aceptan: 16,17,18,19
      log "Instalado P15"
      log "Estado de la instalacion: COMPLETA"
      log "Proceso de Instalación Cancelado"
      instalarFin
    else
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
  # Muestro los resultados de los pasos ya instalados...
   if [ "$1" -gt "1" ]; then
      # Acá me parece no tengo resultados
      log "Resultados de P01..."
   fi
   if [ "$1" -gt "2" ]; then
      log "Resultados de P02..."
   fi
   if [ "$1" -gt "3" ]; then
      log "Resultados de P03..."
   fi
   if [ "$1" -gt "4" ]; then
      log "Resultados de P04..."
   fi
   if [ "$1" -gt "5" ]; then
      log "Resultados de P05..."
   fi
   if [ "$1" -gt "6" ]; then
      log "Resultados de P06..."
   fi
   if [ "$1" -gt "7" ]; then
      log "Resultados de P07..."
   fi
   if [ "$1" -gt "8" ]; then
      log "Resultados de P08..."
   fi
   if [ "$1" -gt "9" ]; then
      log "Resultados de P09..."
   fi
   if [ "$1" -gt "10" ]; then
      log "Resultados de P10..."
   fi
   if [ "$1" -gt "11" ]; then
      log "Resultados de P11..."
   fi
   if [ "$1" -gt "12" ]; then
      log "Resultados de P12..."
   fi
   if [ "$1" -gt "13" ]; then
      log "Resultados de P13..."
   fi
   if [ "$1" -gt "14" ]; then
      log "Resultados de P14..."
   fi

  # Instalo los paquetes faltantes, empezando desde "$1"
  #echo "elijo instalar desde $1"  
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
    echo "" > /dev/null
    ;;
  esac 

}

#3 Ejecuta los pasos del punto (3): chequeo de perl
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
  :>$PAQINST
  echo "P02" > $PAQINST
  instalar03
}

#5. Definir el directorio de arribo de archivos externos
function instalar03
{
  echo instalar03
  :>$PAQINST
  echo "P03" > $PAQINST
  instalar04
}
#6. Definir el espacio mínimo libre para el arribo de archivos externos
function instalar04
{
  echo instalar04
  :>$PAQINST
  echo "P04" > $PAQINST
  instalar05
}
#7. Verificar espacio en disco
function instalar05
{
  echo instalar05
  :>$PAQINST
  echo "P05" > $PAQINST
  instalar06
}
#8. Definir el directorio de grabación de los archivos rechazados
function instalar06
{
  echo instalar06
  :>$PAQINST
  echo "P06" > $PAQINST
  instalar07
}
#9. Definir el directorio de instalación de los ejecutables
function instalar07
{
  echo instalar07
  :>$PAQINST
  echo "P07" > $PAQINST
  instalar08
}
#10. Definir el directorio de instalación de los archivos maestros
function instalar08
{
  echo instalar08
  :>$PAQINST
  echo "P08" > $PAQINST
  instalar09
}
#11. Definir el directorio de grabación de los logs de auditoria
function instalar09
{
  echo instalar09
  :>$PAQINST
  echo "P09" > $PAQINST
  instalar10
}
#12. Definir la extensión y tamaño máximo para los archivos de log
function instalar10
{
  echo instalar10
  :>$PAQINST
  echo "P10" > $PAQINST
  instalar11
}
#13. Definir el directorio de grabación de los reportes de salida
function instalar11
{
  echo instalar11
  :>$PAQINST
  echo "P11" > $PAQINST
  instalar12
}
#14. Mostrar estructura de directorios resultante y valores de parámetros configurados
function instalar12
{
  echo instalar12
  :>$PAQINST
  echo "P12" > $PAQINST
  instalar13
}
#15. Confirmar Inicio de Instalación
function instalar13
{
  echo instalar13
  :>$PAQINST
  echo "P13" > $PAQINST
  instalar14
}
#16. Instalación
function instalar14
{
  echo instalar14
  :>$PAQINST
  echo "P14" > $PAQINST
  instalar15
}
#17. Borrar archivos temporarios, si se hubiesen generado
function instalar15
{
  echo instalar15
  :>$PAQINST
  echo "P15" > $PAQINST
  instalarFin
}

#18. Mostrar mensaje de fin de instalación
function instalarFin
{
  log "instalarT Finalizado."
  exit 0
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
  exit 1
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
mostrarVariables
log "Comando InstalarT Inicio de Ejecución"
chequeoArchivo $LOGINST		# Verifico que se encuentre el archivo de log para el instalarT
cargarEstado $PAQINST	# Ejecuta los pasos del punto (2). Si hubo instalación parcial se deriva
ESTADO=$?
instalarEstado $ESTADO

echo "Chau! =D"
exit 0

######################
## Fin del programa ##
######################

###Cosas por hacer###
#1. Este comando debe grabar un archivo de log. El nombre del archivo de log correspondiente a este comando es: instalarT.log en el directorio $CONFDIR
#2. Detectar si el paquete o alguno de sus componentes ya está instalado
#2.1.Si todo el paquete ya está instalado: mostrar y grabar en el log. Ir a FIN.
#2.2.Si falta instalar algún componente, mostrar y grabar en el log los siguientes mensajes: mostrar msj y preguntar Si-No
#2.3.Si el usuario indica "Si"
#2.3.1.Chequear que Perl esté instalado
#2.3.2.Brindar las indicaciones para completar el proceso de Instalación explicando en qué lugar se llevará a cabo...
#2.3.3.Continuar en el paso: “Confirmar Inicio de Instalación”
#2.4. Si el usuario indica No, ir a FIN
#2.5. Si el paquete no fue instalado, continuar en el punto 3
#3. Chequear que Perl esté instalado
#4. Brindar la información de la Instalación
#5. Definir el directorio de arribo de archivos externos
#6. Definir el espacio mínimo libre para el arribo de archivos externos
#7. Verificar espacio en disco
#8. Definir el directorio de grabación de los archivos rechazados
#9. Definir el directorio de instalación de los ejecutables
#10. Definir el directorio de instalación de los archivos maestros
#11. Definir el directorio de grabación de los logs de auditoria
#12. Definir la extensión y tamaño máximo para los archivos de log
#13. Definir el directorio de grabación de los reportes de salida
#14. Mostrar estructura de directorios resultante y valores de parámetros configurados
#15. Confirmar Inicio de Instalación
#16. Instalación
#17. Borrar archivos temporarios, si se hubiesen generado
#18. Mostrar mensaje de fin de instalación
#19. FIN


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
