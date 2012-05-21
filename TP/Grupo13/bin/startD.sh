#!/bin/bash

# Grupo: 13
# Name: iniciarT.sh

source global.sh

COMANDO="startD"

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

chequeaVariables(){

  if [ "$LOGEXT" != "" ] && [ "$BINDIR" != "" ] && [ "$DATASIZE" != "" ] \
  && [ "$GRUPO" != "" ] && [ "$ARRIDIR" != "" ] && [ "$RECHDIR" != "" ] \
  && [ "$MAEDIR" != "" ] && [ "$REPODIR" != "" ] && [ "$LOGDIR" != "" ] \
  && [ "$LOGSIZE" != "" ]; then
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
  if [ ! -a "$CLIENTES" ] ; then
    #Error severo - No hay archivo maestros
      echo 1
      return
  fi
  
  if [ ! -a "$SUCURSALES" ] ; then
    #Error severo - No hay archivo maestros
    echo 1
    return
  fi
  
  if [ ! -a "$PRODUCTOS" ] ; then
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


  # Si alguna variable no esta definida error en la instalación
  if [ `chequeaVariables` -eq 1 ] ; then
    #echo "Instalacion no finalizada"
    echo 1
    return
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