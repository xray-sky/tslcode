1   GOTO 10
5   c = c + 1
6   GOTO 50
10  DIM primes(999)
20  primes(0) = 2
25  PRINT primes(0)
30  c = 3
40  FOR found = 1 TO 999
50  FOR index = 0 TO (found - 1)
60  IF MOD(c,primes(index)) = 0 THEN GOTO 5
70  NEXT index
80  PRINT c
90  PRIMES(found) = c
100 c = c + 1
110 NEXT found
120 END
