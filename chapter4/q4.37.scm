; 4.37

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
        (hsq (* high high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (* i i) (* j j))))
        (require (>= hsq ksq))
        (let ((k (sqrt ksq)))
          (require (integer? k))
          (list i j k))))))

; 全体で見ると変わらない？
;
; もともとは単純にlowからhighの整数を並べるので、lowからhighに並んでいる整数の個数をnとすると、
;
; 最大: 3n^2
; 最小: 1
;
; この手続だとありえないものをどんどんはじいていく
;
; i^2 + j^2 <= k^2 を弾くことができる
;
; 最大: 
