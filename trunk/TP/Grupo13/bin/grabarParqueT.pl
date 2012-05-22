#!/usr/bin/perl 
# ------------------------------------------------------------------------------------------------
#Grupo: 13
#Autor: Ariel M. y Ariel L.
#Fecha: 18/05/2012
#Comando: GrabarParqueT.pl
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
$GLOBAL_grupo                  	= "/home/mart/ssoo1c-2012/TP/Grupo13";
$GLOBAL_ejecutable_loguearT		= $GLOBAL_grupo."/bin/loguearT.sh";
$GLOBAL_ejecutable_moverT		= $GLOBAL_grupo."/bin/moverT.pl";
$GLOBAL_nombre_grabarParqueT 	= "GrabarParqueT.pl";
$GLOBAL_dir_inst_recibidas 		= $GLOBAL_grupo."/inst_recibidas";
$GLOBAL_dir_inst_rechazadas 	= $GLOBAL_grupo."/inst_rechazadas";
$GLOBAL_dir_inst_procesadas 	= $GLOBAL_grupo."/inst_procesadas";
$GLOBAL_dir_inst_ordenadas 		= $GLOBAL_grupo."/inst_ordenadas";

if ( !(-d $GLOBAL_grupo) ){
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
        if (!(-x $GLOBAL_ejecutable_loguearT)){
            print $GLOBAL_ejecutable_loguearT.": NO es ejecutable\n";
            $darPermiso = `chmod +x $GLOBAL_ejecutable_loguearT`;
        }		
        
		$grabarLog = `$GLOBAL_ejecutable_loguearT $GLOBAL_nombre_grabarParqueT I \"Inicio de GrabarparqueT: \<$cant_archivosProcesar_\>\"`;
		#print "Log: ";
		#print $grabarLog;
}

################################################################################
sub exite_archivo_En{
		$arch_origen = @_[0];
		$dir_destino = @_[1];
		
		
		$exite_archivo_origen_ = "no";
		
		if (opendir(DIRH,"$dir_destino"))
		{
			@flist=readdir(DIRH);
			closedir(DIRH);
		}
		foreach (@flist){
			# ignorar . y .. :
			next if ($_ eq "." || $_ eq "..");
			if ( -r "$dir_destino/$_" ){
				if ( $_ eq $arch_origen ){
					$exite_archivo_origen_ = "si";
				}
			}
		}
		closedir(DIRH);

		return ($exite_archivo_origen_);
}

################################################################################
#los archivos ordenados los escribe en el mismo directorio(inst_recibidas)
#el criterio de ordenamiento es:
#CUSTOMER_ID (asc),
#OPERATION_DATE (de la mas antigüa a la más reciente), 
#COMMERCIAL_PLAN_ID (asc),
#CLASS_SERVICE_IS_REQUIRED (desc).
sub ordenar_archivo{
    $archivo_procesar = @_[0];
    
    #...
}

################################################################################
sub procesarArchivoRecibido{
	$nombre_archivo_recibido = @_[0];
	$grabarLog = `$GLOBAL_ejecutable_loguearT $GLOBAL_nombre_grabarParqueT I \"Archivo a Procesar: \<$nombre_archivo_recibido\>\"`;
	$esArchivoDuplicado = "si";
	
    $archivo_procesar = $dir_archivosProcesar_."/".$nombre_archivo_recibido;
    
    #se considera los archivos duplicados
    $esArchivoDuplicado = exite_archivo_En($nombre_archivo_recibido, $GLOBAL_dir_inst_procesadas);
    if ( $esArchivoDuplicado eq "si" )
    {
    	$grabarLog = `$GLOBAL_ejecutable_loguearT $GLOBAL_nombre_grabarParqueT I \"En inst_procesadas ya existe el archivo: $nombre_archivo_recibido\.Se lo mueve hasta inst_rechazadas\"`;
    	
    	$moverDuplicado = `$GLOBAL_ejecutable_moverT $archivo_procesar $GLOBAL_dir_inst_rechazadas`;
    	
    }else{
    #...
    ordenar_archivo($archivo_procesar);
    
		#TODO: continuar con los no duplicados
		print $archivo_procesar."\n";
    }
}

################################################################################
sub principal{
	
	$esAmbienteInit = ( ambienteInicializado() eq "si" );
	$corriendoGrabarParque = ( grabarParqueEstaCorriendo() eq "no" );
	
	#verifica si se puede iniciar la ejecucion del comando...
	if ( $esAmbienteInit && $corriendoGrabarParque )
	{
		@nombres_ArhivosProcesar = getNombresArchivosProcesar($GLOBAL_dir_inst_recibidas);
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
