 10 DIM primes(100)
 20 index=1
 30 count=2
 40 found=1
 50 primes(index)=count
 60 PRINT primes(index)
 70 REPEAT
 80 count=count+1
 90 REPEAT
100 v=(count MOD primes(index))
110 index=index+1
120 UNTIL v=0 OR index>found
130 IF v=0 THEN GOTO 170
140 PRINT count
150 primes(index)=count
160 found=found+1
170 index=1
180 UNTIL found=100
