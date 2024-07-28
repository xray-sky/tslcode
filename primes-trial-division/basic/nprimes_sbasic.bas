VAR count, found, index = INTEGER
DIM INTEGER primes(100)

count = 2
found = 0
index = 0

WHILE found < 100 DO BEGIN
    PRINT count
    primes(found) = count
    found = found + 1
5   count = count + 1
    index = 0
    REPEAT BEGIN
        IF (count-(count/primes(index))*primes(index)) = 0 THEN GOTO 5
        index = index + 1
    END UNTIL index = found
END
