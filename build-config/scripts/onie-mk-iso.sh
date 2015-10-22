#!/bin/sh

#-------------------------------------------------------------------------------
#
#  Copyright (C) 2015 Curt Brune <curt@cumulusnetworks.com>
#  Copyright (C) 2015 david_yang <david_yang@accton.com>
#
#  SPDX-License-Identifier:     GPL-2.0
#
#-------------------------------------------------------------------------------
#
# Helper script to make an .ISO image that is bootable in the
# following scenarios:
#
# - legacy BIOS CD-ROM drive
# - legacy BIOS USB thumb drive
#
# This script takes a lot of arguments ...

set -e

# Check verbosity flag
[ "$Q" != "@" ] && set -x

# Sanity check the number of arguments
[ $# -eq 9 ] || {
    echo "ERROR: $0: Incorrect number of arguments"
    exit 1
}
RECOVERY_KERNEL=$1
RECOVERY_INITRD=$2
RECOVERY_DIR=$3
MACHINE_CONF=$4
RECOVERY_CONF_DIR=$5
GRUB_HOST_LIB_I386_DIR=$6
GRUB_HOST_BIN_I386_DIR=$7
RECOVERY_XORRISO_OPTIONS=$8
RECOVERY_ISO_IMAGE=$9

# Sanity check the arguments
[ -r "$RECOVERY_KERNEL" ] || {
    echo "ERROR: Unable to read recovery kernel image: $RECOVERY_KERNEL"
    exit 1
}
[ -r "$RECOVERY_INITRD" ] || {
    echo "ERROR: Unable to read recovery initrd image: $RECOVERY_INITRD"
    exit 1
}
[ -d "$RECOVERY_DIR" ] || {
    echo "ERROR: Recovery work directory does not exist: $RECOVERY_DIR"
    exit 1
}
[ -r "$MACHINE_CONF" ] || {
    echo "ERROR: Unable to read machine configuration file: $MACHINE_CONF"
    exit 1
}
[ -d "$RECOVERY_CONF_DIR" ] || {
    echo "ERROR: Unable to read recovery config directory: $RECOVERY_CONF_DIR"
    exit 1
}
[ -r "${GRUB_HOST_LIB_I386_DIR}/biosdisk.mod" ] || {
    echo "ERROR: Does not look like valid GRUB i386-pc library directory: $GRUB_HOST_LIB_I386_DIR"
    exit 1
}
[ -x "${GRUB_HOST_BIN_I386_DIR}/grub-mkimage" ] || {
    echo "ERROR: Does not look like valid GRUB i386-pc bin directory: $GRUB_HOST_BIN_I386_DIR"
    exit 1
}
[ -r "$RECOVERY_XORRISO_OPTIONS" ] || {
    echo "ERROR: Unable to read xorriso options file: $RECOVERY_XORRISO_OPTIONS"
    exit 1
}

# Make sure a few tools are available
XORRISO=$(which xorriso) || {
    echo "ERROR: unable to find xorriso binary"
    exit 1
}
MKDOSFS=$(which mkdosfs) || {
    echo "ERROR: unable to find mkdosfs binary"
    exit 1
}
MCOPY=$(which mcopy) || {
    echo "ERROR: unable to find mcopy binary"
    exit 1
}

RECOVERY_ISO_SYSROOT="$RECOVERY_DIR/iso-sysroot"
RECOVERY_CORE_IMG="$RECOVERY_DIR/core.img"
RECOVERY_ELTORITO_IMG="$RECOVERY_ISO_SYSROOT/boot/eltorito.img"
RECOVERY_EMBEDDED_IMG="$RECOVERY_DIR/embedded.img"

# Start clean
rm -rf $RECOVERY_ISO_SYSROOT $RECOVERY_ISO_IMAGE
mkdir -p $RECOVERY_ISO_SYSROOT

# Add kernel and initrd to ISO sysroot
cp $RECOVERY_KERNEL $RECOVERY_ISO_SYSROOT/vmlinuz
cp $RECOVERY_INITRD $RECOVERY_ISO_SYSROOT/initrd.xz

# Create the grub.cfg from a template
mkdir -p $RECOVERY_ISO_SYSROOT/boot/grub
sed -e "s/<CONSOLE_SPEED>/$CONSOLE_SPEED/g"           \
    -e "s/<CONSOLE_DEV>/$CONSOLE_DEV/g"               \
    -e "s/<GRUB_DEFAULT_ENTRY>/$GRUB_DEFAULT_ENTRY/g" \
    -e "s/<CONSOLE_PORT>/$CONSOLE_PORT/g"             \
    "$MACHINE_CONF" $RECOVERY_CONF_DIR/grub-iso.cfg   \
    > $RECOVERY_ISO_SYSROOT/boot/grub/grub.cfg

# Populate .ISO sysroot with i386-pc GRUB modules
mkdir -p $RECOVERY_ISO_SYSROOT/boot/grub/i386-pc
(cd $GRUB_HOST_LIB_I386_DIR && cp *mod *lst $RECOVERY_ISO_SYSROOT/boot/grub/i386-pc)

# Generate legacy BIOS eltorito format GRUB image
$GRUB_HOST_BIN_I386_DIR/grub-mkimage \
    --format=i386-pc \
    --directory=$GRUB_HOST_LIB_I386_DIR \
    --prefix=/boot/grub \
    --output=$RECOVERY_CORE_IMG \
    part_msdos part_gpt iso9660 biosdisk
cat $GRUB_HOST_LIB_I386_DIR/cdboot.img $RECOVERY_CORE_IMG > $RECOVERY_ELTORITO_IMG

# Generate legacy BIOS MBR format GRUB image
cat $GRUB_HOST_LIB_I386_DIR/boot.img $RECOVERY_CORE_IMG > $RECOVERY_EMBEDDED_IMG

cd $RECOVERY_DIR && $XORRISO -outdev $RECOVERY_ISO_IMAGE \
    -map $RECOVERY_ISO_SYSROOT / \
    -options_from_file $RECOVERY_XORRISO_OPTIONS
