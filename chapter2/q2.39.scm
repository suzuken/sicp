(load "./s2.2.scm")


(define (reverse-right sequence)
    (fold-right (lambda (x y) (cons (cadr x) y)) nil sequence))

(define (reverse-left sequence)
    (fold-left (lambda (x y) (cons y x)) nil sequence))

(use gauche.test)
(test* "reverse-right" (list 3 2 1) (reverse-right (list 1 2 3)))
(test* "reverse-left" (list 3 2 1) (reverse-left (list 1 2 3)))
