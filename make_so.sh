#!/bin/bash

compile () {
    ARCH=$1
    OS=$2
    HOST="gcc-$ARCH-$OS"
    echo "Compiling for $ARCH/$OS on $HOST"
    INSTALL=target/classes/$OS/$ARCH
    rsync -r --delete jni $HOST:
    rsync -r --delete src/main/native $HOST:
    ssh $HOST "gcc -shared -fPIC -O3 -DZSTD_LEGACY_SUPPORT=4 -I/usr/include -I./jni -I./native -I./native/common -I./native/legacy -std=c99 -o libzstd-jni.so native/*.c native/legacy/*.c native/common/*.c native/compress/*.c native/decompress/*.c native/dictBuilder/*.c"
    mkdir -p $INSTALL
    scp $HOST:libzstd-jni.so $INSTALL
}

compile amd64   linux
compile i386    linux
compile ppc64   linux
compile ppc64le linux
compile ppc64   aix
compile aarch64 linux
compile sparc64 linux
compile mips64  linux
