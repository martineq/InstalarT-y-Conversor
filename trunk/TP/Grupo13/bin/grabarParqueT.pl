#!/usr/bin/perl 
# ------------------------------------------------------------------------------------------------
#Grupo: 13
#Autor: Ariel M. y Ariel L.
#Fecha: 18/05/2012
#Comando: GrabarParqueT
#Descripcion: Genera los archivos de parque instalado
#Parametros: -
# ------------------------------------------------------------------------------------------------
#
################################################################################
#
#
#
#
#

################################################################################
#defino aca las constantes que estan en instalarT.conf (hago asi por cuestiones de desarrollo rapido)...
$grupo                  = "/home/ariel/ssoo1c-2012/TP/Grupo13";
$ejecutable_loguearT	= $grupo."/bin/loguearT.sh";
$nombre_grabarParqueT 	= "GrabarParqueT.pl";
$dir_inst_recibidas 	= $grupo."/inst_recibidas";
$dir_inst_rechazadas 	= $grupo."/inst_rechazadas";
$dir_inst_procesadas 	= $grupo."/inst_procesadas";
$dir_inst_ordenadas 	= $grupo."/inst_ordenadas";

if ( !(-d $grupo) ){
    print "ERROR SEVERO: corregir la variable \$grupo en grabarParqueT.pl\n";
    exit 2;
}

################################################################################
sub ambienteInicializado{
	$inicializado = "si";
	#TODO: tiene que preguntar en el archivo de configuracion generado por el comando instalar, eso creo.
	#...
	return ($inicializado);
}

################################################################################
sub grabarParqueEstaCorriendo{
	$estaCorriendo = "no";
	#TODO: tiene que preguntar en el archivo de configuracion generado por el comando instalar, eso creo.
	#...
	return ($estaCorriendo);
}

################################################################################
sub getNombresArchivosProcesar{
    $dir_archivosProcesar_ = @_[0];
    
    @nombres_ArhivosProcesar;
    
    opendir ( DIR, $dir_archivosProcesar_ ) || die "Error in opening dir $dir_archivosProcesar_\n";
    
    while( $filename = readdir(DIR))
    {
        #si no tiene permiso de lectura se lo doy
        if ( !(-r $filename) ){
            $darPermiso_ = `chmod +x $dir_archivosProcesar_"/"$filename`;
        }
        # ignorar . y .., y tambien los archivos svn:
        if (!($filename eq "." || $filename eq "..") && !($filename eq ".svn"))
        {
            push(@nombres_ArhivosProcesar, $filename);
        }
    }    
    closedir(DIR);    
    
    return ( @nombres_ArhivosProcesar );
}

################################################################################
sub inicializarLogCon{
		$cant_archivosProcesar_ = @_[0];
		
		#le doy permiso de ejecucion al comando LoguearT si es que no lo tiene
        if (!(-x $ejecutable_loguearT)){
            print $ejecutable_loguearT.": NO es ejecutable\n";
            $darPermiso = `chmod +x $ejecutable_loguearT`;
        }		
        
		$grabarLog = `$ejecutable_loguearT $nombre_grabarParqueT I \"Inicio de GrabarparqueT: \<$cant_archivosProcesar_\>\"`;
		#print "Log: ";
		#print $grabarLog;
}

################################################################################
sub procesarArchivoRecibido{
	$nombre_archivo_recibido = @_[0];
	$grabarLog = `$ejecutable_loguearT $nombre_grabarParqueT I \"Archivo a Procesar: \<$nombre_archivo_recibido\>\"`;
    #print "Log: ";
    #print $grabarLog;
	#TODO: proceso del archivo recibido... 
    $archivo_procesar = $dir_archivosProcesar_."/".$nombre_archivo_recibido;
    print $archivo_procesar."\n";

}

################################################################################
sub principal{
	
	$esAmbienteInit = ( ambienteInicializado() eq "si" );
	$corriendoGrabarParque = ( grabarParqueEstaCorriendo() eq "no" );
	
	#verifica si se puede iniciar la ejecucion del comando...
	if ( $esAmbienteInit && $corriendoGrabarParque )
	{
		@nombres_ArhivosProcesar = getNombresArchivosProcesar($dir_inst_recibidas);
		$cant_archivosProcesar = @nombres_ArhivosProcesar;
		inicializarLogCon($cant_archivosProcesar);
		
		#procesa los archivos detectados en el directorio de archivos a procesar
		print "Archivos a procesar...\n";
		foreach (@nombres_ArhivosProcesar){
			procesarArchivoRecibido($_);
		}
		
		#TODO: seguir en base a  "Pasos sugeridos" de la pagina 28 del enunciado, y mas 
		#especificamente desde el punto "4.Verificar que no sea un archivo duplicado"
		#... 
	
	}else{
		if ( !$esAmbienteInit ){
			print "... ambiente no esta inicializado";
			exit 2;
		}
		if ( $corriendoGrabarParque ){
			print "... el comando grabarParque ya esta corriendo";
			exit 2;
		}
	}
}


principal();
print "En proceso de construccion...\n";
exit 0;	
#...
