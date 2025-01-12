KERNEL_VERSION=6.12.8
BUSYBOX_VERSION=1.37.0


mkdir -p src
cd src

    # KERNEL
    KERNEL_MAJOR=$(echo $KERNEL_VERSION | sed 's/\([0-9]\+\)[^0-9].*/\1/')
    wget https://www.kernel.org/pub/linux/kernel/v$KERNEL_MAJOR.x/linux-$KERNEL_VERSION.tar.xz
    tar -xf linux-$KERNEL_VERSION.tar.xz
    cd linux-$KERNEL_VERSION
        make defconfig
        make -j8 || exit
    cd ..


    # BUSYBOX
    wget https://www.busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
    tar -xf busybox-1.37.0.tar.bz2
    cd busybox-$BUSYBOX_VERSION
        make defconfig
        sed 's/^.*CONFIG_STATIC.*$/CONFIG_STATIC=y/g' -i .config
        make CC=musl-gcc -j8 busybox || exit
    cd ..

cd ..


cp src/linux-$KERNEL_VERSION/arch/x86_64/boot/bzImage ./

# INITRD
mkdir initrd
cd initrd

    mkdir -p bin dev proc sys etc
    cd bin 

        cp ../../src/busybox-$BUSYBOX_VERSION/busybox ./

        for prog in $(./busybox --list); do
            ln -s /bin/busybox ./$prog
        done
    cd ..    


    echo '#!/bin/sh' > init
    echo 'mount -t proc proc /proc' >> init
    echo 'mount -t sysfs sysfs /sys' >> init
    echo 'mount -t devtmpfs udev /udev' >> init
    echo 'sysctl -w kernel.printk="2 4 1 7"' >> init
    
    mknod /dev/ttys0 c 4 64
    setsid sh -c 'exec sh < /dev/ttys0 > /dev/ttys0 2>&1'


    chmod -R 777 ./

    find . | cpio -o -H newc > ../initrd.img


    # QEMU

    qemu-system-x86_64 -kernel bzImage -initrd initrd.img

cd ..