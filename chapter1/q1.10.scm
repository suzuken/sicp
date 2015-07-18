(define (A x y)
    (cond ((= y 0) 0)
          ((= x 0) (* 2 y))
          ((= y 1) 2)
          (else (A (- x 1)
                   (A x (- y 1))))))
; y=0 => 0
; x=0 => 2y
; y=1 => 2
;
; A(x-1, A(x, y-1))

(print (A 1 10))
; 1024
(print (A 2 4))
; 65536
(print (A 3 3))
; 65536

(define (f n) (A 0 n))
; A(0, n)すなわちx=0なので f(x) = 2x

(define (g n) (A 1 n))
; A(1, n)展開すると
; g(n) = A(0, A(1, n-1))
; = 2 * A(1, n-1)
; ...
; = 2 * 2 * .... A(1, 1)
; = 2^n

(define (h n) (A 2 n))
; h(n) = A(2, n)
; = A(1, A(2, n-1))
; = 2^(A(2, n-1))
; = 2^(A(1, A(2, n-2)))
; = 2^2^(A(2, n-2))
; = ...
; = 

; gosh> (h 1)
; 2
; gosh> (h 2)
; 4
; gosh> (h 3)
; 16
; gosh> (h 4)
; 65536

(define (k n) (* 5 n n))
