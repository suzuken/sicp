(define (remainder n d)
  (if (< n d)
    n
    (remainder (- n 1))))
