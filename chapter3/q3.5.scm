; 3.5
;
; モンテカルロ積分
(use slib)
(load "/usr/local/slib/random")
(use srfi-27) ; random-real

; 範囲から乱数を返す
(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range)))) ; (+ low (random range))))

; from s.3.1.2
; experimentをtrials回試す
(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
            (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

; 2点間距離
(define (dist x y)
  (abs (- x y)))

; 領域の面積
(define (area x1 x2 y1 y2)
  (* (dist x1 x2) (dist x1 y2)))

; (define x (random-in-range x1 x2))
; (define y (random-in-range y1 y2))

; 引数は問題で指定されている
; 述語P(x,y)は(x,y)が領域の中の点なら真となり、外なら偽となる
; 述語P, 四角形の上限と下限のx1, x2, y1 およびy2, 見積もりを出すために実行する試みの回数 trials
; estimate-integralでは領域の面積にmonte-carloをかけるので、面積の近似値がでる
(define (estimate-integral P x1 x2 y1 y2 trials)
  (*
    (area x1 x2 y1 y2)
    (monte-carlo trials
                 (P (random-in-range x1 x2) (random-in-range y1 y2)))))

(define (square x)
  (* x x))
; 手続きPには「その点が領域に入っているか」というのを渡せば良い、はず
;
(use gauche.test)
; 円に入っているか
(define (in-this-circle? x y)
  (>= 9 (+ (square (- x 5)) (square (- y 7)))))

(test* "in-this-circle?" #t (in-this-circle? 5 7))

(test* "circle" 50
       (estimate-integral
         in-this-circle? 2 8 4 10 100))

