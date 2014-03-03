; q4.19

; Ben
; 定義されていないものは上のスコープを見に行く
;
; a = 1
; b = 1 + 10
; a = 5
; f = 11 + 5 = 16
(let ((a 1))
  (define (f x)
    (define b (+ a x))  ; a=1
    (define a 5)
    (+ a b))
  #?=(f 10))

; Alyssa
; define bのあとに同じスコープでaを見るはず
; なのでdefine bのところでundefinedのエラーになる
(let ((a 1))
  (define (f x)
    (define b (+ a x))  ; a=undefined
    (define a 5)
    (+ a b))
  #?=(f 10))
;
; Eva
; aとbの定義が同時ならbの評価にaの値5を使うべき
; a = 5
; b = 5 + 10
; f = 5 + 15 = 20
(let ((a 1))
  (define (f x)
    (define b (+ a x))  ; a=5
    (define a 5)
    (+ a b))
  #?=(f 10))

; defineを見たか否かを保持する必要がある
; ただし、参照が循環すると大変そう
