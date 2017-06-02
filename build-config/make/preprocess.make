#-------------------------------------------------------------------------------
#
#  Copyright (C) 2017 david_yang <david_yang@accton.com>
#
#  SPDX-License-Identifier:     GPL-2.0
#
#-------------------------------------------------------------------------------
#
# This is a makefile fragment that defines the preprocesses in build system
#

PRECHECK_KERNEL_STAMP	= $(STAMPDIR)/precheck-kernel
PRECHECK_SYSROOT_STAMP	= $(STAMPDIR)/precheck-sysroot
ifeq ($(UBOOT_ENABLE),yes)
  PRECHECK_UBOOT_STAMP	= $(STAMPDIR)/precheck-uboot
endif
PRECHECK_STAMP		= $(STAMPDIR)/precheck

PREBUILD_SYSROOT_STAMP	= $(STAMPDIR)/prebuild-sysroot
ifeq ($(UBOOT_ENABLE),yes)
  PREBUILD_UBOOT_STAMP	= $(STAMPDIR)/prebuild-uboot
endif
PREBUILD_STAMP		= $(STAMPDIR)/prebuild

$(PRECHECK_STAMP): $(PRECHECK_KERNEL_STAMP) $(PRECHECK_SYSROOT_STAMP) $(PRECHECK_UBOOT_STAMP)
	$(Q) touch $@

$(PREBUILD_STAMP): $(PREBUILD_SYSROOT_STAMP) $(PREBUILD_UBOOT_STAMP)
	$(Q) touch $@

#-------------------------------------------------------------------------------
#
# Local Variables:
# mode: makefile-gmake
# End:
