#!/bin/bash
PRGNAM=gnome3
TMP=/tmp
POOL=testing

PKGVERSION1=3.36
PKGVERSION2=3.38
ELOGIND=unofficial

SRCDIR1=$TMP/$PRGNAM/$PKGVERSION1
SRCDIR2=$TMP/$PRGNAM/$PKGVERSION2


rm -rf $TMP/$PRGNAM

mkdir -p $TMP/$PRGNAM

cd $TMP/$PRGNAM && mkdir $PKGVERSION1 $PKGVERSION2

cd $TMP/$PRGNAM/$PKGVERSION1 || exit 1
lftp -c 'open http://www.droplinegnome.org/files/3.36/x86_64 ; mirror testing' 

cd $TMP/$PRGNAM/$PKGVERSION1/$POOL || exit 1

upgradepkg --install-new --reinstall *.t?z || exit 1

cd $TMP/$PRGNAM/$PKGVERSION1/$POOL/$ELOGIND || exit 1

upgradepkg --install-new --reinstall *.t?z || exit 1

cd $TMP/$PRGNAM/$PKGVERSION2 || exit 1

lftp -c 'open http://www.droplinegnome.org/files/3.38/x86_64 ; mirror testing'

cd $TMP/$PRGNAM/$PKGVERSION2/$POOL || exit 1

upgradepkg --install-new --reinstall *.t?z || exit 1



exit 0







