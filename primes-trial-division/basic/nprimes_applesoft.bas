1  GOTO 10
5 COUNT = COUNT + 1
6  GOTO 50
10  DIM PRIMES(99)
20 PRIMES(0) = 2
25  PRINT PRIMES(0)
30 COUNT = 3
40  FOR FOUND = 1 TO 99
50  FOR INDEX = 0 TO (FOUND - 1)
60 V = COUNT / PRIMES(INDEX)
65  IF ( V =  INT (V)) THEN  GOTO 5
70  NEXT INDEX
80  PRINT COUNT
90 PRIMES(FOUND) = COUNT
100 COUNT = COUNT + 1
110  NEXT FOUND
120  END
