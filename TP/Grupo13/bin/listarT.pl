#!/usr/bin/perl 

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	listarT.pl		#
#					#
#########################################

################################################################################
# 1. El propósito de este programa perl es resolver cualquier tipo de consulta efectuada sobre el
# parque instalado y emitir los informes correspondientes cuando se lo requiera.
# 2. Se alimenta de los archivos de parque instalado y de los archivos maestros.
# 3. Debe aceptar al menos los parámetros tipo de producto, ID de sucursal, Id de Cliente y la
# Descripción del Ítem de Producto del Registro Cabecera
# 4. Debe aceptar las opciones –c –e –h la combinación de las dos primeras.
# 4.1. –c resuelve la consulta y muestra resultados no graba en archivo
# 4.2. –e resuelve la consulta y graba un reporte
# 4.3. –h muestra la ayuda del comando
# 5. Si lo desean pueden agregar más parámetros y más opciones
# 6. El nombre del archivo que se graba al emitir el informe debe ser lpi.<SEC> donde SEC es
# un número de secuencia queda al criterio del desarrollador su definición, pero siempre
# debe ser un nombre nuevo, no debe sobrescribir ningún informe previo.
# 7. Los informes se graban en el directorio: REPODIR
# 8. En el encabezado siempre mostrar titulo del reporte y los parámetros de invocación
# 9. En los subtítulos, las etiquetas de los campos
# 10. Mostrar los siguientes campos:
# 10.1. Sucursal, además del Id, mostrar el BRANCH_NAME
# 10.2. Cliente, además del Id, mostrar el CUSTOMER_1ST_NAME
# 10.3. Tipo de producto (PRODUCT_TYPE_NAME)
# 10.4. Plan Comercial, corresponde a la Desc. del Ítem de Prod. del Reg. Cabecera
# 10.5. Item, corresponde a la Descripción del Ítem de Prod. del Reg. de detalle
# 11. La salida siempre debe estar ordenada (criterio a elección) y mostrar subtotales y totales
# (también a elección sobre que campos se calculan los totales)
################################################################################


################################################################################
#defino aca las constantes que estan en instalarT.conf (hago asi por cuestiones de desarrollo rapido)...
$GLOBAL_grupo                  	= "/home/mart/ssoo1c-2012/TP/Grupo13";

$dir_productos = $GLOBAL_grupo."/maestro/prod.mae";
$dir_sucursales = $GLOBAL_grupo."/maestro/sucu.mae";
$dir_clientes = $GLOBAL_grupo."/maestro/cli.mae";

sub parseConfig{

}

sub loadHashes{

	$dir_pro_ = $dir_productos;
	$dir_suc_ = $dir_sucursales;
	$dir_cli_ = $dir_clientes;
	
	@array_pro;
	@array_suc;
	@array_cli;
			
	$error_open_pro = "si";
	$error_open_suc = "si";
	$error_open_cli = "si";
	
# Abre los archivos de productos, sucursales y clientes
	if ( open(FILE_PRO," < $dir_pro_") ){
		$error_open_pro = "no";
		@array_pro = <FILE_PRO>;
		close(FILE_PRO);
	}
	if ( open(FILE_SUC," < $dir_suc_") ){
		$error_open_suc = "no";
		@array_suc = <FILE_SUC>;
		close(FILE_SUC);
	}
	if ( open(FILE_CLI," < $dir_cli_") ){
		$error_open_cli = "no";
		@array_cli = <FILE_CLI>;
		close(FILE_CLI);
	}		
# En caso de error informa y sale
	if ($error_open_pro eq "si" || $error_open_suc eq "si" || $error_open_cli eq "si"){
		if ($error_open_pro eq "si"){ print "error lectura de productos\n";}
		if ($error_open_suc eq "si"){ print "error lectura sucursales\n";}
		if ($error_open_cli eq "si"){ print "error lectura clientes\n";}				
		exit 1;
	}

# Recorre secuencialmente el archivo

# Realiza split dejando los campos que interesan para el hash, clave y valor

# Carga el hash de productos, valor clave: itemName, valor asoc.: idTypeName


# Recorre secuencialmente el archivo

# Realiza split dejando los campos que interesan para el hash, clave y valor

# Carga el hash de sucursales, valor clave: idSuc, valor asoc.: branchName


# Recorre secuencialmente el archivo

# Realiza split dejando los campos que interesan para el hash, clave y valor

# Carga el hash de clientes, valor clave: idClient, valor asoc.: clientName

exit 0;

}

sub parseArgs{

# Si encuentra -h imprime ayuda y sale

# Si encuentra -c setea el flag de impresion solo por pantalla

# Si encuentra -e setea el flag de impresion en archivo

# Si encuentra -t determina un arreglo con los archivos a mirar (nombre). Tambien valida que sean validos y
# que si es * exista un archivo en el directorio

# Si encuentra -s guarda un array de id sucursales a matchear, si es * lo guarda y es interpretado luego como any
# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.

# Si encuentra -k guarda un array de id clientes a matchear, si es * lo guarda y es interpretado luego como any
# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.


# Si encuentra -p guarda el string a matchear con el campo itemName. 

#Si hay mas de 11 tira error por exceder el maximo

}


sub generateOutputData{

# Por cada archivo en el array lo abro y recorro secuencialmente

# Aplico los filtros de producto, cliente y sucursal

# Si el resultado es OK guardo en mi buffer de salida

# Cierro el archivo


# Ordeno buffer de salida por idCliente decreciente

}


sub printData{

# Imprimo mi buffer por stdout

# Si el flag -e guardo en archivo

# Creo archivo en repositorio default con nombre lpi.<aaaammddhhmmss>

# Hago un vuelco de la info en el archivo

# Cierro el archivo de reporte


}

sub printHelp{

# Imprime informacion de uso de la herramienta
# Usage:	listarT.pl -<c|e|h|s|k|p|t>
#	
#
#
#
#
#
#
#
#


}


# main()

parseConfig();
parseArgs();
loadHashes();
generateOutputData();
printData();























