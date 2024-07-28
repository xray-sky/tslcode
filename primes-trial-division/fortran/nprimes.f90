       PROGRAM NPRIME
       PARAMETER (N=100)
C      PARAMETER (N=1000)
C      PARAMETER (N=10000)
       INTEGER FOUND, COUNT, I, PRIMES(N)
       
       FOUND = 0
       COUNT = 2   
       
  10   FOUND = FOUND + 1
       WRITE (*,*) COUNT
       PRIMES(FOUND) = COUNT
       COUNT = COUNT + 1
         
       I = 1
       IF (FOUND .LE. N) THEN
  20     IF (MOD(COUNT,PRIMES(I)) .EQ. 0) THEN
           COUNT = COUNT + 1
           I = 1
         ELSEIF (I .EQ. FOUND) THEN
           GOTO 10
         ENDIF
         I = I + 1
         GOTO 20  
       ELSE
         GOTO 30
       ENDIF
         
  30   STOP
       END PROGRAM NPRIME
