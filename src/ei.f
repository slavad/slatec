*DECK EI
      FUNCTION EI (X)
C***BEGIN PROLOGUE  EI
C***PURPOSE  Compute the exponential integral Ei(X).
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C5
C***TYPE      SINGLE PRECISION (EI-S, DEI-D)
C***KEYWORDS  EI FUNCTION, EXPONENTIAL INTEGRAL, FNLIB,
C             SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C EI calculates the single precision exponential integral, Ei(X), for
C positive single precision argument X and the Cauchy principal value
C for negative X.  If principal values are used everywhere, then, for
C all X,
C
C    Ei(X) = -E1(-X)
C or
C    E1(X) = -Ei(-X).
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  E1
C***REVISION HISTORY  (YYMMDD)
C   770401  DATE WRITTEN
C   891115  Modified prologue description.  (WRB)
C   891115  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  EI
C***FIRST EXECUTABLE STATEMENT  EI
      EI = -E1(-X)
C
      RETURN
      END
