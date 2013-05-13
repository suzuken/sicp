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

(use gauche.test)
(test* "called" 0 (s 'how-many-call?))
(test* "10^2" 10 (s 100))
(test* "called" 1 (s 'how-many-call?))
(s 'reset-count)
(test* "reset" 0 (s 'how-many-call?))
(s 100)
(s 101)
(test* "called" 2 (s 'how-many-call?))
