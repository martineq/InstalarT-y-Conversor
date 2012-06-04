#!/usr/bin/perl 

# ------------------------------------------------------------------------------------------------
# Sistemas Operativos 75.08
#grupo: 13
#autor: Ariel M.
#fecha: 30/04/2012
#comando: moverT.pl
#Parametros
#     Parametro 1 (obligatorio): origen  --> el path de este archivo no tiene que tener asignado un numero de secuencia
#     Parametro 2 (obligatorio): destino --> este directorio tiene que finalizar con la barra
#     Parametro 3 (opcional): comando que lo invoca
# ------------------------------------------------------------------------------------------------

################################################################################
# FUNCION PARA SEPARAR EL PATH PASADO POR PARAMETRO EN DIRECTORIO Y EN ARCHIVO
# parametro 0: directorio+archivo
# return: array con el directorio y el archivo 
sub  separar_enDir_yArchivo{
        $origen_ = @_[0];
		$l = length($origen_);
		#contiene las posiciones de las barras
		@index_barras; 
		$pos = 0;
		#para verificar la existencia de ninguna barra al final del path
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


################################################################################
#FUNCION PARA DEVOLVER EL ULTIMO NUMERO DE SECUENCIA DEL ARCHIVO PASADO POR PARAMETRO, ESTO
#SE REALIZA EN EL DIRECTORIO PASADO POR PARAMETRO
# parametro 1: archivo mediante el cual cacular su numero de secuencia
# parametro 2: directorio en donde calcular el numero de secuencia
# RETURN: -1, solo si el archivo origen no tiene definido un numero de secuencia
#		  -2, solo si el archivo patron destino no tiene numero de secuencia y si el origen si lo tiene.
sub getNroSecuencia_ultimo{
	$nombreArh_patron = @_[0]; 	
	$dir = @_[1]; 				
	
	if (opendir(DIRH, "$dir")){
		@flist = readdir(DIRH);
		closedir(DIRH);
	}
	
	$nroMax_secuencia = -1;
	@nombresArch_patron_split = split("[.]", $nombreArh_patron);
	$long_nombresArch_split = @nombresArch_patron_split;
	if ($long_nombresArch_split >= 2){
		$nroMax_secuencia = -2;
	}else{
	 
			@flist_ordenado = sort(@flist);
	
			foreach(@flist_ordenado){
				#ignoro . y ..
				next if ($_ eq "." || $_ eq "..");
				@nombresArch_split = split("[.]", $_);
		
				$long_nombresArch_split = @nombresArch_split;
		
				if ($long_nombresArch_split >= 1){
					if (@nombresArch_patron_split[0] eq @nombresArch_split[0]){
							if ($long_nombresArch_split >= 2){
								if (@nombresArch_split[1] > $nroMax_secuencia){
									$nroMax_secuencia = @nombresArch_split[1];

								}
							}
					}
				}
			} #fin foreach
		}
	return ($nroMax_secuencia);
}

################################################################################
#FUNCION PARA MOVER CON ARGUMENTOS VALIDADOS Y TENIENDO EN CUENTA LOS NUMERO DE 
#SECUENCIA
sub moverValidado{
	$origen_ = @_[0];
	$destino_ = @_[1];	
	$copiar = `cp $origen_ $destino_`;
	$eliminar = `rm $origen_`;
}
########################################################################

sub main{
	@argumentos_ = @_;
	$cant_parametros_ = $#argumentos_ + 1;
	
	#En principio valido la cantidad de parametros...
	if ( ($cant_parametros_ >= 2) && ($cant_parametros_ <= 3) ){
	
		$origen = @argumentos_[0];  #directorio origen
		$destino = @argumentos_[1]; #directorio destino
	
		#verifico que origen y destino existen
		$existe_origen = "si";
		$existe_destino = "si";
		if ( !(-e $origen) ) {
			print "ERROR_SEVERO(moverT): No existe origen\n";	
			exit 1;
		}
	
		if ( !(-e $destino) ) {
			print "ERROR_SEVERO(moverT): No existe destino\n";
			exit 1;
		}
	
		if ($existe_origen eq "si" && $existe_destino eq "si"){
			($dir_origen, $arch_origen) = separar_enDir_yArchivo($origen);
			($dir_destino, $arch_destino) = separar_enDir_yArchivo($destino);

			if ( !($dir_origen eq $dir_destino) ) {
			
				$nroSecuencia_ultimo = getNroSecuencia_ultimo($arch_origen, $destino);
				#actualizo el numero de secuencia...
				if ($nroSecuencia_ultimo == -2){
					#aplicando la operacion mover despues de las validaciones
					moverValidado($origen, $destino);
					@nombresArch_split = split("[.]", $origen);
					$nombre_transformado = @nombresArch_split[0];
					$name_old = $dir_destino.$arch_origen;
					$name_new = $dir_destino.$nombre_transformado;
					rename($name_old, $name_new) 
						or die "ERROR(moverT): imposible renombrar[sin NroSecuencia] $name_old a $name_new (en destino)/n";
				}else{
				
						$nroSecuencia_archMover = $nroSecuencia_ultimo + 1;
						print "nroSecuencia_archMover: $nroSecuencia_archMover\n";
						$nombre_nuevo = $arch_origen.".".$nroSecuencia_archMover;
						$name_old = $origen;
						$name_new = $dir_origen.$nombre_nuevo;		
						#print "name_old: $origen\n";
						#print "name_new: $name_new\n";

						#para no borrar en directorio origen un archivo con numero de secuencia ya creado
						$name_new_2 = $name_new;	
						$extension_fantasma = ".movertmp";
						$name_new = $name_new.$extension_fantasma;
						rename($name_old, $name_new) or die "ERROR(moverT): imposible renombrar $name_old a $name_new(en origen) /n";
						$origen_nuevo = $name_new;
						#print "\torigen_nuevo: ".$origen_nuevo."\n";						
						#print "\tdestino: ".$destino."\n";
			
						#aplicando la operacion mover despues de las validaciones
						moverValidado($origen_nuevo, $destino);
				
						#para compenzar el agregado de la extension fantasma...
						$name_old = $dir_destino.$nombre_nuevo.$extension_fantasma;	
						$name_new = $dir_destino.$nombre_nuevo;						
						#print "name_old: $name_old\n";
						#print "name_new: $name_new\n";
						rename($name_old, $name_new) or die "ERROR(moverT): imposible renombrar $name_old a $name_new (en destino)/n";
					}
		
			}else{
					print "ERROR(moverT): origen y destino son iguales\n";
					exit 1;
				}
		}
		
		if ($cant_parametros_ >= 3){
			$comando_invocante = @argumentos_[2];
			#print "INFORMATIVO(moverT): comando que invocante a moverT: ".$comando_invocante."\n";		
		}
		
	}else{
	
		print "INFORMATIVO(moverT): USAGE = moverT origen destino/ comando(opcional)\n";
		exit 1;
	}
}

################################################################################
#llamada a la funcion principal

	main(@ARGV);
	
	exit 0;
	
#fin	
	
