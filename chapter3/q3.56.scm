; q3.56
; 2つの順序付けられたストリームを繰り返位sなしに一つの順序付けられたストリームに混ぜ合わせる手続きmerge
;
; 順序付けられていることが前提なので、2つのストリームのそれぞれのstream-carの大小を比較して、小さい方を頭につけることを繰り返している
(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
          (let ((s1car (stream-car s1))
                (s2car (stream-car s2)))
            (cond ((< s1car s2car)
                   (cons-stream s1car (merge (stream-cdr s1) s2)))
                  ((> s1car s2car)
                   (cons-stream s2car (merge s1 (stream-cdr s2))))
                  (else
                    (cons-stream s1car
                                 (merge (stream-cdr s1)
                                        (stream-cdr s2)))))))))


