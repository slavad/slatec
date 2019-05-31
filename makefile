# log level of check routines (1..3) 
LEVEL = 1
TESTLOG = ./slachk.log

all:
	cd src; make

install:
	cd src; make install

clean_src:
	cd src; make clean

clean_test:
	cd chk; make clean

clean: clean_src clean_src

test:
	$(MAKE) -C chk
	sh exchk $(LEVEL) > $(TESTLOG)
