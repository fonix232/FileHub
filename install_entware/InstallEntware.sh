#!/bin/sh

source ./EntwareTools.sh

createImage 32 $BUILD_IMG
mountImage $BUILD_IMG $BUILD_ROOT

setupFolders $BUILD_ROOT
setupBusybox $BUILD_ROOT
setupChroot $BUILD_ROOT

installEntware $BUILD_ROOT

createImage 128 $ENTWARE_IMG
mountImage $ENTWARE_IMG $ENTWARE_ROOT
copyEntware $BUILD_ROOT $ENTWARE_ROOT

destroyChroot $BUILD_ROOT
umount $BUILD_ROOT
umount $ENTWARE_ROOT

cp $ENTWARE_IMG $ROOT/.vst/extern_package

rm -rf $BUILD_ROOT $ENTWARE_ROOT $BUILD_IMG
