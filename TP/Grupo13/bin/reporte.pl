#!/usr/bin/perl 
# ------------------------------------------------------------------------------------------------
#Script creado por: grupo13
#
#Input
#       Archivo de Contrato de Prestamos Personales $grupo/datadir/new/CONTRAT.<pais>
#       Archivo Maestro Prestamos Personales Impagos $grupo/datadir/mae/PPI.mae
#       Tabla de Paises y Sistemas $grupo/conf/p-s.tab
#
#Output
#       Log $grupo/logdir/reporte.log
#       Listado $grupo/datadir/list/<nombre listado>.<id>
#       Archivo de Modificaciones de Contratos $grupo/datadir/new/MODIF.<pais>
#
#Hipotesis
#       El usuario debe ingresar junto con el comando el nombres del Archivo de Contrato de Prestamos Personales , y el nombre del
#       Archivo Maestro Prestamos Personales Impagos, el programa toma el Path seteado durante la instalcion y busca dichos archivos.
#       La Tabla de Paises y Sistemas no se puede elegir como parametro
#       Los parametros que el usuario ingresa en el menu son todos numeros enteros, excepto el pais ingresado que es el id alfabetico.
#       Los numeros de contratos en ambos archivos son unicos.
#       El programa siempre resuelve unicamente los 6 listados que se encuentran en el enunciado
#       Los listados resultantes, si no tienen datos no se muestran por pantalla.
#       
#       En el archivo de modificaciones, el usuario de grabacion se toma de la variable de ambiente Unix "USER"
#       Aunque se hayan o no ingresado filtros por sistema, anio y mes, en cada listado siempre se calculan
#           subtotales por los 3 parametros y dichos subtotales son los que se muestran por pantalla en los listados 
# 
# ------------------------------------------------------------------------------------------------


# FUNCION QUE IMPRIME POR PANTALLA Y GUARDA EN EL LOG
sub printAndLog {
        $mensaje=$_[1];
        print($mensaje);
        chomp($mensaje);        
        `"glog.sh" "reporte" "$_[0]" "$mensaje"`;
}

sub soloLog {
        $mensaje=$_[1];
    chomp($mensaje);    
        `"glog.sh" "reporte" "$_[0]" "$mensaje"`;
}


sub exceptionOpenFile{
    #en el array especial @_ estan los argumentos que se le pasan a la subrutina
    #por ello tomo el solamente el primero asi obtengo el nombre del archivo 
    printAndLog "E", "Se sale del programa porque no se pudo abrir el archivo $_[0]\n";
    print "\n";
    exit(1);
}


# EXCEPCION AL MOMENTO DE CREAR LOS ARCHIVOS
sub exceptionCreateFile{
    #en el array especial @_ estan los argumentos que se le pasan a la subrutina
    #por ello tomo el solamente el primero asi obtengo el nombre del archivo 
    printAndLog "E", "Se sale del programa porque no se pudo crear el archivo $_[0]\n";
    print "\n";    
        exit(1);
}



# FUNCION QUE PIDE EL SISTEMA Y VERIFICA LA EXISTENCIA PARA EL PAIS CORRESPONDIENTE
sub getSystem{
    $salida = 0;
    printAndLog "I","Ingrese el ID del Sistema: ";
        do{     
                open(DATOS,"< $TABLACONF")|| exceptionOpenFile "$TABLACONF";
        #con "<" abro el archivo de modo lectura, en verdad no hace falta ya que por defecto es "<"
                
                chop ($sistema=<STDIN>);
                soloLog "I","$sistema";
                printAndLog "I", "Verificando la existencia de sistema ingresado....\n";
                printAndLog "I","Sistemas disponibles:";
                while ($linea=<DATOS>)
                {
                        chomp($linea); 
                        @campos=split("-",$linea);
                        #printAndLog "$campos[2]\n";
                        if (($pais eq $campos[0])||($pais eq $campos[1])){
                                printAndLog"I"," $campos[2]"; 
                                if ($sistema eq $campos[2]){
                                         $salida = 1;    
                                }
                        }
                }
                if($salida eq 1){
            print "\nSistema encontrado\n";     
                        soloLog "I" ,"Sistema encontrado";      
                }else{
                        printAndLog "E","\nNo existe el sistema ingresado en el archivo $TABLACONF\n";
                        printAndLog "I","Por favor ingrese un nuevo sistema: ";
                }
            close(DATOS);       
        }while($salida eq 0);
        
}


# FUNCION QUE VERIFICA LA EXISTENCIA DEL PAIS EN EL NOMBRE DEL ARCHIVO CONTRACT.<pais>
# TAMBIEN VERIFICA QUE EXISTA EN LA TABLA DE PAISES Y SISTEMAS
sub chequeoPais{
    $se_encontro= "0";
    $LONGITUD = length $pais;
        printAndLog "I", "Verificando la existencia del pais ingresado....\n";
        if ($ARGV[0]=~ /.$pais$/)
        {       #encontramos el pais en el nombre del archivo, ahora tengo q ver q exista en la tabla
        open(DATOS,"< $TABLACONF")|| exceptionOpenFile $TABLACONF;
                #con "<" abro el archivo de modo lectura, en verdad no hace falta ya que por defecto es "<"
                while ($linea=<DATOS>)
                {
                        chomp($linea); 
                        @campos=split("-",$linea);
                        if (($pais eq $campos[0])&&($LONGITUD ne 0))
                        {
                        $se_encontro = "1";
                        }
                }       
                close(DATOS);
                if($se_encontro eq "0")
                {       
                        printAndLog "E","EL programa a finalizado porque el Pais no se a encontrado en la Tabla de Paises y Sistemas: $TABLACONF\n";
                        print "\n";    
                        exit(1);        
                }               
        }
        else
        {       
                printAndLog "E", "El programa a finalizado porque el pais no es el mismo al del Archivo de Contratos de  Prestamos Personale $ARGV[0]\n";
                print "\n";    
                exit(1);
        }
        printAndLog "I","Pais encontrado\n";
}


