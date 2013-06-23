; 3.6

; s3.1.2より
(define a 3)
(define b 5)
(define m 13)
(define random-init 8)
(define (rand-update x)
  (modulo (+ (* a x) b ) m))

(define rand
  (let ((x random-init))
    (lambda ()
      (set! x (rand-update x))
      x)))

;3 1 8 3 1 8 3 1 8 3 ...

;resetできるようにする
