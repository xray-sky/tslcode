* Find some prime numbers by trial division
  DIM PRIMES(1000)
  COUNT=2 ; FOUND=0
  LOOP
    PRINT COUNT
    INDEX=0 ; FOUND=FOUND+1 ; PRIMES(FOUND)=COUNT ; COUNT=COUNT+1
  UNTIL FOUND = 1000 DO
    LOOP
      INDEX=INDEX+1
    UNTIL INDEX = FOUND DO
      IF MOD(COUNT, PRIMES(INDEX)) = 0 THEN COUNT=COUNT+1 ; INDEX=0
    REPEAT
  REPEAT
 END