sub getParametros{
        printAndLog "I","Por favor ingrese el ID de un Pais: ";
    chop ($pais=<STDIN>);       
    soloLog "I","$pais"; 
        chequeoPais $pais;              
        printAndLog "I","Desea ingresar un Sistema? [S/N]: ";  
    $salida = "1";        
        do{
                chop ($respuesta=<STDIN>);              
                soloLog "I","$respuesta";
        if (($respuesta eq "S")||($respuesta eq "N"))
                {
                $salida = "0"   
        }
                else
        {
                        printAndLog "I","Por favor ingrese \"S\" para Si o \"N\" para No: ";
                }
    }while( $salida ne "0");
        
        if ($respuesta eq "S")
        {
            getSystem;
        }
        else {$sistema = "No Aplica";}
        print "\n";
        printAndLog "I","Desea ingresar un Anio ? [S/N] : ";
        $salida = "1";        
        do{
                chop ($respuesta_anio=<STDIN>);
                soloLog "I","$respuesta_anio";
        if (($respuesta_anio eq "S")||($respuesta_anio eq "N"))
                {
                $salida = "0"   
        }
                else
                {
                        printAndLog "I","Por favor ingrese \"S\" para Si o \"N\" para No: ";
                }
    }while( $salida ne "0");

        if ($respuesta_anio eq "S")
        {
            printAndLog "I","Ingrese el Anio: ";
                chop ($anio=<STDIN>);
            soloLog "I","$anio";
            printAndLog "I","Desea ingresar un Mes ? [S/N]: ";
        $salida = "1";
        do{
                        chop ($respuesta_mes=<STDIN>);
                soloLog "I","$respuesta_mes";
                if (($respuesta_mes eq "S")||($respuesta_mes eq "N"))
                        {
                        $salida = "0"   
                }
                        else
                        {
                                printAndLog "I","Por favor ingrese \"S\" para Si o \"N\" para No: ";
                        }
        }while( $salida ne "0"); 
            if ($respuesta_mes eq "S")
            {
                        do
                        {
                printAndLog "I","Ingrese un mes correcto: ";
                                chop ($mes=<STDIN>);
                                soloLog "I","$mes";
                $aux = ($mes *1);
                   $salida = "1";
                                if(($aux <= 12)&&($aux > 0))
                                {
                                        $salida ="0";
                                }       
                        }while($salida ne "0");
            }
            else
            {
                        $mes = "No Aplica";
            }    
        }
    else
    {
                $anio= "No Aplica";
                $mes= "No Aplica"; 
        }
        #APROVECHO Y DECLARO EL HASH DONDE GUARDAR EL ARCHIVO MAESTRO
        my %hm;  #hash master
        my %hm_mt;   #hash master montos totales
}


# FUNCION USADA PARA VERIFICAR LA EXISTENCIA DE LOS ARCHIVOS PASADOS COMO PARAMETROS
sub fileExist{
        open(DATOS,"< $_[0]")|| exceptionOpenFile $_[0];
        close(DATOS);
}



# FUNCION QUE TERMINA DE FILTRAR LOS DATOS Y TERMINA DE GUARDAR EN EL HASH, EL ARCHIVO MAESTRO
sub saveMasterInHash{

#SOLO ME QUEDO CON LOS QUE TIENE ESTADO SANO O DUDOSO Y ADEMAS FILTRO SIEMPRE POR PAIS
    
        if ((($campos_maesto[5] eq "DUDOSO")||($campos_maestro[5] eq "SANO"))){
        
        soloLog "I", "Archivo maestro; numero de contrato: [$campos_maestro[8]]. Calculando el monto restante....\n";   
                $id = $campos_maestro[8];
                $hm{$id}=$linea;
                
                $mt_crd = $campos_maestro[10]*1;
                $mt_impago= $campos_maestro[11]*1;
                $mt_inde = $campos_maestro[13]*1;
                $mt_otr = $campos_maestro[14]*1;
                
                $mt_total = $mt_crd + $mt_impago + $mt_inde - $mt_otr;
                
                $hm_mt{$id}=$mt_total;
   
        
        }
        else{
# SIN ESTA DOBLE COMPARACION, NO ANDA BIEN, YA QUE SINO FILTRA MAL
                if ((($campos_maesto[5] eq "SANO")||($campos_maestro[5] eq "DUDOSO"))){
            
                soloLog "I", "Archivo maestro; numero de contrato: [$campos_maestro[8]]. Calculando el monto restante....\n";   
                        $id = $campos_maestro[8];
                        $hm{$id}=$linea;
                
                        $mt_crd = $campos_maestro[10]*1;
                        $mt_impago= $campos_maestro[11]*1;
                        $mt_inde = $campos_maestro[13]*1;
                        $mt_otr = $campos_maestro[14]*1;
                
                        $mt_total = $mt_crd + $mt_impago + $mt_inde - $mt_otr;
                
                        $hm_mt{$id}=$mt_total;
        
                }
                else
                {
                        soloLog "I","Archivo maestro; numero de contrato: [$campos_maestro[8]] estado contable invalido [$campos_maestro[5]]";              }
    }
}


