#!/usr/bin/perl 
# ------------------------------------------------------------------------------------------------
#grupo: 13
#autor: Ariel M.
#fecha: 30/04/2012
#comando: MoverT
#Parametros
#     Parametro 1 (obligatorio): origen
#     Parametro 2 (obligatorio): destino
#     Parametro 3 (obligatorio): comando que la invoca
#
# ------------------------------------------------------------------------------------------------
#nota: incompleto

# FUNCION PARA SEPARAR EL PATH PASADO POR PARAMETRO EN DIRECTORIO Y EN ARCHIVO
# parametro 0: directorio+archivo
# return: array con el directorio y el archivo 
sub  separar_enDir_yArchivo{
        $origen_ = @_[0];
		$l = length($origen_);
		#contiene las posiciones de las barras
		@index_barras; 
		$pos = 0;
		#para verificar la existencia de ninguna barra
		$hay_barra = "no";
		#mientras que la posicion sea positiva
		while ( $pos >= 0 && $pos < $l)
		{
			$pos = index($origen_,"/",$pos);
			if ($pos >= 0){
				$hay_barra = "si";
				push(@index_barras, $pos);
				#para volver a iniciar en la posicion siguiente
				$pos++;
			}
		}
		#para tomar el path incluyendo la barra
		$offset = 1;

		if ($hay_barra eq "no"){
			$offset = 0;
		}

		$directorio = substr($origen_,0,$index_barras[$#index_barras] + $offset);
		$archivo = substr($origen_,$index_barras[$#index_barras] + $offset);

		@return = ($directorio, $archivo);
		
		return (@return);
}

# FUNCION PARA SEPARAR EL PATH PASADO POR PARAMETRO EN DIRECTORIO Y EN ARCHIVO
# parametro1: archivo para verificar su existencia en parametro2
# parametro2: directorio destino en el cual comparar 
# return devuelve si o no, dependiendo si existe argumento1 en argumento2
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

# FUNCION PARA RENOMBRAR EL NOMBRE DE UN ARCHIVO, SEGUN EL NUMERO DE SECUENCIA
# parametro1: path del archivo a renombrar
# parametro2: numero de secuencia del archivo movido
sub renombrar(){
	$arch_renombrar = @_[0];
	$numero_secuncia = @_[1];
	
	$comando_renombrar = `rename -v 's/\.*$/\.\$numero_secuncia/' \$arch_renombrar`;

}

#segun criterio, falta definir la cantidad maxima de parametros
$cant_max_parametros = 4;

#arrivo de los parametros en un array
@argumentos = @ARGV;
$cant_parametros = $#argumentos + 1;


#valido la cantidad de parametros
if ( ($cant_parametros >= 2) && ($cant_parametros <= $cant_max_parametros) ){
	
		#tomo los valores de los dos primeros parametros
		$origen = @argumentos[0];  #directorio origen
		$destino = @argumentos[1]; #directorio destino

		#verifico que origen y destino existen
		$existe_origen = "no";
		if (-e $origen) {
		   $existe_origen = "si";
		}else{
				print "ERROR_SEVERO: No existe origen\n";
			}

		$existe_destino = "no";
		if (-e $destino) {
		   $existe_destino = "si";
		}else{
				print "ERROR_SEVERO: No existe destino\n";
			}
				
		#verifico que tiene permiso de lectura
		#...

		if ($existe_origen eq "si" && $existe_destino eq "si"){
			($dir_origen, $arch_origen) = separar_enDir_yArchivo($origen);
			($dir_destino, $arch_destino) = separar_enDir_yArchivo($destino);

			$dir_distintos = "si";
			if ( $dir_origen eq $dir_destino ){
				$dir_distintos = "no";
			}
				
			$existe_arch_origenEn = exite_archivo_En($arch_origen, $dir_destino);

			#situacion_1: MOVER ESTANDARD
			if ($dir_distintos eq "si" && $existe_arch_origenEn eq "no") {
				print "INFORMATIVO: Inicio de ejecucion MOVER ESTANDARD\n";
				print "origen: ".$origen."\n";
				print "destino: ".$destino."\n";
				$copiar = `cp $origen $destino`;
				$eliminar = `rm $origen`;
				#...llamar a logT

				#en principio es una valor vacio, entonces lo defino 
				$arch_destino = $destino.$arch_origen;
				#print $arch_destino."\n";

				#TODO: seguir revisando por que no funciona esta linea!!!...
				#$comando_renombrar = `rename 's/\.*$/\.0/' $arch_destino`;
				#renombrar("../inst_rechazadas/test.txt", "10");
				
			}else{
				if ($dir_distintos eq "no"){
					print "ERROR: Los directorios origen y destino son iguales\n";
					#...llamar a logT
				}
				if ($existe_arch_origenEn eq "si"){
					print "ERROR: El archivo origen existe en el directorio destino\n";
					#...llamar a logT
				}				
				}
		}
		
	if ($cant_parametros >= 3){
		$comando_invocante = @argumentos[2];
		print "INFORMATIVO: comando que invocante a moverT: ".$comando_invocante."\n";
		#valides de la existencia
		#...
		
	}
	if ($cant_parametros >= 4){
		#posible parametro extra segun el desarrollador
		#TODO:	definir su funcionalidad si es que existe
		$parametro_extra = @argumentos[3]; #nombre del comando invocante
		print "INFORMATIVO: parametro extra creado: ".$parametro_extra."\n";
		#valides de la existencia
		#...	
	}
		
}else{
	
	print "ERROR: la cantidad de parametros debe ser como minimo 2 y como maximo 4\n";
	
}
