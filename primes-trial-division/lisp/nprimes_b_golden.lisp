(defun mod (x y) (- x (* y (/& x y))))

(defun divp (n list)
  (eq (catch 'ISDIV (mapc #'(lambda (p)
                   (cond ((zerop (mod n p)) (throw 'ISDIV T)))) list))
               T))

(defun primes (n)
  (prog (count primes)
    (setq count 3)
    (setq primes (list 2))
    NEXT (cond ((< (length primes) n)
                (cond ((divp count primes) nil)
                      (T (nconc primes (list count)))))
               (T (return primes)))
    (setq count (+ count 1))
    (go NEXT)))

