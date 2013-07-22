; q3.16

(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ (count-pairs (car x))
       (count-pairs (cdr x))
       1)))

(define x (list 'a 'b))
(print (count-pairs '(x x x)))

; 3つなのに4つの例
(define z1 (list 1 2 3))
(set-car! z1 (cddr z1))
(print (count-pairs z1))
;-> 4

(define z2 (list 1 2 3))
(set-car! z2 (cdr z2))
(set-car! (cdr z2) (cddr z2))
(print (count-pairs z2))
;-> 7


