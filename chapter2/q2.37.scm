(load "./s2.2.scm")

; load accumurate-n
(load "./q2.36.scm")

; 2.37
;
; 行列をこのように表現
; ((1 2 3 4)
;  (5 6 7 8)
;  (9 10 11 12))
;
(define mat (list (list 1 2) (list 3 4)))
(define vec (list 1 1))

; 内積
; 転置は考慮してないけど。
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (matrix-*-vector cols row)) m)))

(use gauche.test)
(test* "(1 2 3) * (1 2 3)T = 14" 14 (dot-product (list 1 2 3) (list 1 2 3)))
(test* "((1 2) (3 4)) * (1 2)T = (5 11)" (list 5 11) (matrix-*-vector (list (list 1 2) (list 3 4)) (list 1 2)))
(test* "transpose((1 2) (3 4)) = ((1 3)(2 4))" (list (list 1 3) (list 2 4)) (transpose (list (list 1 2) (list 3 4))))
(test* "((1 2) (3 4)) * ((1 2) (3 4)) = ((7 10) (15 22))" (list (list 7 10) (list 15 22)) (matrix-*-matrix mat mat))
