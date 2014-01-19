(use util.stream)
; originally from katzchang
; q3.70-3.72まで

(debug-print-width #f)

(define the-empty-stream stream-null)
(define (stream-null? s) (null? s))
;(define-macro (cons-stream a b)
;  `(stream-cons ,a ,b))
(define-macro (cons-stream a b)
  `(cons ,a (delay ,b)))
;(define (stream-car stream) (car stream))
;(define (stream-cdr stream) (force (cdr stream)))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))
(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))
(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))
(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))
(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define (divisible? x y) (= (remainder x y) 0))

(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7)))
                 integers))
; #?=(stream-ref no-sevens 100)

(define (fibgen a b)
  (cons-stream a (fibgen b (+ a b))))
(define fibs (fibgen 0 1))
; #?=(stream-ref fibs 100)


(define (sieve stream)
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter
           (lambda (x)
             (not (divisible? x (stream-car stream))))
           (stream-cdr stream)))))

(define primes (sieve (integers-starting-from 2)))
; #?=(stream-ref primes 50)


(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

(define (take s n)
  (if (= n 0)
      '()
      (cons (stream-car s) (take (stream-cdr s) (- n 1)))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

; #?=(take (pairs integers integers) 10)

; (define (pairs s t)
;   (interleave
;    (stream-map (lambda (x) (list (stream-car s) x))
;                t)
;    (pairs (stream-cdr s) (stream-cdr t))))

;#?=(take (pairs integers integers) 10)

(define evens
  (stream-map (^[x] (* x 2))
              integers))

; #?=(take evens 10)

(define odds
  (stream-map (^[x] (- (* x 2) 1))
              integers))

; #?=(take odds 10)

; #?=(take (interleave odds evens) 10)

(define (interleave3 s1 s2 s3)
  (if (stream-null? s1)
      (interleave s2 s3)
      (cons-stream (stream-car s1)
                     (interleave3 s2 s3 (stream-cdr s1)))))

; #?=(take (interleave3 integers integers integers) 10)

(define (triples s t u)
  (cons-stream
   (list (stream-car s) (stream-car t) (stream-car u))
   (interleave3
     (stream-map (^[x] (list (stream-car s) (stream-car t) x))
                 (stream-cdr u))
     (stream-map (^[pair] (cons (stream-car s) pair))
                 (pairs (stream-cdr t) (stream-cdr u)))
     (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

; #?=(take (triples integers integers integers) 100)

; q3.69
(define (pythagoras s t u)
  (stream-filter (^[triple]
                   (let ((i (car triple))
                         (j (cadr triple))
                         (k (caddr triple)))
                     (= (+ (* i i) (* j j)) (* k k))))
                 (triples s t u)))

; #?=(take (pythagoras integers integers integers) 3)

; q3.70
; 重み関数を定義
;
; q3.56より
; 2つの順序付けられたストリームを繰り返位sなしに一つの順序付けられたストリームに混ぜ合わせる手続きmerge
; このmergeは単純にs1とs2のcarを比べてどちらか大きい方を先頭にして繰り返し、対のstreamを生成する
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

; #?=(take (merge integers evens) 10)

; *69より 対は配列の行を右へ、並びを下へ進むに従い、対の重みが増えるよう、要求するとのこと

; mergeのs1carとs2carを比べている部分がweightの比較になる
; iとjは対のストリームであることが前提
(define (merge-weighted i j weight)
  (cond ((stream-null? (stream-car i)) j)
        ((stream-null? (stream-car j)) i)
        (else
          (let ((icar (stream-car i))
                (jcar (stream-car j)))
            (if (<= (weight icar) (weight jcar))
              (cons-stream icar (merge-weighted (stream-cdr i) j weight))
              (cons-stream jcar (merge-weighted (stream-cdr j) i weight)))))))

(define (sum-weight pair)
  (+ (car pair) (cadr pair)))
#?=(take (merge-weighted (pairs integers integers) (pairs evens evens) sum-weight) 10)
; #?-    ((1 1) (1 2) (2 2) (1 3) (2 3) (1 4) (3 3) (1 5) (2 4) (1 6))
; いい感じっぽい
; 既にこれが正の整数のストリームになっていた

; streamを与えたら対のストリームにして返す
; これが普通のpairs
;(define (pairs s t)
;  (cons-stream
;   (list (stream-car s) (stream-car t))
;   (interleave
;    (stream-map (lambda (x) (list (stream-car s) x))
;                (stream-cdr t))
;    (pairs (stream-cdr s) (stream-cdr t)))))
;
; weighted-pairsはここに2つのストリームの重みを計算する手続きを追加して、重みによって順序付けするようにする
; streamを与えたら、重みを計算していい感じの順番にしつつ、対のストリームにして返す
; i,jの1番目と2番目をweightで計算して比較して、良い方を先につける。
(define (weighted-pairs i j weight)
  (cons-stream
    (list (stream-car i) (stream-car j))
    (merge-weighted (stream-map (^[x] (list (stream-car i) x)) (stream-cdr j))
                    (weighted-pairs (stream-cdr i) (stream-cdr j) weight)
                    weight)))

(define sum-weight (lambda (x) (+ (car x) (cadr x))))
;3.70a
;#?=(take (pairs integers integers) 10)
;#?=(take (pairs evens evens) 10)
;#?=(take (merge-weighted (pairs integers integers) (pairs evens evens) sum-weight) 10)
;
; gaucheの実装はsicpで想定しているcons-streamとちょっと違うっぽい
; stream-carとろうとしているのに下記の例でexitしているような挙動に見える
;(define a (cons-stream 1 (exit)))
;(print (stream-car a))
;
#?=(take (weighted-pairs integers integers sum-weight) 10)
;#?=(display-stream (weighted-pairs integers integers sum-weight))
;#?=(display-stream (merge-weighted (stream-map (^[x] (list (stream-car integers) x)) integers)
;                    (pairs integers integers)
;                    sum-weight))

;3.70b
(define (twothreefive-weight pair)
  (+ (* (car pair) 2) (* (cadr pair) 3) (* (car pair) (cadr pair) 5)))

(define (twothreefive-filter x)
  (and (not (divisible? x 2))
       (not (divisible? x 3))
       (not (divisible? x 5))))

#?=(take (weighted-pairs (stream-filter twothreefive-filter integers)
                         (stream-filter twothreefive-filter integers) twothreefive-weight) 30)
(define hoge-stream
  (weighted-pairs (stream-filter twothreefive-filter integers)
                  (stream-filter twothreefive-filter integers) twothreefive-weight))
#?=(take (stream-map (^[x] (twothreefive-weight x)) hoge-stream) 30)
; あってるっぽい

; q3.71
; 3乗和
(define (cubic-weight pair)
  (let ((i (car pair))
        (j (cadr pair)))
    (+ (* i i i) (* j j j))))

; 3乗和によって並べられたストリーム
(define cubic-stream (weighted-pairs integers integers cubic-weight))
#?=(take cubic-stream 5)

; 対の重みが前と後ろで等しいこと
; ラマヌジャンストリーム
(define (ramanujan-stream s)
  (let ((s1car (stream-car s))
        (s2car (stream-car (stream-cdr s))))
    (if (= (cubic-weight s1car) (cubic-weight s2car))
       (cons-stream s1car (ramanujan-stream (stream-cdr s)))
       (ramanujan-stream (stream-cdr s)))))

#?=(take (ramanujan-stream cubic-stream) 5)
#?=(take (stream-map (^[x] (cubic-weight x)) (ramanujan-stream cubic-stream)) 30)

; q3.72
; 3通りの異なる方法で2つの平方数の和として書けるすべての数のストリームを生成せよ
; 上のラマヌジャンストリームっぽく書くと
(define (square-weight pair)
  (let ((i (car pair))
        (j (cadr pair)))
    (+ (* i i) (* j j))))

(define square-stream (weighted-pairs integers integers square-weight))
#?=(take square-stream 5)

(define (suzuken-stream s)
  (let ((s1car (stream-car s))
        (s2car (stream-car (stream-cdr s)))
        (s3car (stream-car (stream-cdr (stream-cdr s)))))
    (if (= (square-weight s1car) (square-weight s2car) (square-weight s3car))
       (cons-stream (list s1car s2car s3car (square-weight s1car)) (suzuken-stream (stream-cdr s)))
       (suzuken-stream (stream-cdr s)))))
#?=(take (suzuken-stream square-stream) 5)
; #?=(take (stream-map (^[x] (square-weight x)) (suzuken-stream square-stream)) 5)

; ちなみに3乗だと
(define (suzuken-super-stream s)
  (let ((s1car (stream-car s))
        (s2car (stream-car (stream-cdr s)))
        (s3car (stream-car (stream-cdr (stream-cdr s)))))
    (if (= (cubic-weight s1car) (cubic-weight s2car) (cubic-weight s3car))
       (cons-stream (list s1car s2car s3car (cubic-weight s1car)) (suzuken-super-stream (stream-cdr s)))
       (suzuken-super-stream (stream-cdr s)))))
#?=(take (suzuken-super-stream cubic-stream) 1)
; 計算終わらなかった
