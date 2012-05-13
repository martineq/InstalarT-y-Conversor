#!/usr/bin/perl 
# ------------------------------------------------------------------------------------------------
#grupo: 13
#autor: Ariel M.
#fecha: 30/04/2012
#comando: MoverT
#Parametros
#     Parametro 1 (obligatorio): origen  --> el path de este archivo no tiene que tener asignado un numero de secuencia
#     Parametro 2 (obligatorio): destino --> este directorio tiene que finalizar con la barra
#     Parametro 3 (obligatorio): comando que la invoca
#	  Estado: <<INCOMPLETO>>		
#	  Porcentaje completo: 98%
# ------------------------------------------------------------------------------------------------
#
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

########################################################################
#FUNCION PARA DEVOLVER EL ULTIMO NUMERO DE SECUENCIA DEL ARCHIVO PASADO POR PARAMETRO, ESTO
#SE REALIZA EN EL DIRECTORIO PASADO POR PARAMETRO
# parametro 1: archivo mediante el cual cacular su numero de secuencia
# parametro 2: directorio en donde calcular el numero de secuencia
# 
# RETURN
#         -1: para que se pueda realizar solo el "MOVER DUPLICADO" segun nombrado en el enunciado
#         -2: para que se pueda realizar solo el "MOVER ESTANDAR" segun nombrado en el enunciado
#
# readme:para administrar el numero de secuencia en la operacion de "MOVER ESTANDAR" se guardo en un arreglo
# todos los nombres de los archivos del directorio a considerar para el calculo del numero de secuencia, luego
# se fue comparando mediante un patron definido por el archivo mediante el cual se calcula tal numero, y a continuacion
# mediante ese patron se toma el maximo numero de secuencia encontrado, para finalmente devolverlo.
sub getNroSecuencia_ultimo{
	#readme: el formato de la extension del archivo origen tiene que ser asi: [nombreFile].[ExtensionFile], y por eso
	#ese valor 2 hard-codeado
	$nombreArh_patron = @_[0]; 	
	$dir = @_[1]; 				
	
	if (opendir(DIRH, "$dir")){
		@flist = readdir(DIRH);
		closedir(DIRH);
	}
	
	@nombresArch_patron_split = split("[.]", $nombreArh_patron);
	
	$existe_nombreArh_patron = "no";
	$nroMax_secuencia = -1; 
	@flist_ordenado = sort(@flist);
	
	foreach(@flist_ordenado){
		#ignoro . y ..
		next if ($_ eq "." || $_ eq "..");
		@nombresArch_split = split("[.]", $_);
		
		$long_nombresArch_split = @nombresArch_split;
		
		if ($long_nombresArch_split >= 2){
			if (@nombresArch_patron_split[0] eq @nombresArch_split[0]){
				if (@nombresArch_patron_split[1] eq @nombresArch_split[1]){
					if ($existe_nombreArh_patron eq "no"){
						$existe_nombreArh_patron = "si";
					}
					if ($long_nombresArch_split >= 3){
						if (@nombresArch_split[2] > $nroMax_secuencia){
							$nroMax_secuencia = @nombresArch_split[2];
						}
					}
				}
			}
		}
	} #fin foreach

	if ($existe_nombreArh_patron eq "no"){
		$nroMax_secuencia = -2;
	}
	
	return ($nroMax_secuencia);
}

# FUNCION PARA MOVER UN ARCHIVO DESDE ORIGEN HASTA DESTINO
# parametro1: path del archivo a mover. Parametro esta validado
# parametro2: directorio destino hasta donde se movera. Parametro esta validado
sub mover_estandar{
	$origen_ = @_[0];
	$destino_ = @_[1];
	
	$copiar = `cp $origen_ $destino_`;
	$eliminar = `rm $origen_`;
}

# FUNCION PARA RENOMBRAR UN ARCHIVO
# parametro1: path completo del archivo a renombra por parametro 1. Por ejemplo dir/arch.txt
# parametro2: directorio destino hasta donde se movera. Parametro esta validado
sub renombrar{
	$name_old_ = @_[0];
	$name_new_ = @_[1];

	rename($name_old, $name_new) or die "ERROR: imposible renombrar $name_old a $name_new/n";
}

########################################################################
	
#segun criterio, falta definir la cantidad maxima de parametros
$cant_max_parametros = 4;

#arrivo de los parametros en un array
@argumentos = @ARGV;
$cant_parametros = $#argumentos + 1;

#valido la cantidad de parametros
#readme: poner a la carpeta destino la barra que indique que es archivo tipo directorio, sino no se va a poder renombrar
if ( ($cant_parametros >= 2) && ($cant_parametros <= $cant_max_parametros) ){
	
		$origen = @argumentos[0];  #directorio origen
		$destino = @argumentos[1]; #directorio destino
		#verifico que origen y destino existen
		$existe_origen = "no";
		if (-e $origen) {
		   $existe_origen = "si";
		}else{
				print "ERROR_SEVERO: No existe origen\n";	
				exit 1;
			}

		$existe_destino = "no";
		if (-e $destino) {
		   $existe_destino = "si";
		}else{
				print "ERROR_SEVERO: No existe destino\n";
				exit 1;
			}
		
		if ($existe_origen eq "si" && $existe_destino eq "si"){
			($dir_origen, $arch_origen) = separar_enDir_yArchivo($origen);
			($dir_destino, $arch_destino) = separar_enDir_yArchivo($destino);

			$dir_distintos = "si";
			if ( $dir_origen eq $dir_destino ){
				$dir_distintos = "no";
			}

			if ($dir_distintos eq "si") {
				
				$nroSecuencia_ultimo = getNroSecuencia_ultimo($arch_origen, $destino);
				if( $nroSecuencia_ultimo == -2 ){
					print "INFORMATIVO: se ejecuto el \"mover estandar\":\n";
					#print "origen: ".$origen."\n";
					#print "destino: ".$destino."\n";
					mover_estandar($origen, $destino);
				}else{
					print "INFORMATIVO: se ejecuto el \"mover duplicado\":\n";
					$nroSecuencia_archMover = $nroSecuencia_ultimo + 1;
					$nombre_nuevo = $arch_origen.".".$nroSecuencia_archMover;
					$name_old = $origen;
					$name_new = $dir_origen.$nombre_nuevo;		
					#print "name_old: $origen\n";
					#print "name_new: $name_new\n";

					#para no borrar en directorio origen un archivo con numero de secuencia ya creado
					$name_new_2 = $name_new;	
					$extension_fantasma = ".movertmp";
					$name_new = $name_new.$extension_fantasma;
					renombrar($name_old, $name_new);
					$origen_nuevo = $name_new;
					#print "\tdestino: ".$destino."\n";
					mover_estandar($origen_nuevo, $destino);

					#para compenzar el agregado de la extension fantasma
					$name_old = $dir_destino.$nombre_nuevo.$extension_fantasma;	
					$name_new = $dir_destino.$nombre_nuevo;						
					#print "name_old: $name_old\n";
					#print "name_new: $name_new\n";
					renombrar($name_old, $name_new);
					}
			}else{
					if ($dir_distintos eq "no"){
						print "ERROR: Los directorios origen y destino son iguales\n";
						exit 1;
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
	exit 1;
	
}

exit 0;