# Makefile fragment for Accton AS4600_54T

# Vendor's version number can be defined here.
# Available variables are 'VENDOR_VERSION' and 'UBOOT_IDENT_STRING'.
# e.g.,
# VENDOR_VERSION = .00.01
# UBOOT_IDENT_STRING = 1.4.0.1
UBOOT_IDENT_STRING = 3.0.1.8


ONIE_ARCH ?= powerpc-softfloat

VENDOR_REV ?= 0

# Translate hardware revision to ONIE hardware revision
ifeq ($(VENDOR_REV),0)
  MACHINE_REV = 0
else
  $(warning Unknown VENDOR_REV '$(VENDOR_REV)' for MACHINE '$(MACHINE)')
  $(error Unknown VENDOR_REV)
endif

EXT3_4_ENABLE = yes

UBOOT_MACHINE = AS4600_54T
KERNEL_DTB = as4600_54t.dtb

# Vendor ID -- IANA Private Enterprise Number:
# http://www.iana.org/assignments/enterprise-numbers
VENDOR_ID = 259

#-------------------------------------------------------------------------------
#
# Local Variables:
# mode: makefile-gmake
# End:
