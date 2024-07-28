 1 GOTO 10
 5 c = c + 1
 6 GOTO 50
 10 DIM primes(99)
 20 primes(0) = 2
 25 DISP primes(0)
 30 c = 3
 40 FOR found = 1 TO 99
 50 FOR i = 0 TO (found - 1)
 60 IF (c MOD primes(i)) = 0 THEN GOTO 5
 70 NEXT i
 80 DISP c
 90 primes(found) = c
 100 c = c + 1
 110 NEXT found
 120 END
