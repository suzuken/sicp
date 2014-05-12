; q4.36

; この手続では任意のPythagoras三角形を生成する方法としては適切ではない

(define amb '())
(define (require p)
  (if (not p) (amb)))

(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

; これは動かない
(define (a-pythagorean-triple-between n)
  (let ((i (an-integer-starting-from n)))
    (let ((j (an-integer-starting-from n)))
      (let ((k (an-integer-starting-from n)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))

; 適切ではない理由
; an-integer-starting-fromを利用すると、kがずっと大きくなってしまい、計算が終わらない

; freezeする
(a-pythagorean-triple-between 1 10)

; i + j < k にならなければならない
(define (a-pythagorean-triple-between n )
  (let ((i (an-integer-starting-from n)))
    (let ((j (an-integer-between i n)))
      (let ((k (an-integer-between j (+ i j))))
        (require (<= k (+ i j)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (amb (list i j k) (a-pythagorean-triple-between (+ n 1)))))))

; 以下を利用する
(define (a-sized-pythagorean-triple n)
  (let ((i (an-integer-between 1 n)))
    (require (< i n))
    (let ((j (an-integer-between i n)))
      (require (< j n))
      (require (= (+ (* i i) (* j j))
                  (* n n)))
      (list i j n))))
(a-sized-pythagorean-triple 10)

(define (a-pythagorean-triple)
  (amb '() (a-sized-pythagorean-triple
             (an-integer-starting-from 1))))

