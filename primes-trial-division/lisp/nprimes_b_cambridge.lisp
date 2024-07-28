(de divp (n list)
  (eq (catch isdiv (mapc list (lambda (p)
                     (cond ((zerop (remainder n p)) (throw isdiv t))))))
    t))

(de primes (n)
  (prog (count primes)
    (setq count 3)
    (setq primes (list 2))
    NEXT (cond ((lessp (length primes) n)
                (cond ((divp count primes) nil)
                      (t (nconc primes (list count)))))
               (t (return primes)))
    (setq count (plus count 1))
    (go NEXT)))
