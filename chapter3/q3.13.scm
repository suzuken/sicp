; q3.13

; q3.12より
(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z (make-cycle (list 'a 'b 'c)))

;(print z)

(define hoge (list 'a 'b 'c))

(print hoge)

(print (car hoge))
(print (cdr hoge))
(print (car (cdr hoge)))
(print (cdr (cdr hoge)))
(print (car (cdr (cdr hoge))))

(print (last-pair hoge))
