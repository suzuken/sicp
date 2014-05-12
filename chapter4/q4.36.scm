; q4.36

; この手続では任意のPythagoras三角形を生成する方法としては適切ではない

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))

; i + j < k にならなければならない

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (> (+ i j) k))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
