; q4.35

; ambの超循環評価器がないと動かないけど、まぁ動くよね、っていうものをとりあえず書く

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))

; 2つの与えられた限界の間の整数を返す手続き
(define (an-integer-between low high)
  (if (< low high)
    (amb low (an-integer-between (+ low 1) high))
    high))

; requireをつかって書ける
(define (an-integer-between low high)
  (require (< low high))
  (amb low (an-integer-between (+ low 1) high)))

(an-integer-between 1 3)
(an-integer-between 1 5)