# FUNCION QUE APLICA EL FILTRO POR ANIO Y MES DEL ARCHIVO MAESTRO
sub filterByAnioAndMes{
        if($anio ne "No Aplica"){
                if($campos_maestro[2] == $anio) #aplico filtro por anio ingresado
        { 
                if($mes ne "No Aplica")
            {
                if($campos_maestro[3] == $mes) #aplico filtro por mes ingresado
                { 
                                saveMasterInHash;
                        }
                                else
                                {
                                     soloLog "I","Archivo maestro; numero de contrato: [$campos_maestro[8]] mes [$campos_maestro[3]] distinto al mes solicitado [$mes]";  
                                }
                        }
                    else #no hay filtro por mes
                    {
                        saveMasterInHash;
                    } 
        }
                else
                {
                        soloLog "I","Archivo maestro; numero de contrato: [$campos_maestro[8]] anio [$campos_maestro[2]] distinto al anio solicitado [$anio]";  
        }
        }
    else   #no hay filtro por anio y tampoco por mes
    {
       saveMasterInHash;
    }
}


# FUNCION QUE EMPIEZA A GUARDAR EL ARCHIVO MAESTRO EN EL HASH
sub filterMasterAndSave{

    soloLog "I", "Abriendo el archivo maestro\n";
    open (MAESTRO,"$DATADIR/mae/$ARGV[1]")|| exceptionOpenFile "$DATADIR/mae/$ARGV[1]";
    soloLog "I", "Cargando el archivo maestro en memoria....\n";
    while ($linea=<MAESTRO>)
    {
        chomp($linea);
      
        #reemplazo las , por . para asi tener numeros flotantes
        #"~s" sustituye y "g" es para hacerlo en toda la cadena y no en la primera ocurrencia
        $linea =~s/,/./g; 
                 
        @campos_maestro=split("-",$linea);
        #primero filtro por sistema ingresado
    if ($campos_maestro[0] eq $pais){ 
       if($sistema ne "No Aplica")
        {  
           if($campos_maestro[1] == $sistema) #aplico filtro por systema ingresado
           {     #USO == PORQUE SON NUMEROS
             filterByAnioAndMes;
           } #el systema no es el buscado
           else
                   {
                 soloLog "I","Archivo maestro; numero de contrato: [$campos_maestro[8]] sistema [$campos_maestro[1]] distinto al systema solicitado [$sistema]";              
                   }     
        }
        else  # no hay filtro por systema pero puede por añio por anio mes
        { 
             filterByAnioAndMes;
        }
        }
    else
        {
                soloLog "I","Archivo maestro; numero de contrato: [$campos_maestro[8]] pais [$campos_maestro[0]] distinto al pais solicitado [$pais]";        
        } 
    }     
    close(MAESTRO);
    soloLog "I", "El archivo maestro ya fue cargado en memoria\n";
}


# Determina si el script se esta ejecutando
sub isAlreadyRunning
{
        @ps = `ps -o args`;
        $executing = 0;
        for ($i = 0; $i < @ps; $i++)
        {
                if ($ps[$i] =~ /^perl[ ]+$0/)
                {
                        $executing++;
                }
        }

        return $executing > 1;
}


# FUNCION QUE RECIBE UN NUMERO DE CONTRATO, BUSCA POR ESE NUMERO EN EL HASH MAESTRO 
# LUEGO INSERTO EN EL HASH MODIFICACIONES LOS DATOS NECESARIOS 
sub hashModificaciones{
   
   $Ncontrato = $_[0];
   $valor = $ha{$Ncontrato};   #busco en el hash por la clave y obtengo su valor
   @c_hash=split("-",$valor);  #parseo el valor en el campos del hash
   
   
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
   $year += 1900;
   $mon++;
   $fecha = "$mday/$mon/$year $hour\:$min\:$sec";
   
   
   @nuevo_valor;
   @nuevo_valor[0] = $c_m[0];
   @nuevo_valor[1] = $c_m[1]; 
   @nuevo_valor[2] = $c_m[2];
   @nuevo_valor[3] = $c_m[3];
   @nuevo_valor[4] = $c_m[4];
   @nuevo_valor[5] = $c_m[5];
   @nuevo_valor[6] = $c_m[6];
   @nuevo_valor[7] = $c_m[7];
   @nuevo_valor[8] = $c_m[8];
   @nuevo_valor[9] = $c_m[9];
   @nuevo_valor[10] = $c_m[10];
   @nuevo_valor[11] = $mt_total_master;
   @nuevo_valor[12] = $fecha;
   @nuevo_valor[13] = $USERiD;
   
   $valor_a_insertar = join("-",@nuevo_valor);
   
   $hmodificaciones{$Ncontrato}=$valor_a_insertar;
       
}



