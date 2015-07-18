; q1.23
(define (square n) (* n n))

(define (smallest-divisor n)
  (find-divisor n 2))

; (define (find-divisor n test-divisor)
  ; (cond ((> (square test-divisor) n) n)
        ; ((divides? test-divisor n) test-divisor)
        ; (else (find-divisor n (+ 1 test-divisor)))))

; use next to skip even numbers.
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (next n)
  (if (= n 2)
    3
    (+ n 2)))

;  テスト用素数
;  1009 1013 1019
;  10007 10009 10037
;  100003 100019 100043
;  1000003 1000033 1000037

; from https://sicp.g.hatena.ne.jp/n-oohira/?word=*[gauche]
(define (runtime)
  (use srfi-11)
  (let-values (((a b) (sys-gettimeofday)))
              (+ (* a 1000000) b)))

(define (timed-prime-test n)
  ; (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
    (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

;  1009 1013 1019
;  10007 10009 10037
;  100003 100019 100043
;  1000003 1000033 1000037
(print (timed-prime-test 1009))
(print (timed-prime-test 1013))
(print (timed-prime-test 1019))
(print (timed-prime-test 10007))
(print (timed-prime-test 10009))
(print (timed-prime-test 10037))
(print (timed-prime-test 100003))
(print (timed-prime-test 100019))
(print (timed-prime-test 100043))
(print (timed-prime-test 1000003))
(print (timed-prime-test 1000033))
(print (timed-prime-test 1000037))


; 前回
;
; 1000: 4
; 10000: 13
; 100000: 39
; 1000000: 124


; 今回（ある一回の例）
; 1009 *** 9#<undef>
; 1013 *** 3#<undef>
; 1019 *** 3#<undef>
; 10007 *** 9#<undef>
; 10009 *** 9#<undef>
; 10037 *** 9#<undef>
; 100003 *** 27#<undef>
; 100019 *** 26#<undef>
; 100043 *** 27#<undef>
; 1000003 *** 83#<undef>
; 1000033 *** 83#<undef>
; 1000037 *** 83#<undef>

; なぜか1009は遅いが、他のものについては幾分かはやくなっている

; 1000: 13 -> 9 
; 10000: 39 -> 27
; 100000: 124 -> 83

; >>> 13.0 / 9
; 1.4444444444444444
; >>> 39.0 / 27
; 1.4444444444444444
; >>> 124.0 / 83
; 1.4939759036144578
;
; おおよそ1.5倍ほど早くなっている
; 2倍早くならないのはnextでifによる比較を毎回しているから、だろうか。
