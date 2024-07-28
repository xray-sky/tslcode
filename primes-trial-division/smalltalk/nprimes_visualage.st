Object subclass: #Benchmark
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''!

!Benchmark publicMethods !

findPrimes: n
    "Transcript show: (Time millisecondsToRun: [ Transcript show: ((Benchmark new) findPrimes: 10000) printString; cr. ]) printString; cr."
    | count primes |
    count := 3.
    primes := OrderedCollection with: 2.
    [ primes size < n ] whileTrue: [
        primes detect: [ :prime | count \\ prime = 0 ] ifNone: [ primes add: count ].
        count := count + 1. ].
    ^primes! !

Benchmark initializeAfterLoad!

