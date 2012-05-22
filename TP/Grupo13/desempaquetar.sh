#!/bin/bash

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	desempaquetar.sh	#
#					#
#########################################


#################################################
# Pequeño script adicional que descomprime 
# los archivos necesarios para el funcionamiento
# del programa, usa los comandos <gunzip> y <tar>
# No recibe ni entrega parámetros
#################################################

echo "Abriendo archivo comprimido. Creando directorios y archivos..."
gunzip instalador.tar.gz
tar -xvf instalador.tar
echo "Archivo descomprimido."

