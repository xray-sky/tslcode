10   dim primes(99)
20   index=0
30   count=2
40   found=0
50   while found<100
60   print count
70   primes(index)=count
80   found=found+1
90   count=count+1
100  index=0
110  while index<found
120  v=(count mod primes(index))
130  if v=0 then index=found+1 else index=index+1
140  wend
150  if index>found then goto 90
160  wend
