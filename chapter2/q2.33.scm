(load "s2.2.scm");

; 2.33
(define (my-map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

;置き換え
; (my-map square (list 1 2))
; (accumulate (lambda (x y) (cons (square x) y)) nil (list 1 2))
; ((lambda (x y) (cons (square x) y)) (car (list 1 2))
;     (accumulate (lambda (x y) (cons (square x) y)) nil (cdr (list 1 2))))
; ((lambda (x y) (cons (square x) y)) 1
;     (accumulate (lambda (x y) (cons (square x) y)) nil (list 2)))
; ((lambda (x y) (cons (square x) y)) 1
;     ((lambda (x y) (cons (square x) y) 2 nil)))
; ((lambda (x y) (cons (square x) y)) 1
;     (cons(square 2) nil))
; ((lambda (x y) (cons (square x) y)) 1 (list 4))
; (cons (square 1) (list 4))
; (list 1 4)
;
; つまり、
;
; (accumulate op iniital sequence)
; (op s1
;   (op s2
;     (op s3
;     ......
;       (op sn
;           ini))))))))))
;
; 的な感じになる
;
; ※ consのcdrがlistのものがlist！

; For my reference
;(define (append list1 list2)
;  (if (null? list1)
;    list2
;    (cons (car list1) (append (cdr list1) list2))))

(define (my-append seq1 seq2)
  (accumulate cons seq2 seq1))

; (print (append (list 1 2 3)(list 4 5 6)))
; (print (my-append (list 1 2 3)(list 4 5 6)))

;置き換え
; (my-append (list 1 2) (list 3 4))
; (accumulate cons (list 3 4) (list 1 2))
; (cons (car (list 1 2)) (accumulate cons (list 3 4) (cdr (list 1 2))))
; (cons 1 (accumulate cons (list 3 4) (list 2)))
; (cons 1 (accumulate cons (list 3 4) (list 2)))
; (cons 1 (cons 2 (accumulate cons (list 3 4) nil)))
; (cons 1 (cons 2 (list 3 4)))
; (list 1 2 3 4)

(define (my-length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

; (print (length (list 2 3 4 5)))
; (print (my-length (list 2 3 4 5)))

