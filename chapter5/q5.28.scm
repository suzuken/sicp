; 5.28
;
; 評価器が末尾再帰的にしないようにして、5.26と5.27を再度実験する
;
; $ gosh q5.28-ecloop.scm

; 5.26の反復的なfactorial
;;; EC-Eval input:
(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
  (iter 1 1))
(total-pushes = 3 maximum-depth = 3)

;;; EC-Eval value:
ok

;;; EC-Eval input:
(factorial 1)
(total-pushes = 70 maximum-depth = 17)

;;; EC-Eval value:
1

;;; EC-Eval input:
(factorial 2)
(total-pushes = 107 maximum-depth = 20)

;;; EC-Eval value:
2

;;; EC-Eval input:
(factorial 3)
(total-pushes = 144 maximum-depth = 23)

;;; EC-Eval value:
6

;;; EC-Eval input:
(factorial 4)
(total-pushes = 181 maximum-depth = 26)

;;; EC-Eval value:
24

;;; EC-Eval input:
(factorial 5)
(total-pushes = 218 maximum-depth = 29)

;;; EC-Eval value:
120



; 5.27の再帰的なfactorial
;
;
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
(total-pushes = 18 maximum-depth = 11)

;;; EC-Eval value:
1

;;; EC-Eval input:
(factorial 2)
(total-pushes = 52 maximum-depth = 19)

;;; EC-Eval value:
2

;;; EC-Eval input:
(factorial 3)
(total-pushes = 86 maximum-depth = 27)

;;; EC-Eval value:
6

;;; EC-Eval input:
(factorial 4)
(total-pushes = 120 maximum-depth = 35)

;;; EC-Eval value:
24

;;; EC-Eval input:
(factorial 5)
(total-pushes = 154 maximum-depth = 43)

;;; EC-Eval value:
120


; 結果をまとめると
;
; 反復的
; プッシュ回数: 37n + 33
; 最大深さ: 3n + 14
;
; 再帰的
; プッシュ回数: 34n - 16
; 最大深さ: 8n + 3
;
; となり、反復的なfactorialの実装でも最大深さが線形に増加することが確認できた。