# FUNCION QUE INSERTA/ACTUALIZA EN EL HASH CORRESPONDIENTE 
sub hashListados{

        @id;
        @id[0] = $c_m[1];  # sistema
        @id[1] = $c_m[2];  # anio
        @id[2] = $c_m[3];  # mes

        #uno todos los elementos separados por un "-" asi obtengo
        #la clave que voy a usar para buscar en el hash del listado
        $clave = join("-",@id);


        if($caso eq "a"){
                                                                                     
          $valor = $ha{$clave};   #busco en el hash por la clave y obtengo su valor
          @c_ha=split("-",$valor); #parseo el valor en el c_h (campos del hash)
          
        # aumento en uno la cantidad de contratos; y le sumo el monto 
          @c_ha[0]=@c_ha[0]+1; 
          @c_ha[1]=@c_ha[1]+ $mt_total_master; 
          
        #armo el nuevo valor para updatear en el hash  
          $valor_updateado = join("-",@c_ha);

        #guardo en el hash el nuevo valor  
          $ha{$clave}=$valor_updateado;
          
        } # fin del caso a

        if($caso eq "b"){
                                                                                      
          $valor = $hb{$clave};   #busco en el hash por la clave y obtengo su valor
          @c_hb=split("-",$valor); #parseo el valor en el c_h (campos del hash)
          
        # aumento en uno la cantidad de contratos; y le sumo el monto 
          @c_hb[0]=@c_hb[0]+1; 
          @c_hb[1]=@c_hb[1]+ $mt_total_master; 
          
        #armo el nuevo valor para updatear en el hash  
          $valor_updateado = join("-",@c_hb);

        #guardo en el hash el nuevo valor  
          $hb{$clave}=$valor_updateado;
          
        } # fin del caso b


        if($caso eq "c"){
                                                                                      
          $valor = $hc{$clave};   #busco en el hash por la clave y obtengo su valor
          @c_hc=split("-",$valor); #parseo el valor en el c_h (campos del hash)
          
        # aumento en uno la cantidad de contratos; y le sumo el monto 
          @c_hc[0]=@c_hc[0]+1; 
          @c_hc[1]=@c_hc[1]+ $mt_total_master;  
          @c_hc[2]=@c_hc[2]+ @c_c[11]; 
        #armo el nuevo valor para updatear en el hash  
          $valor_updateado = join("-",@c_hc);

        #guardo en el hash el nuevo valor  
          $hc{$clave}=$valor_updateado;
          
        } # fin del caso c


        if($caso eq "d"){
                                                                                      
          $valor = $hd{$clave};   #busco en el hash por la clave y obtengo su valor
          @c_hd=split("-",$valor); #parseo el valor en el c_h (campos del hash)
          
        # aumento en uno la cantidad de contratos; y le sumo el monto 
          @c_hd[0]=@c_hd[0]+1; 
          @c_hd[1]=@c_hd[1]+ $mt_total_master;  
          @c_hd[2]=@c_hd[2]+ @c_c[11]; 
        #armo el nuevo valor para updatear en el hash  
          $valor_updateado = join("-",@c_hd);

        #guardo en el hash el nuevo valor  
          $hd{$clave}=$valor_updateado;
          
        } # fin del caso d


        if($caso eq "e1"){
                                                                                      
          $valor = $he_mae_dudoso{$clave};   #busco en el hash por la clave y obtengo su valor
          @c_h=split("-",$valor); #parseo el valor en el c_h (campos del hash)
          
        # aumento en uno la cantidad de contratos; y le sumo el monto 
          @c_h[0]=@c_h[0]+1; 
          @c_h[1]=@c_h[1]+ $mt_total_master;  
          
        #armo el nuevo valor para updatear en el hash  
          $valor_updateado = join("-",@c_h);

        #guardo en el hash el nuevo valor  
          $he_mae_dudoso{$clave}=$valor_updateado;
          
        } # fin del caso e1


        if($caso eq "e2"){
                                                                                      
          $valor = $he_mae_sano{$clave};   #busco en el hash por la clave y obtengo su valor
          @c_h=split("-",$valor); #parseo el valor en el c_h (campos del hash)
          
        # aumento en uno la cantidad de contratos; y le sumo el monto 
          @c_h[0]=@c_h[0]+1; 
          @c_h[1]=@c_h[1]+ $mt_total_master;  
           
        #armo el nuevo valor para updatear en el hash  
          $valor_updateado = join("-",@c_h);

        #guardo en el hash el nuevo valor  
          $he_mae_sano{$clave}=$valor_updateado;
          
        } # fin del caso e2


        if($caso eq "f1"){
                                                                                      
          $valor = $hf_mae_dudoso{$clave};   #busco en el hash por la clave y obtengo su valor
          @c_h=split("-",$valor); #parseo el valor en el c_h (campos del hash)
          
        # aumento en uno la cantidad de contratos; y le sumo el monto 
          @c_h[0]=@c_h[0]+1; 
          @c_h[1]=@c_h[1]+ $mt_total_master;  
          @c_h[2]=@c_h[2]+ @c_c[11]; 
        #armo el nuevo valor para updatear en el hash  
          $valor_updateado = join("-",@c_h);

        #guardo en el hash el nuevo valor  
          $hf_mae_dudoso{$clave}=$valor_updateado;
          
        } # fin del caso f1


        if($caso eq "f2"){
                                                                                      
          $valor = $hf_mae_sano{$clave};   #busco en el hash por la clave y obtengo su valor
          @c_h=split("-",$valor); #parseo el valor en el c_h (campos del hash)
          
        # aumento en uno la cantidad de contratos; y le sumo el monto 
          @c_h[0]=@c_h[0]+1; 
          @c_h[1]=@c_h[1]+ $mt_total_master;  
          @c_h[2]=@c_h[2]+ @c_c[11]; 
        #armo el nuevo valor para updatear en el hash  
          $valor_updateado = join("-",@c_h);

        #guardo en el hash el nuevo valor  
          $hf_mae_sano{$clave}=$valor_updateado;
          
        } # fin del caso f2

} # fin funcion hashListados


