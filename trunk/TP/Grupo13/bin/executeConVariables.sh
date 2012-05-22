#!/bin/bash

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	executeConVariables.sh	#
#					#
#########################################


export LOGDIR="/home/arielik/workspace/SO_TP/TP/Grupo13/logdir"
export GRUPO="/home/arielik/workspace/SO_TP/TP/Grupo13"
export LOGEXT="log"
export LOGSIZE=5

bash loguearT.sh "$1" "$2" "$3"
