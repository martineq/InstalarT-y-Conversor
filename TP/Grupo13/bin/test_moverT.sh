echo "Inicio test_moverT"
#algunas pruebas
./moverT.pl ../inst_recibidas/test_arielM.txt ../inst_rechazadas/

echo "::::::test_01::::"
./moverT.pl ../inst_recibidas/test_arielM.txt destino_no_existe

echo "::::::test_02::::"
./moverT.pl ../inst_recibidas/ destino_no_existe

echo "::::::test_03::::"
./moverT.pl ../origen_no_existe destino_no_existe

#resultados:
#ariel2011@arielEquipo:~/so/TP/Grupo13/bin$ ls
#logT.sh  moverT.pl  reporte.pl  test_moverT.sh
#ariel2011@arielEquipo:~/so/TP/Grupo13/bin$ ./test_moverT.sh 
#Inicio test_moverT
#INFORMATIVO: Inicio de ejecucion MOVER ESTANDARD
#origen: ../inst_recibidas/test_arielM.txt
#destino: ../inst_rechazadas/
#::::::test_01::::
#ERROR_SEVERO: No existe origen
#ERROR_SEVERO: No existe destino
#::::::test_02::::
#ERROR_SEVERO: No existe destino
#::::::test_03::::
#ERROR_SEVERO: No existe origen
#ERROR_SEVERO: No existe destino
#ariel2011@arielEquipo:~/so/TP/Grupo13/bin$

#no estan hechas las pruebas que son mas importantes, pero espero que estas anteriores sirvan como guia
