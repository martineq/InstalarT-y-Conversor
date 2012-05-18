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

#constantes definidas en el archivo de configuracion(las uso aca por cuestiones de desarrollo rapido)...
$comandoLog 			= "Grupo13/bin/loguearT";
$comando_grabarParque 	= "GrabarParqueT";
$dir_archivosProcesar 	= "/inst_recibidas";


sub inicializarLogCon{
		$cant_archivosProcesar_ = @_[0];
		$grabarLog = `$comandoLog $comando_grabarParque I \"Inicio de GrabarparqueT: \<$cant_archivosProcesar_\>\"`;
}

sub procesarArchivoResivido{
	$archivo_recibido = @_[0];
	$grabarLog = `$comandoLog $comando_grabarParque I \"Archivo a Procesar: \<$archivo_recibido\>\"`;
	
	#TODO: proceso del archivo recibido... 
}

sub ambienteInicializado{
	$inicializado = "si";
	#TODO: tiene que preguntar en el archivo de configuracion generado por el comando instalar, eso creo.
	#...
	return ($inicializado);
}

sub grabarParqueEstaCorriendo{
	$estaCorriendo = "no";
	#TODO: tiene que preguntar en el archivo de configuracion generado por el comando instalar, eso creo.
	#...
	return ($estaCorriendo);
}

sub principal(){
	
	($estado_inicializacionAmbiente, $estado_corriendoGrabarParque) = sePuedeIniciar();
	
	$esAmbienteInit = ( ambienteInicializado() eq "si" );
	$corriendoGrabarParque = ( grabarParqueEstaCorriendo() eq "no" );
	
	#verifica si se puede iniciar la ejecucion del comando...
	if ( $esAmbienteInit && $corriendoGrabarParque ){
		@nombres_ArhivosProcesar = getNombresArchivosProcesar($dir_archivosProcesar);
		$cant_archivosProcesar = @nombres_ArhivosProcesar;
		inicializarLogCon($cant_archivosProcesar);
		#procesa los archivos detectados en el directorio de archivos a procesar
		foreach (@flist){
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

#...
