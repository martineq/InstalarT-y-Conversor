#!/usr/bin/perl 
use Getopt::Long;

#########################################
#										#
#	Sistemas Operativos 75.08			#
#	Grupo: 	13							#
#	Nombre:	listarT.pl					#
#										#
#########################################

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

# Flags de filtros
$matchSucFlag=0;
$matchCliFlag=0;
$matchStrFlag=0;
$printFlag=0;
$printScreen=0;


sub printHelp{

# Imprime informacion de uso de la herramienta
# Usage:	listarT.pl -<c|e|h|s|k|p|t>
#	
	print "\n\tPrograma: listarT.pl  -- Autor: Grupo13  -  GNU GPLv3
	Descripcion: Genera un reporte de parques instalados en base a queries
				 definidas por el usuario.
				 
	USAGE: listarT.pl -<c|e|h|s|k|p|t> 
	-----------------------------------------------------------------------\n
	-h : Imprime esta ayuda
	-c : Imprime la salida del programa por STDOUT
	-e : Se genera la salida del reporte en el directorio REPODIR
	-t : Filtro de tipos de producto <INTERNETCABLEMODEM|..|*>
	-s : Sucursal a validar <ID SUC> or rango de ellas <SUCinf> <SUCsup>
	-k : Cliente a consultar < ID CLI >
	-p : String o sub-string para filtrar con el cod. cabecera.\n
	-----------------------------------------------------------------------\n
	Ejemplo:
		listarT.pl -c -e -t INTERNETCABLEMODEM -s 100 -k 169 -p Cable
		listarT.pl -e -c -t \"*\" -s 100 145 -p \"Plan Comercial Cablemodem \\(Hoteles y Empresas\\)\"
		listarT.pl -c -t \"*\" -s \"*\" -k 169 124 177
	\n";
	exit 0;
	
}


# Seteo las variables en base a la informacion que brinda el entorno
sub parseConfig{
	$maeDir = $ENV{"MAEDIR"};
	$grupo = $ENV{"GRUPO"};
	$reportes = $ENV{"REPODIR"};

	$cliMae = $maeDir."/cli.mae";
	$prodMae = $maeDir."/prod.mae";
	$sucMae = $maeDir."/sucu.mae";
	$parqueInstalado="$grupo/parque_instalado";
}

# Cargo los hashes de clientes, productos y sucursales
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
	#print "prodTypeId: $prodTypeId, prodTypeName: $prodTypeName, itemName: $itemName  \n";
		$prodHash{$itemName}=$prodTypeName;
	}

	# Cierro archivos
	close (F_CLIENTES);
	close (F_SUCURSALES);
	close (F_PRODUCTOS);

};


# Realizo el parsing de los argumentos ingresados por el cliente
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
	
	if ( $#files >= 0 ) {
		# Si encuentra -t determina un arreglo con los archivos a mirar (nombre). Tambien valida que sean validos y
		# que si es * exista un archivo en el directorio
		for ( my $i=0; $i <= $#files; $i++ ){
			#next if ( $files[$i] eq "." || $files[$i] eq ".." );
			$filesToProcess[$i]=$files[$i];
			#print "File to process: $filesToProcess[$i] \n";
		}
	}
	
	if ( $#sucursales >= 0 ) {
	# Si encuentra -s guarda un array de id sucursales a matchear, si es * lo guarda y es interpretado luego como any
	# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.
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
		for ( my $i=0; $i <= $#clientes; $i++ ){
			$cliArray[$i]=$clientes[$i];
		}
		$matchCliFlag=1;
	}
	
	if ( $string ) {
		# Si encuentra -p guarda el string a matchear con el campo itemName.
		$stringToMatch=$string;
		$matchStrFlag=1;
	}
}

#Agrega un elemento al buffer de salida, se modularizo para dar claridad al codigo
sub addElementToBuffer(){
	push(@bufferOutput,[$f_idSuc,$sucHash{$f_idSuc},$f_idCli,$cliHash{$f_idCli},$prodHash{$prodTypeNameComp},$descCabecera,$descDetalle]);
}

# Genera la informacion que se almacena en el buffer de salida en base a los filtros que 
# se definieron mediante los argumentos de entrada del programa
sub generateOutputData{
	# Por cada archivo en el array lo abro y recorro secuencialmente
	# Si file to process es * debo leer todos los archivos del directorio
	if ( $filesToProcess[0] eq "*" ){
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
				#print "valido clientes : $cliArray[0] - $f_idCli\n";
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
							#print "comparando $f_idCli CON $_\n";
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
	@bufferOutput = sort { $a->[0] <=> $b->[0] } @bufferOutput;

};

# Imprime la info en la salida especificada
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














