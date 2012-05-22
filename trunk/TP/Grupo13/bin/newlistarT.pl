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
$reportes=$grupo."/reportes";
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

	$cantParams = @ARGV;
	$matchSucFlag=0;
	$matchCliFlag=0;
	$matchStrFlag=0;
	$printFlag=0;
	$printScreen=0;
	
	if($cantParams == 1) {
	# Si encuentra -h imprime ayuda y sale
        if($ARGV[0] eq '-h' || $ARGV[0] eq '--help') {
            printHelp();
	    exit 1;
        }
        else {
            print "Comando incorrecto \n";
		printHelp();
		exit 1;
        }
        return 1;
    }
	
	for($i = 0; $i < $cantParams; $i++) {
	
		if ( $ARGV[$i] eq '-c' ) {
			# Si encuentra -c setea el flag de impresion solo por pantalla
			$printScreen=1;
		}
	
		if ( $ARGV[$i] eq '-e' ) {
			# Si encuentra -e setea el flag de impresion en archivo
			$printFlag=1;	
		}
		
		if ( $ARGV[$i] eq '-t' ) {
			# Si encuentra -t determina un arreglo con los archivos a mirar (nombre). Tambien valida que sean validos y
			# que si es * exista un archivo en el directorio
			$i++;
			while ( (($ARGV[$i] ne '-e') || ($ARGV[$i] ne '-c') || ($ARGV[$i] ne '-h') || ($ARGV[$i] ne '-s') || ($ARGV[$i] ne '-k') || ($ARGV[$i] ne '-p')) && ($i < $cantParams) ){
				@filesToProcess=$ARGV[$i];
				$i++;
			}
		}
		
		if ( $ARGV[$i] eq '-s' ) {
		# Si encuentra -s guarda un array de id sucursales a matchear, si es * lo guarda y es interpretado luego como any
		# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.
			$i++;
			$j=0;
			while ( (($ARGV[$i] ne '-e') || ($ARGV[$i] ne '-c') || ($ARGV[$i] ne '-h') || ($ARGV[$i] ne '-s') || ($ARGV[$i] ne '-k') || ($ARGV[$i] ne '-p')) && ($i < $cantParams) ){
				@sucArray=$ARGV[$i];
				$matchSucFlag=1;
				$i++;
				$j++;
				if ($j > 1){
					print "El rango no pueden ser mas de dos elementos!";
					exit 1;
				}
			}
		}

		if ( $ARGV[$i] eq '-k' ) {
		# Si encuentra -k guarda un array de id clientes a matchear, si es * lo guarda y es interpretado luego como any
		# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.
			$i++;
			while ( (($ARGV[$i] ne '-e') || ($ARGV[$i] ne '-c') || ($ARGV[$i] ne '-h') || ($ARGV[$i] ne '-s') || ($ARGV[$i] ne '-k') || ($ARGV[$i] ne '-p')) && ($i < $cantParams) ){
				@cliArray=$ARGV[$i];
				$matchCliFlag=1;
				$i++;
			}
		}
		
		if ( $ARGV[$i] eq '-p' ) {
			# Si encuentra -p guarda el string a matchear con el campo itemName.
			$i++;
			while ( (($ARGV[$i] ne '-e') || ($ARGV[$i] ne '-c') || ($ARGV[$i] ne '-h') || ($ARGV[$i] ne '-s') || ($ARGV[$i] ne '-k') || ($ARGV[$i] ne '-p')) && ($i < $cantParams) ){
				$stringToMatch=$ARGV[$i];
				$matchStrFlag=1;
			}
		}
	}

}

sub addElementToBuffer(){
	push(@bufferOutput,[$f_idSuc,$sucHash{$f_idSuc},$f_idCli,$cliHash{$f_idCli},$prodTypeNameComp,$prodHash{$prodTypeNameComp}]);
}

sub generateOutputData{


# Por cada archivo en el array lo abro y recorro secuencialmente
# Si file to process es * debo leer todos los archivos del directorio
if ( $filesToProcess[0] == "*" ){
	$i=0;
	opendir(DIR, $parqueInstalado) or die $!;
	while ( my $file = readdir(DIR)) {
        # Evito todo lo que comienze con "."
        if ($file =~ m/^\./){
		$i++;
		next;
		}
		$filesToProcess[$i] = $file;
    }
    closedir(DIR);
}

foreach (@filesToProcess ){
	open F_INPUT, "<", "$parqueInstalado/$_" or die "No se pudo abrir el archivo de $parqueInstalado/$_";
	while (<F_INPUT>){
		chomp;
		($f_idSuc, $f_idCli, $desc)=split(",");
		$flagEscritura = 0;
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
			if ( $sucArray[0] eq "*"){
				$flagEscritura = 1;
			}
			if ($sucArray[0] == $f_idSuc ){
				$flagEscritura = 1;
			}
			# Si no matchea sigo con el proximo registro
			if ($flagEscritura == 0){
				next;
			}
		}
		$flagEscritura=0;
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
                        if ($flagEscritura == 0){
                                next;
                        }

		}
		$flagEscritura=0;
		if ( $matchStrFlag == 1 ){
			if ( $desc =~ $stringToMatch ){
				#Si es un substring o incluso el string sigo adelante!
				$prodTypeNameComp = $desc;
				$flagEscritura = 1;
			}		
                        if ($flagEscritura == 0){
                                next;
                        }
		}
		
		# Si el resultado es OK guardo en mi buffer de salida
		addElementToBuffer();
	}
	# Cierro el archivo
	close (F_INPUT);
}

# Ordeno buffer de salida por idCliente decreciente
# sort

};


sub printData{

# Imprimo mi buffer por stdout

# Si el flag es -e guardo en archivo

# Creo archivo en repositorio default con nombre lpi.<aaaammddhhmmss>

# Hago un vuelco de la info en el archivo

# Cierro el archivo de reporte

	if ($printFlag == 1){
		for $aref ( @bufferOutput ) {
			print "\t [ @$aref ],\n";
		};
	}
	
	if ($printScreen == 1){
		
		open F_REPORTE, ">", "$reportes/reporte.rep" or die "No se pudo abrir el archivo de $cliMae";
		for $aref ( @bufferOutput ) {
			print F_REPORTE "\t [ @$aref ],\n"; 
		};
	}
}

sub printHelp{

# Imprime informacion de uso de la herramienta
# Usage:	listarT.pl -<c|e|h|s|k|p|t>
#	
	print "USAGE: listarT.pl -<c|e|h|s|k|p|t> ";

}


# main()

if(parseArgs(@ARGV) != 0){
		printHelp();
        exit;
}

parseConfig();

loadHashes();
generateOutputData();
printData();























