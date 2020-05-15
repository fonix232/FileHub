#!/bin/sh

export ROOT=$(pwd)

export BUILD_ROOT=$ROOT/build
export ENTWARE_ROOT=$ROOT/entware

export BUILD_IMG=$ROOT/build.img
export ENTWARE_IMG=$ROOT/extern_package

export TOOLCHAIN=$ROOT/toolchain


# Creates an empty EXT2 image of the given size
# Usage: createImage size path
# size: size of image in MB
createImage () {
    printf "Creating $1MB EXT2 image $2. This might take a while!\n"
    [[ -f $2 ]] && rm -rf $2
    touch $2
    head -c $(($1 * 1024 * 1024)) /dev/zero > $2
    $TOOLCHAIN/busybox mkfs.ext2 -F $2 >/dev/null 2>&1
    printf "Image $2 created\n"
}

# Mounts the specified file to the specified path
# Usage: mountImage image.file mount/path
mountImage () {
    printf "Mounting $1 to $2\n"
    if [[ -f $2 ]] 
    then
        umount $2 >/dev/null 2>&1
        rm -rf $2 >/dev/null 2>&1
    fi

    mkdir -p $2 >/dev/null 2>&1
    mount $1 $2 >/dev/null 2>&1
    printf "Mounted $2\n"
}

# Creates a minimal folder structure for Entware
# Usage: setupFolders path/to/root
setupFolders() {
    printf "Creating folder structure...\n"
    for folder in bin dev etc usr/bin usr/local/bin opt proc tmp
    do
        mkdir -p $1/$folder >/dev/null 2>&1
        printf "\t $folder created\n"
    done

    cp /etc/resolv.conf $1/etc/resolv.conf >/dev/null 2>&1
    printf "DNS Resolver configured\n"
}

# Creates the appropriate busybox symlinks
# Usage: setupBusybox path/to/root
setupBusybox() {
    printf "Setting up Busybox...\n"
    cp $TOOLCHAIN/busybox $1/bin/busybox >/dev/null 2>&1
    chmod 0777 $1/bin/busybox >/dev/null 2>&1
    for COMMAND in sh wget mkdir ls chmod grep cat ln rm mount umount
    do
        ln -s /bin/busybox $1/bin/$COMMAND >/dev/null 2>&1
    done
}

setupChroot () {
    printf "Setting up chroot environment...\n"
    chroot $1 /bin/busybox mount -t proc procfs /proc >/dev/null 2>&1
    mount -o bind /dev $1/dev >/dev/null 2>&1
}

# Executes command in given chroot
# Usage: executeInChroot path/to/chroot command paremeter1 parameter2
executeInChroot() {
    chroot ${@}
}

executeInEntware() {
    chroot $1 /opt/bin/opkg $2 $3
}

# Installs Entware to the selected chroot
# Usage: installEntware path/to/root
installEntware () {
    
    printf "Downloading Entware installer\n"
    executeInChroot $1 wget http://pkg.entware.net/binaries/mipsel/installer/installer.sh >/dev/null 2>&1
    executeInChroot $1 chmod 0777 installer.sh >/dev/null 2>&1

    printf "Running Entware installer\n"
    executeInChroot $1 /installer.sh >/dev/null 2>&1

    printf "Installing Busybox...\n"
    executeInEntware $1 install busybox >/dev/null 2>&1
    printf "Installing entware-opt...\n"
    executeInEntware $1 install entware-opt >/dev/null 2>&1
    printf "Installing Dropbear...\n"
    executeInEntware $1 install dropbear >/dev/null 2>&1

    printf "Entware base is ready!\n"
}

destroyChroot() {
    printf "Destroying chroot in $1\n"
    umount $1/dev
    umount $1/proc
}

# Usage: copyEntware path/to/origin path/to/target
# e.g.: copyEntware $BUILD_ROOT $ENTWARE_ROOT
copyEntware() {
    printf "Creating final Entware image...\n"
    tar -C $1/opt/ -cpf - . | tar -C $2 -xf - 2>&1 
}

copyRCLocal() {
    printf "Adding Entware loader...\n"
    cp $TOOLCHAIN/rc.local /etc/rc.local
    etc_tools p
}
