##########################################
# Manual de Instalación de TP - Grupo 13 #
##########################################

1. Instalación.
  a. Crear en el directorio corriente un subdirectorio "grupo13". El mismo será el directoio de trabajo.
  b. Copiar el archivo *.tgz de distribución en ese directorio.
  c. Ejecutar el script "desempaquetar.sh".

2. Este último paso generará el directorio "instalador", necesario para la ejecución de la instalación de TP. Luego se deberá dar inicio al script "instalarT", que dejará el TP listo para su uso. Durante su ejecución, se grabará un log, en el directorio informado por pantalla. Cuando este script interactúa con el usuario, el valor por omisión propuesto (o valor default) se muestra en pantalla.

3. Debido al uso del script "desempaquetar.sh" para descomprimir todos los archivos necesarios para el funcionamiento del programa, se hace uso de los comandos "gunzip" y "tar", los mismos deben encontrarse disponibles para obtener la carpeta de instalación.

4. Finalizada la instalación, se creará en el directorio "grupo13" la estructura elegida por el usuario en "instalarT".

5. El comando "instalarT" realizará una sucesión de pasos, los cuales incluyen:
  a. El comando graba un archivo de log.
  b. Detecta si el paquete o alguno de sus componentes ya está instalado.
  c. Si todo el paquete ya está instalado termina el proceso.
  d. Si falta instalar algún componente, se encarga de guiar al usuario para completar la instalación.
  e. Chequea que Perl esté instalado.
  f. Brinda la información de la Instalación.
  g. Define todos los directorios y valores necesarios para la correcta ejecución del programa.
  f. Verifica espacio en disco.
  g. Muestra la estructura de directorios resultante y valores de parámetros configurados.
  h. Instala todas las estructuras definidas.
  i. Borrar archivos temporarios, si se hubiesen generado.
  h. Finaliza la instalación.

6. Una vez completo el proceso de instalación el primer comando a ejecutar para corree el programa es "IniciarT"

