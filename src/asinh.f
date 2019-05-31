*DECK ASINH
      FUNCTION ASINH (X)
C***BEGIN PROLOGUE  ASINH
C***PURPOSE  Compute the arc hyperbolic sine.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C4C
C***TYPE      SINGLE PRECISION (ASINH-S, DASINH-D, CASINH-C)
C***KEYWORDS  ARC HYPERBOLIC SINE, ASINH, ELEMENTARY FUNCTIONS, FNLIB,
C             INVERSE HYPERBOLIC SINE
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C ASINH(X) computes the arc hyperbolic sine of X.
C
C Series for ASNH       on the interval  0.          to  1.00000D+00
C                                        with weighted error   2.19E-17
C                                         log weighted error  16.66
C                               significant figures required  15.60
C                                    decimal places required  17.31
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  CSEVL, INITS, R1MACH
C***REVISION HISTORY  (YYMMDD)
C   770401  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  ASINH
      DIMENSION ASNHCS(20)
      LOGICAL FIRST
      SAVE ALN2, ASNHCS, NTERMS, XMAX, SQEPS, FIRST
      DATA ALN2 /0.6931471805 5994530942E0/
      DATA ASNHCS( 1) /   -.1282003991 1738186E0 /
      DATA ASNHCS( 2) /   -.0588117611 89951768E0 /
      DATA ASNHCS( 3) /    .0047274654 32212481E0 /
      DATA ASNHCS( 4) /   -.0004938363 16265361E0 /
      DATA ASNHCS( 5) /    .0000585062 07058557E0 /
      DATA ASNHCS( 6) /   -.0000074669 98328931E0 /
      DATA ASNHCS( 7) /    .0000010011 69358355E0 /
      DATA ASNHCS( 8) /   -.0000001390 35438587E0 /
      DATA ASNHCS( 9) /    .0000000198 23169483E0 /
      DATA ASNHCS(10) /   -.0000000028 84746841E0 /
      DATA ASNHCS(11) /    .0000000004 26729654E0 /
      DATA ASNHCS(12) /   -.0000000000 63976084E0 /
      DATA ASNHCS(13) /    .0000000000 09699168E0 /
      DATA ASNHCS(14) /   -.0000000000 01484427E0 /
      DATA ASNHCS(15) /    .0000000000 00229037E0 /
      DATA ASNHCS(16) /   -.0000000000 00035588E0 /
      DATA ASNHCS(17) /    .0000000000 00005563E0 /
      DATA ASNHCS(18) /   -.0000000000 00000874E0 /
      DATA ASNHCS(19) /    .0000000000 00000138E0 /
      DATA ASNHCS(20) /   -.0000000000 00000021E0 /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  ASINH
      IF (FIRST) THEN
         NTERMS = INITS (ASNHCS, 20, 0.1*R1MACH(3))
         SQEPS = SQRT (R1MACH(3))
         XMAX = 1.0/SQEPS
      ENDIF
      FIRST = .FALSE.
C
      Y = ABS(X)
      IF (Y.GT.1.0) GO TO 20
C
      ASINH = X
      IF (Y.GT.SQEPS) ASINH = X*(1.0 + CSEVL (2.*X*X-1., ASNHCS,NTERMS))
      RETURN
C
 20   IF (Y.LT.XMAX) ASINH = LOG (Y + SQRT(Y**2+1.))
      IF (Y.GE.XMAX) ASINH = ALN2 + LOG(Y)
      ASINH = SIGN (ASINH, X)
C
      RETURN
      END
