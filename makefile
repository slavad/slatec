# log level of check routines (1..3) 
LEVEL = 1
TESTLOG = ./slachk.log

all:
	cd src; make

install:
	cd src; make install

clean_src:
	cd src; make clean

clean_chk:
	cd chk; make clean

test:
	$(MAKE) -C chk
	sh exchk $(LEVEL) > $(TESTLOG)
