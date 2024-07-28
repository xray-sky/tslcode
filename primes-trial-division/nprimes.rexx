/* FIRST n PRIMES */
PARSE ARG n
count = 2
primes. = 0
DO i = 1 TO n
    SAY count
    primes.i = count
    count = count + 1
    j = 1
    DO WHILE primes.j > 0
        IF count // primes.j = 0 THEN DO
            count = count + 1
            j = 1
            ITERATE
        END
        j = j + 1
    END
END

