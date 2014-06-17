; q4.42

(define amb '())
(define (require p)
  (if (not p) (amb)))

(define (member obj lst)
  (cond ((null? lst) false)
        ((eq? obj (car lst)) lst)
        (else (member obj (cdr lst)))))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (and a b)
  (if a (if b true false) false))
(define (or a b)
  (if a true (if b true false)))
(define (xor a b)
  (or (and a (not b)) (and (not a) b)))

(define (liar)
  (let ((betty (amb 1 2 3 4 5))
        (ethel (amb 1 2 3 4 5))
        (joan (amb 1 2 3 4 5))
        (kitty (amb 1 2 3 4 5))
        (mary (amb 1 2 3 4 5)))
    (require
      (distinct? (list betty ethel joan kitty mary)))
    (require (xor (= kitty 2) (= betty 3)))
    (require (xor (= ethel 1) (= joan 2)))
    (require (xor (= joan 3) (= ethel 5)))
    (require (xor (= kitty 2) (= mary 4)))
    (require (xor (= mary 4) (= betty 1)))
    (list (list 'betty betty)
          (list 'ethel ethel)
          (list 'joan joan)
          (list 'kitty kitty)
          (list 'mary mary))))

(liar)

;;; Starting a new problem
;;; ;;; Amb-Eval value:
;;; ((betty 3) (ethel 5) (joan 2) (kitty 1) (mary 4))
;;;
;
; となった