#FUNCION QUE IMPRIME POR PANTALLA  LOS ENCABEZADOS PARA LOS LISTADOS
sub encabezadoListados{
print"\n";
print"\n";
print"\n";
print"---------------------------------------------------------------------------------------------------------";
print"-----------------------------------------\n";

print"        \t\t\t\t\t\t\t                  CANTIDAD                              MONTO               MONTO \n";  
print"\t\t\tLISTADOS\t\t\t        PARAMETROS           de        ESTADO      ESTADO   \tRESTANTE\t    RESTANTE\n";
print"        \t\t\t\t\t\t\t                  CONTRATOS   CONTRATO    MAESTRO     \tCONTRATO\t    MAESTRO\n";

print"---------------------------------------------------------------------------------------------------------";
print"-----------------------------------------\n";
}


#FUNCION QUE MUESTRA LOS LISTADOS POR PANTALLA CON DANDOLE FORMATO
sub imprimirListadosPorPantalla{

        encabezadoListados;
        #ha
        foreach my $llave (keys %ha){
            
            $valor = $ha{$llave};
            @c1=split("-",$llave);
            @c2=split("-",$valor);
            print"a)Contratos Comunes Sanos con identicos Monto Restante       |";
            print"  $pais @c1[0] @c1[1] @c1[2]\t|     @c2[0]     |   SANO   |    SANO   | @c2[1]  \t\t|  @c2[1]\n";
        }
        
        #hb
        foreach my $llave (keys %hb){
            
            $valor = $hb{$llave};
            @c1=split("-",$llave);
            @c2=split("-",$valor);
            print"b)Contratos Comunes Dudosos con identicos Monto Restante     |";
            print"  $pais @c1[0] @c1[1] @c1[2]\t|     @c2[0]     |  DUDOSO  |   DUDOSO  | @c2[1]  \t\t|  @c2[1]\n";
        }
        #hc
        foreach my $llave (keys %hc){
            
            $valor = $hc{$llave};
            @c1=split("-",$llave);
            @c2=split("-",$valor);
            print"c)Contratos Comunes Sanos con diferente Monto Restante       |";
            print"  $pais @c1[0] @c1[1] @c1[2]\t|     @c2[0]     |   SANO   |    SANO   | @c2[2]  \t\t|  @c2[1]\n";
        }
        #hd
        foreach my $llave (keys %hd){
            
            $valor = $hd{$llave};
            @c1=split("-",$llave);
            @c2=split("-",$valor);
            print"d)Contratos Comunes Dudosos con diferente Monto Restante     |";
            print"  $pais @c1[0] @c1[1] @c1[2]\t|     @c2[0]     |  DUDOSO  |   DUDOSO  | @c2[2]  \t\t|  @c2[1]\n";
        }
        #he_mae_dudoso
        foreach my $llave (keys %he_mae_dudoso){
            
            $valor = $he_mae_dudoso{$llave};
            @c1=split("-",$llave);
            @c2=split("-",$valor);
            print"e)Contratos Comunes con Dif Estado e identico Monto Restante |";
            print"  $pais @c1[0] @c1[1] @c1[2]\t|     @c2[0]     |   SANO   |   DUDOSO  | @c2[1]  \t\t|  @c2[1]\n";
            
        }
        #he_mae_sano
        foreach my $llave (keys %he_mae_sano){
            
            $valor = $he_mae_sano{$llave};
            @c1=split("-",$llave);
            @c2=split("-",$valor);
            print"e)Contratos Comunes con Dif Estado e identico Monto Restante |";
            print"  $pais @c1[0] @c1[1] @c1[2]\t|     @c2[0]     |  DUDOSO  |    SANO   | @c2[1]  \t\t|  @c2[1]\n";
        }
        #hf_mae_dudoso
        foreach my $llave (keys %hf_mae_dudoso){
            
            $valor = $hf_mae_dudoso{$llave};
            @c1=split("-",$llave);
            @c2=split("-",$valor);
            print"f)Contratos Comunes con Dif Estado y diferente Monto Restante|";
            print"  $pais @c1[0] @c1[1] @c1[2]\t|     @c2[0]     |   SANO   |   DUDOSO  | @c2[2]  \t\t|  @c2[1]\n";
        }
        #hf_mae_sano
        foreach my $llave (keys %hf_mae_sano){
            
            $valor = $hf_mae_sano{$llave};
            @c1=split("-",$llave);
            @c2=split("-",$valor);
            print"f)Contratos Comunes con Dif Estado y diferente Monto Restante|";
            print"  $pais @c1[0] @c1[1] @c1[2]\t|     @c2[0]     |  DUDOSO  |    SANO   | @c2[2]  \t\t|  @c2[1]\n";
        }
} # FIN IMPRIMIR ENCABEZADOS 



