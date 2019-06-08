# log level of check routines (1..3) 
LEVEL = 1
TESTLOG = ./slachk.log

lib:
	$(MAKE) -C src

test:
	$(MAKE) -C chk
	sh exchk $(LEVEL) > $(TESTLOG)

clean:
	$(MAKE) -C src clean
	$(MAKE) -C chk clean
	-$(RM) $(TESTLOG)
