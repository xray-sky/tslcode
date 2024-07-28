(define (last-pair liszt)
  (let lp ((liszt liszt))
    (let ((tail (cdr liszt)))
      (if (pair? tail) (lp tail) liszt))))

(define (div? n liszt)
  (call-with-current-continuation
     (lambda (exit)
        (map (lambda (p) (if (zero? (remainder n p)) (exit #t))) liszt)
        #f)))

(define (primes n)
  (letrec ((primes (list 2)))
     (do ((count 3 (+ 1 count))) ((= (length primes) n) primes)
        (if (div? count primes)
          #t
          (set-cdr! (last-pair primes) (list count))))))
