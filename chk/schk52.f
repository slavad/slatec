*DECK SCHK52
      SUBROUTINE SCHK52 (SNAME, EPS, THRESH, NOUT, KPRINT, FATAL, NIDIM,
     $   IDIM, NALF, ALF, NINC, INC, NMAX, INCMAX, A, AA, AS, X, XX, XS,
     $   Y, YY, YS, YT, G, Z)
C***BEGIN PROLOGUE  SCHK52
C***SUBSIDIARY
C***PURPOSE  Quick check for SSYR and SSPR.
C***LIBRARY   SLATEC (BLAS)
C***KEYWORDS  BLAS, QUICK CHECK SERVICE ROUTINE
C***AUTHOR  Du Croz, J. (NAG)
C           Hanson, R. J. (SNLA)
C***DESCRIPTION
C
C  Quick check for SSYR and SSPR.
C
C  Auxiliary routine for test program for Level 2 Blas.
C***REFERENCES  (NONE)
C***ROUTINES CALLED  LSE, LSERES, NUMXER, SMAKE2, SMVCH, SSPR, SSYR
C***REVISION HISTORY  (YYMMDD)
C   870810  DATE WRITTEN
C   910619  Modified to meet SLATEC code and prologue standards.  (BKS)
C***END PROLOGUE  SCHK52
C     .. Parameters ..
      REAL               ZERO, HALF, ONE
      PARAMETER          ( ZERO = 0.0, HALF = 0.5, ONE = 1.0 )
C     .. Scalar Arguments ..
      LOGICAL            FATAL
      REAL               EPS, THRESH
      INTEGER            INCMAX, KPRINT, NALF, NIDIM, NINC, NMAX, NOUT
      CHARACTER*6        SNAME
C     .. Array Arguments ..
      REAL               A( NMAX, NMAX ), AA( NMAX*NMAX ), ALF( NALF ),
     $                   AS( NMAX*NMAX ), G( NMAX ), X( NMAX ),
     $                   XS( NMAX*INCMAX ), XX( NMAX*INCMAX ),
     $                   Y( NMAX ), YS( NMAX*INCMAX ), YT( NMAX ),
     $                   YY( NMAX*INCMAX ), Z( NMAX )
      INTEGER            IDIM( NIDIM ), INC( NINC )
C     .. Local Scalars ..
      REAL               ALPHA, ALS, ERR, ERRMAX, TRANSL
      INTEGER            I, IA, IC, IN, INCX, INCXS, IX, J, JA, JJ, LAA,
     $                   LDA, LDAS, LJ, LX, N, NARGS, NC, NS, NERR
      LOGICAL            FTL, FULL, NULL, PACKED, RESET, UPPER
      CHARACTER*1        UPLO, UPLOS
      CHARACTER*2        ICH
C     .. Local Arrays ..
      REAL               W( 1 )
      LOGICAL            ISAME( 13 )
C     .. External Functions ..
      INTEGER            NUMXER
      LOGICAL            LSE, LSERES
      EXTERNAL           LSE, LSERES, NUMXER
C     .. External Subroutines ..
      EXTERNAL           SMAKE2, SMVCH, SSPR, SSYR
C     .. Intrinsic Functions ..
      INTRINSIC          ABS, MAX
C     .. Data statements ..
      DATA               ICH/'UL'/
C***FIRST EXECUTABLE STATEMENT  SCHK52
      FULL = SNAME( 3: 3 ).EQ.'Y'
      PACKED = SNAME( 3: 3 ).EQ.'P'
C     Define the number of arguments.
      IF( FULL )THEN
         NARGS = 7
      ELSE IF( PACKED )THEN
         NARGS = 6
      END IF
C
      NC = 0
      RESET = .TRUE.
      ERRMAX = ZERO
C
      DO 100 IN = 1, NIDIM
         N = IDIM( IN )
C        Set LDA to 1 more than minimum value if room.
         LDA = N
         IF( LDA.LT.NMAX )
     $      LDA = LDA + 1
C        Skip tests if not enough room.
         IF( LDA.GT.NMAX )
     $      GO TO 100
         IF( PACKED )THEN
            LAA = ( N*( N + 1 ) )/2
         ELSE
            LAA = LDA*N
         END IF
C
         DO 90 IC = 1, 2
            UPLO = ICH( IC: IC )
            UPPER = UPLO.EQ.'U'
C
            DO 80 IX = 1, NINC
               INCX = INC( IX )
               LX = ABS( INCX )*N
C
C              Generate the vector X.
C
               TRANSL = HALF
               CALL SMAKE2( 'GE', ' ', ' ', 1, N, X, 1, XX, ABS( INCX ),
     $                     0, N - 1, RESET, TRANSL )
               IF( N.GT.1 )THEN
                  X( N/2 ) = ZERO
                  XX( 1 + ABS( INCX )*( N/2 - 1 ) ) = ZERO
               END IF
C
               DO 70 IA = 1, NALF
                  ALPHA = ALF( IA )
                  NULL = N.LE.0.OR.ALPHA.EQ.ZERO
C
C                 Generate the matrix A.
C
                  TRANSL = ZERO
                  CALL SMAKE2( SNAME( 2: 3 ), UPLO, ' ', N, N, A, NMAX,
     $                        AA, LDA, N - 1, N - 1, RESET, TRANSL )
C
                  NC = NC + 1
C
C                 Save every datum before calling the subroutine.
C
                  UPLOS = UPLO
                  NS = N
                  ALS = ALPHA
                  DO 10 I = 1, LAA
                     AS( I ) = AA( I )
   10             CONTINUE
                  LDAS = LDA
                  DO 20 I = 1, LX
                     XS( I ) = XX( I )
   20             CONTINUE
                  INCXS = INCX
