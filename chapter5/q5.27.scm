; 5.27
;
; 全問のfactorialと比べる問題
;
; まず実際にシミュレートしてみる

;;; EC-Eval input:
(define (factorial n)
  (if (= n 1)
      1
      (* (factorial (- n 1)) n)))

(total-pushes = 3 maximum-depth = 3)

;;; EC-Eval value:
ok

;;; EC-Eval input:
(factorial 1)
(total-pushes = 16 maximum-depth = 8)

;;; EC-Eval value:
1

;;; EC-Eval input:
(factorial 2)
(total-pushes = 48 maximum-depth = 13)

;;; EC-Eval value:
2

;;; EC-Eval input:
(factorial 3)
(total-pushes = 80 maximum-depth = 18)

;;; EC-Eval value:
6

;;; EC-Eval input:
(factorial 4)
(total-pushes = 112 maximum-depth = 23)

;;; EC-Eval value:
24

;;; EC-Eval input:
(factorial 5)
(total-pushes = 144 maximum-depth = 28)

;;; EC-Eval value:
120


; 前問より
; 反復的階乗では
;
; 最大深さ: 10
; プッシュ回数: 35n + 29
;
; 再帰的階乗では
;
; 最大深さ: 5n + 3
; プッシュ回数: 32n - 16
;
; となる。
;
; すなわち、再帰的階乗は必要なスタックが線形に増加する
