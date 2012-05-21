#!/bin/bash

# Grupo: 13
# Name: iniciarT.sh

source global.sh

COMANDO="stopD"

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

DETECTAR_PID=`chequeaProceso detectarT.sh $$`
kill -9 $DETECTAR_PID
bash loguearT.sh "$COMANDO" "I" "Se detuvo correctamente el demonio de detectarD con PID: <$DETECTAR_PID>" 


