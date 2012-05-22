#!/bin/bash

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	desempaquetar.sh	#
#					#
#########################################

echo "Abriendo archivo comprimido. Creando directorios y archivos..."
gunzip instalador.tar.gz
tar -xvf instalador.tar
echo "Archivo descomprimido."
