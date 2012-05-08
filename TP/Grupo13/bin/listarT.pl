#!/usr/bin/perl 


sub parseConfig{

}

sub loadHashes{

# Abre los archivos de productos, sucursales y clientes

# En caso de error informa y sale

# Recorre secuencialmente el archivo

# Realiza split dejando los campos que interesan para el hash, clave y valor

# Carga el hash de productos, valor clave: itemName, valor asoc.: idTypeName


# Recorre secuencialmente el archivo

# Realiza split dejando los campos que interesan para el hash, clave y valor

# Carga el hash de sucursales, valor clave: idSuc, valor asoc.: branchName


# Recorre secuencialmente el archivo

# Realiza split dejando los campos que interesan para el hash, clave y valor

# Carga el hash de clientes, valor clave: idClient, valor asoc.: clientName

}

sub parseArgs{

# Si encuentra -h imprime ayuda y sale

# Si encuentra -c setea el flag de impresion solo por pantalla

# Si encuentra -e setea el flag de impresion en archivo

# Si encuentra -t determina un arreglo con los archivos a mirar (nombre). Tambien valida que sean validos y
# que si es * exista un archivo en el directorio

# Si encuentra -s guarda un array de id sucursales a matchear, si es * lo guarda y es interpretado luego como any
# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.

# Si encuentra -k guarda un array de id clientes a matchear, si es * lo guarda y es interpretado luego como any
# Tambien realiza la validacion de los elementos, si alguno no es numerico (a excepcion de *) devuelve error.


# Si encuentra -p guarda el string a matchear con el campo itemName. 

#Si hay mas de 11 tira error por exceder el maximo

}


sub generateOutputData{

# Por cada archivo en el array lo abro y recorro secuencialmente

# Aplico los filtros de producto, cliente y sucursal

# Si el resultado es OK guardo en mi buffer de salida

# Cierro el archivo


# Ordeno buffer de salida por idCliente decreciente

}


printData{

# Imprimo mi buffer por stdout

# Si el flag -e guardo en archivo

# Creo archivo en repositorio default con nombre lpi.<aaaammddhhmmss>

# Hago un vuelco de la info en el archivo

# Cierro el archivo de reporte


}

printHelp{

# Imprime informacion de uso de la herramienta

}


# main()

parseConfig();
parseArgs();
loadHashes();
generateOutputData();
printData();























