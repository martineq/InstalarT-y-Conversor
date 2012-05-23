#!/bin/bash

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	iniciarT.sh		#
#					#
#########################################

##################################################

# 1. Inicializar el archivo de log
# 1.1 Comando IniciarT Inicio de Ejecucion
# 
# 2. Verificar que ya no se haya ejecutado IniciarT en esta misma sesión de usuario
# 2.1. Si IniciarT ya fue ejecutado ir al paso FINAL
# 2.2.  Si IniciarT nunca fue ejecutado en esta sesión de usuario, seguir
# 
# 3. Setear la variable PATH
# 
# 4. Verificar si la instalación está completa
# 4.1.  Si se detecta algún problema en la instalación, explicar la situación y terminar la
#       ejecución.
#       Este control debe incluir la verificación de los archivos indispensables para ejecutar el sistema,
#       como ser los archivos maestros, comandos, etc.
# 4.2.  Si no se detecta ningún problema, seguir
# 
# 5. En IniciarT se pueden setear además todas las variables que consideren necesarias, como
# ser: GRUPO, ARRIDIR, RECHDIR, BINDIR, MAEDIR, REPODIR, LOGDIR LOGEXT,
# LOGSIZE, DATASIZE y cualquier otra variable que se desee emplear en el sistema.
# 
# 6. Luego del seteo de las variables de ambiente y de la verificación de las condiciones
# óptimas para la ejecución (pasos 2, 3 y 4), se debe invocar al script DetectarT siempre que
# detectarT no se esté ejecutando (verificar con ps).
# 
# 8. FINAL:
# IniciarT debe setear las variables de ambiente una sola vez por cada sesión de usuario. Si el
# ambiente ya fue inicializado y se intenta ejecutar nuevamente este comando,
# explicar la situación, mostrar un mensaje de advertencia con el contenido de las
# variables ya seteadas e ir a FIN
##################################################

source global.sh

COMANDO="iniciarT"

printVariables(){
  echo $GRUPO
  echo $ARRIDIR
  echo $RECHDIR
  echo $BINDIR
  echo $MAEDIR
  echo $REPODIR
  echo $LOGDIR
  echo $LOGEXT
  echo $LOGSIZE
  echo $DATASIZE
  
  return 0

}


# Pasos sugeridos
# 1. Inicializar el archivo de log
# 1.1 Comando IniciarT Inicio de Ejecucion
# 
# 2. Verificar que ya no se haya ejecutado IniciarT en esta misma sesión de usuario
# 2.1. Si IniciarT ya fue ejecutado ir al paso FINAL
# 2.2.  Si IniciarT nunca fue ejecutado en esta sesión de usuario, seguir
# 
# 3. Setear la variable PATH
# 
# 4. Verificar si la instalación está completa
# 4.1.  Si se detecta algún problema en la instalación, explicar la situación y terminar la
#       ejecución.
#       Este control debe incluir la verificación de los archivos indispensables para ejecutar el sistema,
#       como ser los archivos maestros, comandos, etc.
# 4.2.  Si no se detecta ningún problema, seguir
# 
# 5. En IniciarT se pueden setear además todas las variables que consideren necesarias, como
# ser: GRUPO, ARRIDIR, RECHDIR, BINDIR, MAEDIR, REPODIR, LOGDIR LOGEXT,
# LOGSIZE, DATASIZE y cualquier otra variable que se desee emplear en el sistema.
# 
# 6. Luego del seteo de las variables de ambiente y de la verificación de las condiciones
# óptimas para la ejecución (pasos 2, 3 y 4), se debe invocar al script DetectarT siempre que
# detectarT no se esté ejecutando (verificar con ps).
# 
# 8. FINAL:
# IniciarT debe setear las variables de ambiente una sola vez por cada sesión de usuario. Si el
# ambiente ya fue inicializado y se intenta ejecutar nuevamente este comando,
# explicar la situación, mostrar un mensaje de advertencia con el contenido de las
# variables ya seteadas e ir a FIN


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
  && [ ! -d "$BINDIR" ]; then
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


agregarVariablePath(){
  #echo $PATH
  NEWPATH=`pwd`
  export PATH=$PATH:$NEWPATH
  #echo $PATH
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



#main()

  # For Debug Use: shows the vars on the current env.
  # printVariables
  
  # Setea la variable Path
  bash loguearT.sh "$COMANDO" "I" "Comienzo de ejecucion de instalarT" 
  
  agregarVariablePath
  bash loguearT.sh "$COMANDO" "I" "NUeva variable de entorno PATH seteada a: $PATH" 

  
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
  
  bash loguearT.sh "$COMANDO" "I" "Validacion del entorno de ejecucion finalizada" 
  
  #Se deja constancia en el log de las variables a emplear
  bash loguearT.sh "$COMANDO" "I" "Listado de conf. a emplear:"
  bash loguearT.sh "$COMANDO" "I" "Path de grupo: $GRUPO"
  bash loguearT.sh "$COMANDO" "I" "Path de arribos: $ARRIDIR"
  bash loguearT.sh "$COMANDO" "I" "Path de rechazos: $RECHDIR"
  bash loguearT.sh "$COMANDO" "I" "Path de programas: $BINDIR"
  bash loguearT.sh "$COMANDO" "I" "Path de archivos maestros: $MAEDIR"
  bash loguearT.sh "$COMANDO" "I" "Path de reportes: $REPODIR"
  bash loguearT.sh "$COMANDO" "I" "Path de logs: $LOGDIR"
  bash loguearT.sh "$COMANDO" "I" "Max. log size: $LOGSIZE"
  bash loguearT.sh "$COMANDO" "I" "Extension de archivos de log: $LOGEXT"
  bash loguearT.sh "$COMANDO" "I" "==============================================="
  bash loguearT.sh "$COMANDO" "I" "Listado de archivos Maestros"
  bash loguearT.sh "$COMANDO" "I" "Archivo maestro de clientes: $CLIENTES"
  bash loguearT.sh "$COMANDO" "I" "Archivo maestro de sucursales: $SUCURSALES"
  bash loguearT.sh "$COMANDO" "I" "Archivo maestro de productos: $PRODUCTOS" 
  bash loguearT.sh "$COMANDO" "I" "==============================================="
  
  #Detecto si detectarT esta corriendo
  DETECTAR_PID=`chequeaProceso detectarT.sh $$`
  if [ -z "$DETECTAR_PID" ]; then
  
    bash detectarT.sh &
    bash loguearT.sh "$COMANDO" "I" "Demonio detectarT corriendo bajo el numero de proceso: <`chequeaProceso detectarT.sh $$`>" 
  else
    bash loguearT.sh "$COMANDO" "E" "Demonio detectarT ya ejecutado bajo PID: <`chequeaProceso detectarT.sh $$`>" 
    echo "Error: Demonio detectarT ya ejecutado bajo PID: <`chequeaProceso detectarT.sh $$`>"
    exit 1
  fi
  
  
  bash loguearT.sh "$COMANDO" "I" "Fin de ejecucion de instalarT" 
  
  exit 0


