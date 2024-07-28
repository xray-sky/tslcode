65535 constant maxint
: #prime@    2 + cells + ;
: #prime     >r dup r> #prime@ @ ;
: #primes    dup 1 cells + @ ;
: #primes++  #primes 1+ over 1 cells + ! ;
: maxprimes  dup @ ;
: notprime   drop 0 ;
: divides?   mod 0= ;
: initialize dup >r here dup r> 2 + cells allot rot swap ! 0 over 1 cells + ! ;
: isprime!   dup . cr over #primes #prime@ ! #primes++ ;

: isprime?
  over #primes 0 do
    i #prime 2 pick swap divides?
      if notprime leave then
  loop ;

: primes
  decimal initialize cr 2 isprime! maxint 3 do
    i isprime? if isprime! else drop then
    maxprimes >r #primes r> = if leave then
  loop ;

