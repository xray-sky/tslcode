       SUB primes (n AS INTEGER)
         count = 2
         found = 0
         index = 0
         DIM prime(n - 1)
         DO WHILE found < n
           PRINT count
           prime(found) = count
           found = found + 1
NOTPRIME:  count = count + 1
           index = 0
           DO
             v = count MOD prime(index)
             index = index + 1
           LOOP UNTIL v = 0 OR index = found
           IF v = 0 THEN GOTO NOTPRIME
         LOOP
       END SUB
