#!/usr/bin/perl 


################################################################################
#defino aca las constantes que estan en instalarT.conf (hago asi por cuestiones de desarrollo rapido)...


@bufferOutput =();
%prodHash;
%cliHash;
%sucuHash;
	
sub parseConfig{

$grupo = "/var/tmp/TP/Grupo13";
$maeDir = "/var/tmp/TP/Grupo13/mae";
$cliMae = $maeDir."/cli.mae";
$prodMae = $maeDir."/prod.mae";
$sucMae = $maeDir."/sucu.mae";
$parqueInstalado=$grupo."/parque_instalado";
#/var/tmp/TP/Grupo13/parque_instalado/TVPORCABLE
}

sub loadHashes{
# Abre los archivos de productos, sucursales y clientes
open F_CLIENTES, "<", "$cliMae" or die "No se pudo abrir el archivo de $cliMae";
open F_PRODUCTOS, "<", "$prodMae" or die "No se pudo abrir el archivo de $cliMae";
open F_SUCURSALES, "<", "$sucMae" or die "No se pudo abrir el archivo de $cliMae";

# Recorre secuencialmente el archivo
while (<F_CLIENTES>){
	chomp;
	# Realiza split dejando los campos que interesan para el hash, clave y valor
	($idCliente, $territori, $cliName,$resto)=split(";");
	# Carga el hash de clientes, valor clave: idCliente, valor asoc.: clientName
	$cliHash{$idCliente}=$cliName;
}

# Recorre secuencialmente el archivo
while (<F_SUCURSALES>){
	chomp;
	# Realiza split dejando los campos que interesan para el hash, clave y valor
	($idRegion, $regionName, $idSuc,$sucName,$resto)=split(",");
	# Carga el hash de sucursales, valor clave: idSuc, valor asoc.: sucName
	$sucHash{$idSuc}=$sucName;
}


# Recorre secuencialmente el archivo
while (<F_PRODUCTOS>){
	chomp;
	# Realiza split dejando los campos que interesan para el hash, clave y valor
	($prodTypeId, $prodTypeName, $a, $s, $d, $f, $g, $h, $itemName)=split(",");
	# Carga el hash de productos, valor clave: prodTypeName, valor asoc.: itemName
	$sucHash{$prodTypeName}=$itemName;
}

# Cierro archivos

close (F_CLIENTES);
close (F_SUCURSALES);
close (F_PRODUCTOS);

};

sub parseArgs{


# Si encuentra -h imprime ayuda y sale


# Si encuentra -c setea el flag de impresion solo por pantalla
$printScree=1;

# Si encuentra -e setea el flag de impresion en archivo
$printFlag=1;

# Si encuentra -t determina un arreglo con los archivos a mirar (nombre). Tambien valida que sean validos y
# que si es * exista un archivo en el directorio

@filesToProcess=("TVPORCABLE");


# Si encuentra -s guarda un array de id sucursales a matchear, si es * lo guarda y es interpretado luego como any
# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.
@sucArray =();
$matchSucFlag=1;

# Si encuentra -k guarda un array de id clientes a matchear, si es * lo guarda y es interpretado luego como any
# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.
@cliArray =();
$matchCliFlag=1;

# Si encuentra -p guarda el string a matchear con el campo itemName.
$matchStrFlag=1;
$stringToMatch="";

#Si hay mas de 11 tira error por exceder el maximo

}

sub addElementToBuffer(){
	push(@bufferOutput,[$f_idSuc,$sucHash{$f_idSuc},$f_idCli,$cliHash{$f_idCli},$prodTypeNameComp,$prodHash{$prodTypeNameComp}]);
}

sub generateOutputData{

# Por cada archivo en el array lo abro y recorro secuencialmente
foreach (@filesToProcess ){
	open F_INPUT, "<", "$parqueInstalado/$_" or die "No se pudo abrir el archivo de $cliMae";
	while (<F_INPUT>){
		chomp;
		($f_idSuc, $f_idCli, $desc)=split(",");
		$flagEscritura = 0;
		#print "$f_idSuc\n"; 
		$prodTypeNameComp = $desc;
		# Aplico los filtros de producto, cliente y sucursal
		
		# Primero chequeo si debeo ver la sucursal, si tiene mas de un elemento es busqueda por rango
		# Sino busqueda precisa o con wildcard
		if ( $matchSucFlag == 1) {
			$sucArraySize = $#sucArray + 1;
			if ($sucArraySize == 2){
				if ( $f_idSuc > $sucArray[0] && $f_idSuc < $sucArray[1] ){
					#Esta dentro del rango
					$flagEscritura = 1;
				}
			}
			if ($sucArray[0] == "*"){
				$flagEscritura = 1;
			}
			if ($sucArray[0] == $f_idSuc ){
				$flagEscritura = 1;
			}
			# Si no matchea sigo con el proximo registro
			next;
		}
		
		if ( $matchCliFlag == 1 ){
			$cliArraySize = $#cliArray + 1;
			if ($cliArray[0] == "*"){
				$flagEscritura = 1;
			}
			if ($cliArray[0] == $f_idCli ){
				$flagEscritura = 1;
			}
			if ( $cliArraySize > 1 ){
				 foreach (@cliArray) {
					if ( $f_idCli == $_ ){
						$flagEscritura = 1;
					}
				}
			}
			# Si no matchea sigo con el proximo registro
			next;
		}
		
		if ( $matchStrFlag == 1 ){
			if ( $desc =~ $stringToMatch ){
				#Si es un substring o incluso el string sigo adelante!
				$prodTypeNameComp = $desc;
				$flagEscritura = 1;
			}		
			next;
		}
		
		# Si el resultado es OK guardo en mi buffer de salida
		if ( $flagEscritura == 1 ){
			addElementToBuffer();
		}
	}
}


# Cierro el archivo

# Ordeno buffer de salida por idCliente decreciente

};


sub printData{

# Imprimo mi buffer por stdout

# Si el flag es -e guardo en archivo

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
print "\nfin load hash\n";
generateOutputData();
printData();

    for $aref ( @bufferOutput ) {
        print "\t [ @$aref ],\n";
    };





















