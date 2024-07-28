         LET count& = 2
         LET found% = 0
         DIM primes&(100)
         WHILE found% < 100
           PRINT count&
           LET primes&(found%) = count&
           LET found% = found% + 1
NOTPRIME:  LET count& = count& + 1
           LET index% = 0
CALCULATE: IF count& MOD primes&(index%) > 0 THEN
             LET index% = index% + 1
             IF index% < found% GOTO CALCULATE
           ELSE
             GOTO NOTPRIME
           END IF
          WEND
