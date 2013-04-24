; q3.2


(define (make-monitored f)
  (let ((count 0))
    (define (call f m)
      (set! count (+ count 1))
      (f m))
    (define (mf m)
      (cond ((eq? m 'how-many-call?) count)
            ((eq? m 'reset-count) (set! count 0))
            ((number? m) (call f m))
            (else (set! f m))))
    mf))

; 初期化
(define s (make-monitored sqrt))
;(print (s 100))
;-> 10
;(print (s 'how-many-call?))
;-> 1
;(print (s 'reset-count))
;-> 0
;(print (s 100))
;-> 10
;(print (s 100))
;-> 10
;(print (s 'how-many-call?))
;-> 2
