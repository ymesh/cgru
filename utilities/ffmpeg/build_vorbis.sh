#!/bin/bash

libogg=$PWD/libogg
cd libogg-1.3.3
export LDFLAGS="-B/usr/lib/gold-ld/"
if [ ! -z "$1" ]; then
   ./configure --help
else
   ./configure --prefix=$libogg --enable-shared=
   make $@ && make install $@
fi

cd ..

libvorbis=$PWD/libvorbis
cd libvorbis-1.3.5
export CFLAGS="-B/usr/lib/gold-ld/ -I$libogg/include"
export LDFLAGS="-B/usr/lib/gold-ld/ -L$libogg/lib -L$libogg/lib64"
if [ ! -z "$1" ]; then
   ./configure --help
else
   ./configure --prefix=$libvorbis --enable-shared=
   make $@ && make install $@
fi

cd ..

libtheora=$PWD/libtheora
cd libtheora-1.1.1
export CFLAGS="-B/usr/lib/gold-ld/ -I$libogg/include"
export LDFLAGS="-B/usr/lib/gold-ld/ -L$libogg/lib -L$libogg/lib64"
# examples/png2theora.c -- replace png_sizeof by sizeof
# https://gitlab.xiph.org/xiph/theora/-/commit/7288b539c52e99168488dc3a343845c9365617c8
if [ ! -z "$1" ]; then
   ./configure --help
else
   ./configure --prefix=$libtheora --enable-shared=
   make $@ && make install $@
fi
