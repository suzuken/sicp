; q1.22
(define (square n) (* n n))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

; from https://sicp.g.hatena.ne.jp/n-oohira/?word=*[gauche]
(define (runtime)
  (use srfi-11)
  (let-values (((a b) (sys-gettimeofday)))
              (+ (* a 1000000) b)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
    (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes m n)
  (if (= (remainder m 2) 0)
    (search-for-primes (+ m 1) n)
    (cond ((< m n)
           (timed-prime-test m)
           (search-for-primes (+ m 2) n)))))

(search-for-primes 1000 1020)
(newline)
(search-for-primes 10000 10040)
(newline)
(search-for-primes 100000 100050)
(newline)
(search-for-primes 1000000 1000050)
(newline)
(search-for-primes 10000000 10000200)
; 結果として
;
; 1000: 4
; 10000: 13
; 100000: 39
; 1000000: 124

; とかかっている。
;
; >>> 13.0 / 4
; 3.25
; >>> 39 / 13
; 3
; >>> 124.0 / 39
; 3.1794871794871793
;
; >>> math.sqrt(10)
; 3.1622776601683795
;
; なので、おおよそ等しい。

; 実験としては何度も試行した実行時間の平均をとる必要がある
; 実行時間の絶対数の大きいものほど、ばらつく傾向にあった
