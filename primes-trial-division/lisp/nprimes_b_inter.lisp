(DEFINEQ
  (DIVP (LAMBDA (N LIST)
        (PROG NIL (MAPC LIST '(LAMBDA (P)
                                  (COND ((ZEROP (REMAINDER N P)) (RETURN T)))))
                  (RETURN NIL))))

  (PRIMES (LAMBDA (N)
        (PROG (COUNT PRIMES)
            (SETQ COUNT 3)
            (SETQ PRIMES (LIST 2))
       NEXT (COND ((LESSP (LENGTH PRIMES) N)
                  (COND ((DIVP COUNT PRIMES) NIL)
                        (T (NCONC PRIMES (LIST COUNT)))))
            (T (RETURN PRIMES)))
        (SETQ COUNT (PLUS COUNT 1))
        (GO NEXT)))))

