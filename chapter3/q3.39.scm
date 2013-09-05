; q3.39
;
; 混ざるバージョンと比較して
(define x 10)

(parallel-execute (lambda () (set! x (* x x)))
                  (lambda () (set! x (+ x 1))))

; これだとどうなるか、という問題
(define x 10)

(define s (make-serializer))

(parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))
                  (lambda () (set! x (+ x 1))))

; (* x x)のところが直列化されているのがわかる
; 掛けてる間にxが変わらない、という認識になるので、
; 101, 121, 11, 100のパターンはありそう
