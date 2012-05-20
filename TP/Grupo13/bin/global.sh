#!/bin/bash

# Grupo: 13
# Name: global.sh

#Devuelve la ruta de la variable a buscar

CONFDIR=`pwd | sed s#/bin#/confdir#g`
export GRUPO=`grep -A 0 GRUPO $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export ARRIDIR=`grep -A 0 ARRIDIR $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export RECHDIR=`grep -A 0 RECHDIR $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export BINDIR=`grep -A 0 BINDIR $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export MAEDIR=`grep -A 0 MAEDIR $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export REPODIR=`grep -A 0 REPODIR $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export LOGDIR=`grep -A 0 LOGDIR $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export LOGEXT=`grep -A 0 LOGEXT $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export LOGSIZE=`grep -A 0 LOGSIZE $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`
export DATASIZE=`grep -A 0 DATASIZE $CONFDIR/instalarT.conf | sed "s/\(^.*\)\(=.*\)\(=.*\)\(=.*\)/\2/g" | sed s/=//g`