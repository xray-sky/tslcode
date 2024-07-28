Class Benchmark :Object
[
findPrimes: n    | count primes prime |
    count <- 3.
    primes <- List new.
    primes addLast: 2.
    [ primes size < n ] whileTrue: [
        primes detect: [ :prime | count \\ prime = 0 ] ifAbsent: [ primes addLast: count ].
        count <- count + 1. ].
    ^primes
]

