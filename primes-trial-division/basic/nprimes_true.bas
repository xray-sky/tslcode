LET count=2
LET found=0
DIM primes(0 TO 99)
CALL isprime(primes(found),count,found)
DO WHILE found < 100
    LET count=count+1
    LET index=0
    DO
        LET v=MOD(count,primes(index))
        LET index=index+1
    LOOP UNTIL v=0 OR index=found
    IF index=found THEN CALL isprime(primes(index),count,found)
LOOP
END

SUB isprime(p,c,f)
    PRINT c
    LET p=c
    LET f=f+1
END SUB
