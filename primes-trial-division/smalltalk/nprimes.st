Object subclass: #Benchmark
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Benchmark'!

!Benchmark methodsFor: 'findPrimes' !

findPrimes: n
    | count primes prime |
    count ← 3.
    primes ← OrderedCollection with: 2.
    [ primes size < n ] whileTrue: [
        primes detect: [ :prime | count \\ prime = 0 ] ifNone: [ primes add: count ].
        count ← count + 1. ].
    ↑ primes! !

"Transcript show: (Time millisecondsToRun: [
    Transcript show: ((Benchmark new) findPrimes: 100) printString; cr. ] )
  printString; cr."

