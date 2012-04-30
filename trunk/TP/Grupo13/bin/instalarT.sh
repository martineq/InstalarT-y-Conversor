#!/bin/bash
#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	instalarT.sh		#
#					#
#########################################

#1. Este comando debe grabar un archivo de log. El nombre del archivo de log correspondiente a este comando es: instalarT.log en el directorio $CONFDIR

echo Comando InstalarT Inicio de Ejecución

#2. Detectar si el paquete o alguno de sus componentes ya está instalado
#2.1.Si todo el paquete ya está instalado: mostrar y grabar en el log. Ir a FIN.
#2.2.Si falta instalar algún componente, mostrar y grabar en el log los siguientes mensajes: mostrar msj y preguntar Si-No
#2.3.Si el usuario indica "Si"
#2.3.1.Chequear que Perl esté instalado -->>> VP=$(perl -V:version)
#2.3.2.Brindar las indicaciones para completar el proceso de Instalación explicando en qué lugar se llevará a cabo...
#2.3.3.Continuar en el paso: “Confirmar Inicio de Instalación”
#2.4. Si el usuario indica No, ir a FIN
#2.5. Si el paquete no fue instalado, continuar en el punto 3
#3. Chequear que Perl esté instalad
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
