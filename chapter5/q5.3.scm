; q5.3

; 下のNewton法を使った平方根の計算をおこなう計算機を設計する
(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (squrare guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
      guess
      (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

; 算術演算を使って展開する
;
; 1.0から始める
; 1.0の2乗とxの差が0.001より小さくなったら十分と見なす
; もしまだ大きければ、improveする
; improveはguessとx/guessの平均をもとめ、これを再度プロセスを繰り返す
; つまり
;
; ((1.0 + (x/1.0)) / 2)
; 
; を繰り返す

; sqrt計算機のそれぞれの版
; つまり、算術演算をつかってこれらを計算機として展開するということ

; absは基本演算として使えることにした
(controller
  test-enough
    (assign guess (const 1.0))
    (assign t4 (op *) (reg guess) (reg guess))
    (assign t5 (op -) (reg t4) (reg x))
    (assign t6 (op abs) (reg t5))
    (test (op <) (reg t6) (const 0.001))
    (branch (label sqrt-done))
    (assign t1 (op /) (reg guess) (reg x))
    (assign t2 (op *) (reg t1))
    (assign t3 (op /) (reg t2) (const 2))
    (assign guess (reg t3))
    (goot (label test-enough))
  sqrt-done)

