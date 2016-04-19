CC      := $(CROSS_COMPILE)gcc
BCM5389 := bcm5389
OBJS    := $(BCM5389).o 
CFLAGS  := -O2 -s -w -Wall -Wstrict-prototypes

.PHONY: all install clean 

all: $(BCM5389)
$(BCM5389): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

$(BCM5389).o: $(BCM5389).c
	$(CC) $(CFLAGS) -o $@ -c $<

install:
	@cp -a $(BCM5389) $(SYSROOTDIR)/usr/sbin/$(BCM5389)
	@cp -a $(BCM5389) $(SYSROOTDIR)/usr/sbin/bcm5396
	@cp -ar usr/local $(SYSROOTDIR)/usr

clean:
	@rm -f *.o $(BCM5389)