# FUNCION QUE CREA EL ARCHIVO DE MOFICACIONES, O LO TRUNCA SI EXISTE
sub saveModificaciones{
        
    $archivo = "$DATADIR/new/MODIF.$pais";
    open(ESCRITURA,"> $archivo") || exceptionCreateFile $archivo;
    
    foreach my $llave (keys %hmodificaciones){
        $valor = $hmodificaciones{$llave};
        print ESCRITURA "$valor\n";
    }
    close(ESCRITURA);
}


#FUNCION QUE GUARDA EN EL ARCHIVO PASADO POR PARAMETRO EL ENCABEZADO (SE LE PASA EL FILE DESCRIPTOR) 
sub imprimirEncabezadoListados{
  $archivo =$_[0];
  print $archivo "LISTADOS-PAIS-SISTEMA-ANIO-MES-CANTIDAD DE CONTRATOS-ESTADO CONTRATO-ESTADO MAESTRO-";
  print $archivo "MONTO RESTANTE CONTRATO-MONTO RESTANTE MAESTRO\n";
}


# FUNCION QUE GUARDA LOS LISTADOS EN LOS ARCHIVOS
sub guardarListados{
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    $mon++;
    $fecha = "$mday\-$mon\-$year $hour\:$min\:$sec";
    
    $archivo = "$DATADIR/list/listA.$fecha";
    open(ESCRITURA,"> $archivo") || exceptionCreateFile $archivo;
    imprimirEncabezadoListados (ESCRITURA);
    foreach my $llave (keys %ha){
        $valor = $ha{$llave};
        @c1=split("-",$llave);
        @c2=split("-",$valor);
        print ESCRITURA "a)Contratos Comunes Sanos con identicos Monto Restante\-";
        print ESCRITURA "$pais\-@c1[0]\-@c1[1]\-@c1[2]\-@c2[0]\-SANO\-SANO\-@c2[1]\-@c2[1]\n";
    }

    $archivo = "$DATADIR/list/listB.$fecha";
    open(ESCRITURA,"> $archivo") || exceptionCreateFile $archivo;
    imprimirEncabezadoListados (ESCRITURA);
    foreach my $llave (keys %hb){
        $valor = $hb{$llave};
        @c1=split("-",$llave);
        @c2=split("-",$valor);
        print ESCRITURA "b)Contratos Comunes Dudosos con identicos Monto Restante\-";
        print ESCRITURA "$pais\-@c1[0]\-@c1[1]\-@c1[2]\-@c2[0]\-DUDOSO\-DUDOSO\-@c2[1]\-@c2[1]\n";
    }   

    $archivo = "$DATADIR/list/listC.$fecha";
    open(ESCRITURA,"> $archivo") || exceptionCreateFile $archivo;
    imprimirEncabezadoListados (ESCRITURA);
    foreach my $llave (keys %hc){
        $valor = $hc{$llave};
        @c1=split("-",$llave);
        @c2=split("-",$valor);
        print ESCRITURA "c)Contratos Comunes Sanos con diferente Monto Restante\-";
        print ESCRITURA "$pais\-@c1[0]\-@c1[1]\-@c1[2]\-@c2[0]\-SANO\-SANO\-@c2[2]\-@c2[1]\n";
    }

    $archivo = "$DATADIR/list/listD.$fecha";
    open(ESCRITURA,"> $archivo") || exceptionCreateFile $archivo;
    imprimirEncabezadoListados (ESCRITURA);
    foreach my $llave (keys %hd){
        $valor = $hd{$llave};
        @c1=split("-",$llave);
        @c2=split("-",$valor);
        print ESCRITURA "d)Contratos Comunes Dudosos con diferente Monto Restante\-";
        print ESCRITURA "$pais\-@c1[0]\-@c1[1]\-@c1[2]\-@c2[0]\-DUDOSO\-DUDOSO\-@c2[2]\-@c2[1]\n";
    }

    $archivo = "$DATADIR/list/listE.$fecha";
    open(ESCRITURA,"> $archivo") || exceptionCreateFile $archivo;
    imprimirEncabezadoListados (ESCRITURA);
    foreach my $llave (keys %he_mae_dudoso){
        $valor = $he_mae_dudoso{$llave};
        @c1=split("-",$llave);
        @c2=split("-",$valor);
        print ESCRITURA "e)Contratos Comunes con Dif Estado e identico Monto Restante\-";
        print ESCRITURA "$pais\-@c1[0]\-@c1[1]\-@c1[2]\-@c2[0]\-SANO\-DUDOSO\-@c2[1]\-@c2[1]\n";
    }
    foreach my $llave (keys %he_mae_sano){
        $valor = $he_mae_sano{$llave};
        @c1=split("-",$llave);
        @c2=split("-",$valor);
        print ESCRITURA "e)Contratos Comunes con Dif Estado e identico Monto Restante\-";
        print ESCRITURA "$pais\-@c1[0]\-@c1[1]\-@c1[2]\-@c2[0]\-DUDOSO\-SANO\-@c2[1]\-@c2[1]\n";
    }

    $archivo = "$DATADIR/list/listF.$fecha";
    open(ESCRITURA,"> $archivo") || exceptionCreateFile $archivo;
    imprimirEncabezadoListados (ESCRITURA);
    foreach my $llave (keys %hf_mae_dudoso){
        $valor = $hf_mae_dudoso{$llave};
        @c1=split("-",$llave);
        @c2=split("-",$valor);
        print ESCRITURA "f)Contratos Comunes con Dif Estado y diferente Monto Restante\-";
        print ESCRITURA "$pais\-@c1[0]\-@c1[1]\-@c1[2]\-@c2[0]\-SANO\-DUDOSO\-@c2[2]\-@c2[1]\n";
    }
    foreach my $llave (keys %hf_mae_sano){
        $valor = $hf_mae_sano{$llave};
        @c1=split("-",$llave);
        @c2=split("-",$valor);
        print ESCRITURA "f)Contratos Comunes con Dif Estado y diferente Monto Restante\-";
        print ESCRITURA "$pais\-@c1[0]\-@c1[1]\-@c1[2]\-@c2[0]\-DUDOSO\-SANO\-@c2[2]\-@c2[1]\n";
    }

    close(ESCRITURA);
} #FIN ESCRITURA EN LOS ARCHIVOS DE LOS LISTADOS





# main()
# Primero chequeamos que no exista otro comando reporte en ejecucion. caso contrario salir:

if (isAlreadyRunning())
{
        print "ERROR: El comando ya esta ejecutandose\n";
        exit(1);
}

print "\n";
# tomo las variables de entorno que necesito
$DATADIR = $ENV{"DATADIR"};
$GRUPO = $ENV{"GRUPO"};
$USERiD = $ENV{"USER"};

$TABLACONF="$GRUPO/conf/P-S.tab";

#chequeamos que se halla realizada la inicializacion del ambiente. caso contrario salir.
# para ello verificamos el largo de la variable $DATADIR

$LONGITUD = length $DATADIR;

if ($LONGITUD == 0){
        printAndLog "E","La inicializacion del ambiente no fue correctamente realizada, fin de la ejecucion\n";
        print "\n";
        exit(1);
}else{
        printAndLog "I","Verificando inicializacion de ambiente realizada.....correcto\n";
        print "\n";
}


#Como este comando se dispara manualmente primero empezamos verificando los parametros
#ya sea en cuanto a cantidad de parametros, tipo, etc...

if ($#ARGV ne 1)
{
 printAndLog "I", "Se sale del programa porque son necesarios 2 archivos para la ejecucion de este comando\n";
 printAndLog "I","Los Archivos son: * Archivo de Contrato de Prestamos Personales\n"; 
 printAndLog "I","                * Archivo Maestro Prestamos Personales Impagos\n";
 print "\n"; 
 exit (1);
}

#verifico que exitan los 3 archivos de entrada, caso contrario se sale del programa
fileExist "$DATADIR/new/$ARGV[0]";
fileExist "$DATADIR/mae/$ARGV[1]";
fileExist "$GRUPO/conf/P-S.tab";

$TABLACONF="$GRUPO/conf/P-S.tab";



#guardar en el log el comienzo de Reporte
`"glog.sh" "reporte" "I" "Se inicia el comando \"Reporte\" con los archivos:[$ARGV[0]][$ARGV[1]]"`;


do
{
        getParametros;
        printAndLog "I","Los parametros Ingresados son:\n";
        printAndLog "I","PAIS= $pais\n";
        printAndLog "I","SYSTEMA= $sistema\n";
        printAndLog "I","ANIO= $anio\n";
        printAndLog "I","MES= $mes\n";

        printAndLog "I","Desea volver a elegir los parametros? [S/N] : ";

        $salida = "1";
    do{
        chop ($respuesta_menu=<STDIN>);
        soloLog "I","$respuesta_menu";

        if (($respuesta_menu eq "S")||($respuesta_menu eq "N"))
                {
                $salida = "0"   
        }
                else
                {
                        printAndLog "I","Por favor ingrese \"S\" para Si o \"N\" para No: ";
                }
    }while( $salida ne "0"); 
}while($respuesta_menu ne "N");

#CARGO EN MEMORIA EL ARCHIVO MAESTRO COMO ME PIDE EL ENUNCIADO

filterMasterAndSave;

#CREO LOS HASH QUE VOY A USAR PARA LOS LISTADOS
my %ha; 
my %hb;
my %hc;
my %hd;
my %he_mae_sano;
my %he_mae_dudoso;
my %hf_mae_sano;
my %hf_mae_dudoso;


my %hmodificaciones;
my %h_contratos;



#AHORA LEO EL ARCHIVO CONTRAC.<PAIS> TOMO EL NUMERO DE CONTRATO Y CARGO EN UN HASH.
soloLog "I", "Abriendo el archivo de contratos y cargando en memoria\n";
open (CONTRACT,"$DATADIR/new/$ARGV[0]")|| exceptionOpenFile "$DATADIR/new/$ARGV[0]";
while ($linea=<CONTRACT>)
{
   chomp($linea);
    
   #reemplazo las , por . para asi tener numeros flotantes
   #"~s" sustituye y "g" es para hacerlo en toda la cadena y no en la primera ocurrencia
   $linea =~s/,/./g; 
   @campos_contratos=split("-",$linea);
   $id = $campos_contratos[3];
   $h_contratos{$id}=$linea;
}
soloLog "I", "Archivo de contratos cargado en memoria\n";
close(CONTRACT);
soloLog "I", "Se termino de leer el archivo de contratos\n";


#CON ESE NUMERO DE CONTRATO, LEO DEL HASH MAESTRO  Y DEL HASH DEL MONTO TOTAL
# CON ESO VOY COMPARANDO A QUE LISTADO PERTENCE 

soloLog "I", "Abriendo el has de contratos y comparando los numeros de contratos con el maestro\n";


foreach my $llave (keys %h_contratos){
            
   $valor = $h_contratos{$llave};
   @c_c=split("-",$valor);
   if(exists($hm{$c_c[3]})){
#CON LA FUNCION EXIST VERIFICO QUE EXISTE ESE NUMERO DE CONTRATO EN EL HASH MAESTRO
 
# en row_m tomo el la fila  del hash master dada por el numero de contrato
        $row_m = ($hm{$c_c[3]});  
        
# c_m = campos del archivo maestro, ahi parseo el row del hash
        @c_m = split("-",$row_m); 

# mt_total_master es el monto total para ese numero de contrato
# que se encuentra en el hash hm_mt
        $mt_total_master = ($hm_mt{$c_c[3]});
   
    $valor_maestro = ($mt_total_master *1);
    $valor_contrato = ($c_c[11]*1);
    $resta = $valor_maestro - $valor_contrato;
    if ($resta < 0)
    {   
                $diferencia = ($resta * (-1));
        }
    else
    {
        $diferencia = ($resta);
    }
         

        if($c_m[5] eq $c_c[5])  #comparo los estados contables
        {  #opciones a, b ,c,d
            if($c_c[5] eq "SANO")
            { # opciones A Y C
                if ($diferencia < 0.01) #comparo los montos restantes           
                                {  
                                $caso = "a";
                        soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] pertenece al listado \"a\""; 
                                hashListados ($caso);
                 
                                }
                                else
                                {  
                                    $caso = "c";
                                        soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] pertenece al listado \"c\"";               
                                        hashListados ($caso);
                                hashModificaciones($c_c[3]);
                                }               
            }
            else
            { # ya se que son dudosos
                if ($diferencia < 0.01)
                { 
                    $caso = "b";
                                soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] pertenece al listado \"b\"";
                    hashListados ($caso);
                }
                else
                { 
                    $caso = "d";
                                soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] pertenece al listado \"d\"";
                    hashListados ($caso);
                }
            }
        }
        else
        { #estados contables e y f que a su vez se dividen en 2 c/u
           if($diferencia < 0.01)
           { #caso e
                if($c_m[5] eq "DUDOSO")
                {  
                soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] pertenece al listado \"e\"";
                    $caso = "e1"; # maestro dudoso
                    hashListados ($caso);
                }
                else
                { 
            soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] pertenece al listado \"e\"";
                    $caso = "e2"; #maestro sano
                    hashListados ($caso);
                    hashModificaciones($c_c[3]);
                }
           }
           else
           { #caso f
                if($c_m[5] eq "DUDOSO")
                {
                        soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] pertenece al listado \"f\"";
                    $caso = "f1"; # mestro dudoso
                    hashListados ($caso);
                }
                else
                { 
                    $caso = "f2"; # maestro sano
                        soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] pertenece al listado \"f\"";
                    hashListados ($caso);
                    hashModificaciones($c_c[3]);
                }
           }    
        }
   } #FIN DEL IF EXISTS
   else
    {
       soloLog "I", "Archivo de contratos; numero de contrato [$c_c[3]] no encontrado en el archivo maestro"; 
        }
   
} #FIN DEL WHILE
print "\n\n";
#recorro ahora el hash master
soloLog "I", "Imprimiendo listados por pantalla\n";
imprimirListadosPorPantalla();

