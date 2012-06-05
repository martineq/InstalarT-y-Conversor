#!/usr/bin/perl 
use Getopt::Long;


################################################################################
#defino aca las constantes que estan en instalarT.conf (hago asi por cuestiones de desarrollo rapido)...


@bufferOutput =();
@sucArray =();
@cliArray =();
@filesToProcess =();
@myArgs =();
%prodHash;
%cliHash;
%sucuHash;
$stringToMatch ='';

# Variables de argumentos.
$help = '';
$stdout = '';
$fileout = '';
@files =();
@sucursales =();
@clientes =();
$string = '';

$matchSucFlag=0;
$matchCliFlag=0;
$matchStrFlag=0;
$printFlag=0;
$printScreen=0;


sub printHelp{

# Imprime informacion de uso de la herramienta
# Usage:	listarT.pl -<c|e|h|s|k|p|t>
#	
	print "\n listarT.pl\n
			USAGE: listarT.pl -<c|e|h|s|k|p|t> \n
			-c setea el flag de impresion solo por pantalla\n
			-e setea el flag de impresion en archivo\n
			-t determina un arreglo con los archivos a mirar\n
			-s guarda un array de id sucursales\n
			-k guarda un array de id clientes a matchear\n
			-p guarda el string a matchear\n";

}

sub parseConfig{
	$maeDir = $ENV{"MAEDIR"};
	$grupo = $ENV{"GRUPO"};
	$reportes = $ENV{"REPODIR"};

	$cliMae = $maeDir."/cli.mae";
	$prodMae = $maeDir."/prod.mae";
	$sucMae = $maeDir."/sucu.mae";
	$parqueInstalado="$grupo/parque_instalado";
}

sub loadHashes{
	# Abre los archivos de productos, sucursales y clientes
	open F_CLIENTES, "<", "$cliMae" or die "No se pudo abrir el archivo de $cliMae";
	open F_PRODUCTOS, "<", "$prodMae" or die "No se pudo abrir el archivo de $prodMae";
	open F_SUCURSALES, "<", "$sucMae" or die "No se pudo abrir el archivo de $sucMae";

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
	print "prodTypeId: $prodTypeId, prodTypeName: $prodTypeName, itemName: $itemName  ";
		$prodHash{$itemName}=$prodTypeName;
	}

	# Cierro archivos

	close (F_CLIENTES);
	close (F_SUCURSALES);
	close (F_PRODUCTOS);

};

sub parseArgs{

	@myArgs = @ARGV;
	GetOptions('help|h' => \$help, 
				'stdout|c' => sub { $printScreen=1 },
				'fileout|e'=>  sub { $printFlag=1 },
				"files|t=s{,}" => \@files,
				"suc|s=s{,}" => \@sucursales,
				"clientes|k=s{,}" => \@clientes,
				"string|p=s" => \$string
				);
	
	if( $help ) {
		# Si encuentra -h imprime ayuda y sale
		printHelp();
		exit 1;
    }

	# if ( $stdout ) {
		# Si encuentra -c setea el flag de impresion solo por pantalla
		# $printScreen=1;
	# }

	# if ( $fileout ) {
		# Si encuentra -e setea el flag de impresion en archivo
		# $printFlag=1;	
	# }
	
	if ( $#files >= 0 ) {
		# Si encuentra -t determina un arreglo con los archivos a mirar (nombre). Tambien valida que sean validos y
		# que si es * exista un archivo en el directorio
		
		# while ( (($ARGV[$i] ne '-e') &&($ARGV[$i] ne '-c') &&($ARGV[$i] ne '-h') &&($ARGV[$i] ne '-s') &&($ARGV[$i] ne '-k') &&($ARGV[$i] ne '-p')) && ($i < $cantParams) ){
			# print "$i ,  $ARGV[$i]";
			# @filesToProcess=$ARGV[$i];
			# $i++;
		# }
		for ( my $i=0; $i <= $#files; $i++ ){
			#next if ( $files[$i] eq "." || $files[$i] eq ".." );
			$filesToProcess[$i]=$files[$i];
			print "File to process: $filesToProcess[$i] \n";
		}
	}
	
	if ( $#sucursales >= 0 ) {
	# Si encuentra -s guarda un array de id sucursales a matchear, si es * lo guarda y es interpretado luego como any
	# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.
		# $i++;
		# $j=0;
		# while ( (($ARGV[$i] ne '-e') &&($ARGV[$i] ne '-c') &&($ARGV[$i] ne '-h') &&($ARGV[$i] ne '-s') &&($ARGV[$i] ne '-k') &&($ARGV[$i] ne '-p')) && ($i < $cantParams) ){
			# @sucArray=$ARGV[$i];
			# $matchSucFlag=1;
			# $i++;
			# $j++;
			# if ($j > 1){
				# print "El rango no pueden ser mas de dos elementos!";
				# exit 1;
			# }
		# }
		if ( $#sucursales >= 2 ){
			print "El rango no pueden ser mas de dos elementos!";
			exit 1;
		}
		$sucArray[0] = $sucursales[0];
		$sucArray[1] = $sucursales[1];
		$matchSucFlag=1;
	}

	if ( $#clientes >= 0 ) {
	# Si encuentra -k guarda un array de id clientes a matchear, si es * lo guarda y es interpretado luego como any
	# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.
		# $i++;
		# while ( (($ARGV[$i] ne '-e') &&($ARGV[$i] ne '-c') &&($ARGV[$i] ne '-h') &&($ARGV[$i] ne '-s') &&($ARGV[$i] ne '-k') &&($ARGV[$i] ne '-p')) && ($i < $cantParams) ){
			# @cliArray=$ARGV[$i];
			# $matchCliFlag=1;
			# $i++;
		# }
		for ( my $i=0; $i <= $#clientes; $i++ ){
			$cliArray[$i]=$clientes[$i];
		}
		$matchCliFlag=1;
	}
	
	if ( $string ) {
		# Si encuentra -p guarda el string a matchear con el campo itemName.
		# $i++;
		# while ( (($ARGV[$i] ne '-e') &&($ARGV[$i] ne '-c') &&($ARGV[$i] ne '-h') &&($ARGV[$i] ne '-s') &&($ARGV[$i] ne '-k') &&($ARGV[$i] ne '-p')) && ($i < $cantParams) ){
			# $stringToMatch=$ARGV[$i];
			# $matchStrFlag=1;
		# }
		$stringToMatch=$string;
		$matchStrFlag=1;
	}
}

