(de divp (n list)
  (eq (catch 'ISDIV (mapc list #'(lambda (p)
                     (cond ((zerop (remainder n p)) (throw 'ISDIV T))))))
    T))

(de primes (n)
  (prog (count primes)
    (setq count 3)
    (setq primes (list 2))
    NEXT (cond ((< (length primes) n)
                (cond ((divp count primes) nil)
                      (T (nconc primes (list count)))))
               (T (return primes)))
    (setq count (+ count 1))
    (go NEXT)))