print "\n";
print "\n";
print "\n";
printAndLog "I","Desea grabar los listados? [S/N] : ";
$salida = "1";        
do{
        chop ($respuesta_listados=<STDIN>);
        soloLog "I","$respuesta_listados";
        if (($respuesta_listados eq "S")||($respuesta_listados eq "N")){
                        $salida = "0"   
        }else {printAndLog "I","Por favor ingrese \"S\" para Si o \"N\" para No: ";}
}while( $salida ne "0");

if ($respuesta_listados eq "S")
{
    printAndLog "I", "Se procede a guardar los listados en archivos\n";
    guardarListados();
}
else{
   printAndLog "I", "Se eligio no guardar los listados\n";
}

printAndLog "I","Desea generar el archivo de Modificaciones? [S/N] : ";
$salida = "1";        
do{
    chop ($respuesta_modificaciones=<STDIN>);
        soloLog "I","$respuesta_modificaciones";
        if (($respuesta_modificaciones eq "S")||($respuesta_modificaciones eq "N")){
                        $salida = "0"   
        }else {printAndLog "I","Por favor ingrese \"S\" para Si o \"N\" para No: ";}
}while( $salida ne "0");

if ($respuesta_modificaciones eq "S")
{
    printAndLog "I", "Se procede a guarda el archivo de modificaciones\n";
    saveModificaciones();
}
else{
printAndLog "I", "Se ha elegido no guardar el archivo de modificaciones\n";
}


printAndLog "I","FIN DEL REPORTE\n";


exit(0);