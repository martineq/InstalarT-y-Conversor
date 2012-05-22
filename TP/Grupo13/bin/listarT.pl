#!/usr/bin/perl 

#########################################
#					#
#	Sistemas Operativos 75.08	#
#	Grupo: 	13			#
#	Nombre:	listarT.pl		#
#					#
#########################################


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
	
	@flist_pro;
	@flist_suc;
	@flist_cli;
			
	$error_open_pro = "si";
	$error_open_suc = "si";
	$error_open_cli = "si";
	
# Abre los archivos de productos, sucursales y clientes
	if (opendir(DIR_PRO, "$dir_pro_")){
		$error_open_pro = "no";
		@flist_pro = readdir(DIR_PRO);
		closedir(DIR_PRO);
	}
	if (opendir(DIR_SUC, "$dir_suc_")){
		$error_open_suc = "no";
		@flist_suc = readdir(DIR_SUC);
		closedir(DIR_SUC);
	}
	if (opendir(DIR_CLI, "$dir_cli_")){
		$error_open_cli = "no";
		@flist_cli = readdir(DIR_CLI);
		closedir(DIR_CLI);
	}
# En caso de error informa y sale
	if ($error_open_pro eq "si" || $error_open_suc eq "si" || $error_open_cli eq "si"){
		print "No se puedo abrir archivos del parque instalado\n";
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























