; q1.8
; (x/y^2 + 2y) / 3
(define (improve guess x)
    (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))
