#!/bin/bash

prefix=$PWD/faac

cd faac-1.28

export LDFLAGS="$LDFLAGS -B/usr/lib/gold-ld/"

if [ ! -z "$1" ]; then
   ./configure --help
   exit
else
   # -Wall -Wno-narrowing ??? how to set ??? 
   ./configure --prefix=$prefix --enable-shared=
   python ../patch_faac.py
   make $@ && make install  $@
fi