C
C                 Call the subroutine.
C
                  IF( FULL )THEN
                     CALL SSYR( UPLO, N, ALPHA, XX, INCX, AA, LDA )
                  ELSE IF( PACKED )THEN
                     CALL SSPR( UPLO, N, ALPHA, XX, INCX, AA )
                  END IF
C
C                 Check if error-exit was taken incorrectly.
C
                  IF (NUMXER(NERR) .NE. 0) THEN
                     IF (KPRINT .GE. 2) THEN
                       WRITE( NOUT, FMT = 9992 )
                     ENDIF
                     FATAL = .TRUE.
                  END IF
C
C                 See what data changed inside subroutines.
C
                  ISAME( 1 ) = UPLO.EQ.UPLOS
                  ISAME( 2 ) = NS.EQ.N
                  ISAME( 3 ) = ALS.EQ.ALPHA
                  ISAME( 4 ) = LSE( XS, XX, LX )
                  ISAME( 5 ) = INCXS.EQ.INCX
                  IF( NULL )THEN
                     ISAME( 6 ) = LSE( AS, AA, LAA )
                  ELSE
                     ISAME( 6 ) = LSERES( SNAME( 2: 3 ), UPLO, N, N, AS,
     $                            AA, LDA )
                  END IF
                  IF( .NOT.PACKED )THEN
                     ISAME( 7 ) = LDAS.EQ.LDA
                  END IF
C
C                 If data was incorrectly changed, report and return.
C
                  DO 30 I = 1, NARGS
                    IF (.NOT. ISAME( I )) THEN
                      FATAL = .TRUE.
                      IF (KPRINT .GE. 2) THEN
                        WRITE( NOUT, FMT = 9998 )I
                      ENDIF
                    ENDIF
  30              CONTINUE
C
                  IF( .NOT.NULL )THEN
C
C                    Check the result column by column.
C
                     IF( INCX.GT.0 )THEN
                        DO 40 I = 1, N
                           Z( I ) = X( I )
   40                   CONTINUE
                     ELSE
                        DO 50 I = 1, N
                           Z( I ) = X( N - I + 1 )
   50                   CONTINUE
                     END IF
                     JA = 1
                     DO 60 J = 1, N
                        W( 1 ) = Z( J )
                        IF( UPPER )THEN
                           JJ = 1
                           LJ = J
                        ELSE
                           JJ = J
                           LJ = N - J + 1
                        END IF
                        FTL = .FALSE.
                        CALL SMVCH( 'N', LJ, 1, ALPHA, Z( JJ ), LJ, W,
     $                              1, ONE, A( JJ, J ), 1, YT, G,
     $                              AA( JA ), EPS, ERR, FTL, NOUT,
     $                              .TRUE., KPRINT )
                        IF( FULL )THEN
                           IF( UPPER )THEN
                              JA = JA + LDA
                           ELSE
                              JA = JA + LDA + 1
                           END IF
                        ELSE
                           JA = JA + LJ
                        END IF
                        ERRMAX = MAX( ERRMAX, ERR )
                        IF (FTL) THEN
                          FATAL = .TRUE.
                          IF (KPRINT .GE. 3) THEN
                            WRITE( NOUT, FMT = 9995 )J
                            WRITE( NOUT, FMT = 9996 )SNAME
                            IF( FULL )THEN
                               WRITE( NOUT, FMT = 9993 )NC, SNAME,
     $                          UPLO, N, ALPHA, INCX,
     $                          LDA
                            ELSE IF( PACKED )THEN
                               WRITE( NOUT, FMT = 9994 )NC, SNAME,
     $                          UPLO, N, ALPHA, INCX
                            END IF
                          ENDIF
                        ENDIF
   60                CONTINUE
                  END IF
C
   70          CONTINUE
C
   80       CONTINUE
C
   90    CONTINUE
C
  100 CONTINUE
C
C     Report result.
C
      IF (.NOT. (FATAL)) THEN
        IF (KPRINT .GE. 3) THEN
          IF( ERRMAX.LT.THRESH )THEN
             WRITE( NOUT, FMT = 9999 )SNAME, NC
          ELSE
             WRITE( NOUT, FMT = 9997 )SNAME, NC, ERRMAX
          END IF
        ENDIF
      ENDIF
      RETURN
C
 9999 FORMAT( ' ', A6, ' PASSED THE COMPUTATIONAL TESTS (', I6, ' CALL',
     $      'S)' )
 9998 FORMAT( ' ******* FATAL ERROR - PARAMETER NUMBER ', I2, ' WAS CH',
     $      'ANGED INCORRECTLY *******' )
 9997 FORMAT( ' ', A6, ' COMPLETED THE COMPUTATIONAL TESTS (', I6, ' C',
     $      'ALLS)', /' ******* BUT WITH MAXIMUM TEST RATIO', F8.2,
     $      ' - SUSPECT *******' )
 9996 FORMAT( ' ******* ', A6, ' FAILED ON CALL NUMBER:' )
 9995 FORMAT( '      THESE ARE THE RESULTS FOR COLUMN ', I3 )
 9994 FORMAT( 1X, I6, ': ', A6, '(''', A1, ''',', I3, ',', F4.1, ', X,',
     $      I2, ', AP)                           .' )
 9993 FORMAT( 1X, I6, ': ', A6, '(''', A1, ''',', I3, ',', F4.1, ', X,',
     $      I2, ', A,', I3, ')                        .' )
 9992 FORMAT( ' ******* FATAL ERROR - ERROR-EXIT TAKEN ON VALID CALL *',
     $      '******' )
C
C     End of SCHK52.
C
      END
