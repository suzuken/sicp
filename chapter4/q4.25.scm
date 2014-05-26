; q4.25
(define (try a b)
  (if (= a 0) 1 b))

(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
    (* n (factorial (- n 1)))
    1))
