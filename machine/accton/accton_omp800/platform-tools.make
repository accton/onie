#-------------------------------------------------------------------------------
#
#  Copyright (C) 2016 david_yang <david_yang@accton.com>
#
#  SPDX-License-Identifier:     GPL-2.0
#
#-------------------------------------------------------------------------------
#
# This is a makefile fragment that defines the build of chassis utilities
#

CHASSIS_DIR		= $(MACHINEROOT)/accton_omp800/chassis

CHASSIS_BUILD_STAMP	= $(STAMPDIR)/chassis-build
CHASSIS_INSTALL_STAMP	= $(STAMPDIR)/chassis-install
CHASSIS_STAMP		= $(CHASSIS_BUILD_STAMP) \
			  $(CHASSIS_INSTALL_STAMP)

PACKAGES_INSTALL_STAMPS += $(CHASSIS_INSTALL_STAMP)

PHONY += chassis chassis-build chassis-install chassis-clean

ifndef MAKE_CLEAN
CHASSIS_NEW_FILES = $(shell test -d $(CHASSIS_DIR) && \
		      test -f $(CHASSIS_BUILD_STAMP) && \
		      find -L $(CHASSIS_DIR) -newer $(CHASSIS_BUILD_STAMP) \
			-type f -print -quit )
endif

chassis: $(CHASSIS_STAMP)
chassis-build: $(CHASSIS_BUILD_STAMP)
$(CHASSIS_BUILD_STAMP): $(CHASSIS_NEW_FILES) | $(DEV_SYSROOT_INIT_STAMP)
	$(Q) rm -f $@ && eval $(PROFILE_STAMP)
	$(Q) echo "====  Building chassis utilities ===="
	$(Q) PATH='$(CROSSBIN):$(PATH)'				\
	    $(MAKE) -C $(CHASSIS_DIR)				\
		CROSS_COMPILE=$(CROSSPREFIX)			\
		all
	$(Q) touch $@

chassis-install: $(CHASSIS_INSTALL_STAMP)
$(CHASSIS_INSTALL_STAMP): $(CHASSIS_BUILD_STAMP) | $(SYSROOT_INIT_STAMP)
	$(Q) rm -f $@ && eval $(PROFILE_STAMP)
	$(Q) echo "==== Installing chassis utilities in $(SYSROOTDIR) ===="
	$(Q) PATH='$(CROSSBIN):$(PATH)'				\
		$(MAKE) -C $(CHASSIS_DIR)			\
		SYSROOTDIR=$(SYSROOTDIR)			\
		CROSS_COMPILE=$(CROSSPREFIX)			\
		install
	$(Q) touch $@

USERSPACE_CLEAN += chassis-clean
chassis-clean:
	$(Q) PATH='$(CROSSBIN):$(PATH)'				\
		$(MAKE) -C $(CHASSIS_DIR) clean
	$(Q) rm -f $(CHASSIS_STAMP)
	$(Q) echo "=== Finished making $@ for $(PLATFORM)"

#-------------------------------------------------------------------------------
#
# Local Variables:
# mode: makefile-gmake
# End:
