(load "./s2.2.scm")

; 2.34
(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))

; (print (horner-eval 2 (list 1 3 0 5 0 1)))
; ->79
;
; (x=2) 1 + 3x + 5x^3 + x^5
; 1 + x * ( high )
; 1 + x * ( 3 + x * ( high ))
; 1 + x * ( 3 + x * ( 0 + x * ( high )))
; 1 + x * ( 3 + x * ( 0 + x * ( 5 + x * ( high ))))
; 1 + x * ( 3 + x * ( 0 + x * ( 5 + x * ( 0 + x * ( high )))))
; 1 + x * ( 3 + x * ( 0 + x * ( 5 + x * ( 0 + x * ( 1  + x * (0))))))

; TESTTING

(use gauche.test)
(test* "horner-eval f(3) when f(x) = x + 1" 4 (horner-eval 3 (list 1 1)))
(test* "horner-eval f(2) when f(x) = x^5 + 3x^4 + 5x^2 + 1" 79 (horner-eval 2 (list 1 3 0 5 0 1)))
