(load "./s2.2.scm")

; 2.38 fold-right and left
(define (fold-right op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (fold-right op initial (cdr sequence)))))

(define (fold-left op initial sequence)
    (define (iter result rest)
      (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
    (iter initial sequence))

(use gauche.test)
(test* "fold-right" 3/2 (fold-right / 1 (list 1 2 3)))
(test* "fold-left" 1/6 (fold-left / 1 (list 1 2 3)))

; fold-rightでもfold-leftでも値がおなじになる <=> 交換法則が成り立つ
;
; (op x y) = (op y x)
