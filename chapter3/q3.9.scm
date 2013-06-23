; 3.9

; (define (factorial n)
;   (if (=  n 1)
;     1
;     (* n (factorial (- n 1)))))
; 
; (define (factorial n)
;   (fact-iter 1 1 n))

(define (fact-iter product counter max-count)
  ())

(use slib)
(require 'trace)
(define (factorial n)
  (define (factorial n)
    (if (=  n 1)
      1
      (* n (factorial (- n 1)))))
  (factorial n))

(trace factorial)

(print (factorial 5))
