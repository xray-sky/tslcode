FORTH-83
: cells      4 * ;
: #prime@    2+ cells + ;
: #prime     >R DUP R> #prime@ @ ;
: #primes    DUP 1 cells + @ ;
: #primes++  #primes 1+ OVER 1 cells + ! ;
: maxprimes  DUP @ ;
: notprime   DROP 0 ;
: divides?   MOD 0= ;
: initialize DUP >R HERE DUP R> 2+ cells ALLOT ROT SWAP ! 0 OVER 1 cells + ! ;
: isprime!   DUP . CR OVER #primes #prime@ ! #primes++ ;

: isprime?
  OVER #primes 0 DO
    i #prime 2 PICK SWAP divides?
      IF notprime LEAVE THEN
  LOOP ;

: primes
  DECIMAL initialize CR 2 isprime! 2 BEGIN
    1+ DUP >R isprime? IF isprime! ELSE DROP THEN
    maxprimes >R #primes R> = R> SWAP UNTIL ;