sub addElementToBuffer(){
	push(@bufferOutput,[$f_idSuc,$sucHash{$f_idSuc},$f_idCli,$cliHash{$f_idCli},$prodHash{$prodTypeNameComp},$descCabecera,$descDetalle]);
}

sub generateOutputData{
	# Por cada archivo en el array lo abro y recorro secuencialmente
	# Si file to process es * debo leer todos los archivos del directorio
	if ( $filesToProcess[0] eq "*" ){
		$i=0;
		opendir(DIR, $parqueInstalado) or die $!;
		print "abri $parqueInstalado\n";
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
		#print "procesando $parqueInstalado/$_";
		while (<F_INPUT>){
			chomp;
			($f_idSuc, $f_idCli, $descCabecera, $descDetalle)=split(",");
			$flagEscritura = 0;
			$prodTypeNameComp = $descCabecera;
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
				print "valido clientes : $cliArray[0] - $f_idCli\n";
				$cliArraySize = $#cliArray + 1;
				if ($cliArray[0] eq "*"){
					$flagEscritura = 1;
				}
				if ($cliArray[0] == $f_idCli ){
					$flagEscritura = 1;
				}
				if ( $cliArraySize > 1 ){
					 foreach (@cliArray) {
						if ( $f_idCli == $_ ){
							print "comparando $f_idCli CON $_\n";
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
				if ( $descCabecera =~ $stringToMatch ){
					#Si es un substring o incluso el string sigo adelante!
					$prodTypeNameComp = $descCabecera;
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

	# Ordeno buffer de salida por f_idSuc creciente
	
	@bufferOutput = sort { $a->[0] cmp $b->[0] } @bufferOutput;

};


sub printData{

# Imprimo mi buffer por stdout
# Si el flag es -e guardo en archivo
# Creo archivo en repositorio default con nombre lpi.<aaaammddhhmmss>
# Hago un vuelco de la info en el archivo
# Cierro el archivo de reporte

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$mon++;
	$year+=1900;
	$repId = "$year"."$mon"."$mday"."$hour"."$min"."$sec";
	#print "\n REP_ID: $repId\n";
	
	if ($printScreen eq 1){
		print "Reporte: lpi.$repId";
		print " -- Invocado con: ";
		foreach (@myArgs) {
        		print "$_ ";
		}
		print "\n\nID SUC | BRANCH NAME | ID CLIENTE | CUST 1ST NAME | TIPO PROD | PLAN COM | ITEM\n";
		for $elem ( @bufferOutput ) {
			print join( ',', @$elem )."\n";
		};
	}
	if ($printFlag eq 1){
		open F_REPORTE, ">", "$reportes/lpi.$repId" or die "No se pudo abrir el archivo de $reportes/lpi.$repId";
		print F_REPORTE "Reporte: lpi.$repId";
		print F_REPORTE " -- Invocado con: ";
		foreach (@myArgs) {
        		print F_REPORTE "$_ ";
		}
		print F_REPORTE "\n\nID SUC | BRANCH NAME | ID CLIENTE | CUST 1ST NAME | TIPO PROD | PLAN COM | ITEM\n";
		for $elem ( @bufferOutput ) {
			print F_REPORTE join( ',', @$elem )."\n";
		};
	}
}

# main()
parseArgs();
parseConfig();
loadHashes();
generateOutputData();
printData();














