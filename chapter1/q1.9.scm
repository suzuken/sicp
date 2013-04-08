; 1.9
; 再帰プロセス
(define (plus1 a b)
    (if (= a 0)
      b
      (inc (plus1 (dec a) b))))

; 線形反復プロセス
(define (plus2 a b)
    (if (= a 0)
      b
      (plus2 (dec a) (inc b))))

(define (dec x)
    (- x 1))

(define (inc x)
    (+ x 1))

(use gauche.test)
(test* "1+3" 4 (plus1 1 3))
(test* "1+3" 4 (plus2 1 3))

(use slib)
(require 'trace)
(trace plus1)
(print (plus1 3 2))
; CALL plus1 3 2
;   CALL plus1 2 2
;     CALL plus1 1 2
;       CALL plus1 0 2
;       RETN plus1 2
;     RETN plus1 3
;   RETN plus1 4
; RETN plus1 5
; 5
(trace plus2)
(print (plus2 3 2))
; CALL plus2 3 2
;   CALL plus2 2 3
;     CALL plus2 1 4
;       CALL plus2 0 5
;       RETN plus2 5
;     RETN plus2 5
;   RETN plus2 5
; RETN plus2 5
; 5
; 
