; 1.1
10
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))
(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(if (and (> b a) (< b (* a b)))
  b
  a)
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
(+ 2 (if (> b a) b a))
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))

; 1.2
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))
; (print (/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7))))

; 1.3
(define (square x)
  (* x x))

(define (sum-of-squares-of-two-larger-numbers x y z)
  (cond
    ((and (= x y) (= y z)) (+ (square x) (square y)))
    ((and (> x y) (> y z)) (+ (square x) (square y)))
    ((and (> y z) (> z x)) (+ (square y) (square z)))
    ((and (> z x) (> x y)) (+ (square z) (square x)))
    ((and (> y x) (> x z)) (+ (square y) (square x)))
    ((and (> z y) (> y x)) (+ (square z) (square x)))
    ((and (> x z) (> z y)) (+ (square x) (square z)))))

; (print (sum-of-squares-of-two-larger-numbers 1 2 3))

; 1.4
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

;(print (a-plus-abs-b 1 -2))
;-> 3
;オペレータ自体を返すことが可能になっている。

; 1.5
(define (p) (p))

(define (test x y)
  (if (= x 0)
    0
    y))

(print (test 0 (p)))

; if文で(p)を評価するところでpが循環参照されている。(p)がさらに(p)を呼び出し、(p)を評価する。結果として答えは返ってない。

(define (sum-of-squares x y)
  (+ (square x) (square y)))

(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

; 置き換えモデル
;(f 5)
;(sum-of-squares (+ a 1) (* a 2))
;(sum-of-squares (+ 5 1) (* 5 2))
;(sum-of-squares 6 10)
;(+ (square x) (square y))
;(+ (square 6) (square 10))
;(+ 36 100)
;136
;
;
;(define (factorial n)
;  (if (= n 1)
;    1
;    (* n (factorial (- n 1)))))
;
;(factorial 3)
;(if (= n 1)
;    1
;    (* n (factorial (- n 1))))
;(if (= 3 1)
;    1
;    (* 3 (factorial (- 3 1))))
;(* 3 (factorial (- 3 1)))
;(* 3 (factorial 2))
;(* 3 (if (= n 1)
;    1
;    (* n (factorial (- n 1)))))
;(* 3 (if (= 2 1)
;    1
;    (* 2 (factorial (- 2 1)))))
;(* 3 (* 2 (factorial (- 2 1))))
;(* 3 (* 2 (factorial 1)))
;(* 3 (* 2 (if (= n 1)
;    1
;    (* n (factorial (- n 1))))))
;(* 3 (* 2 (if (= 1 1)
;    1
;    (* 1 (factorial (- 1 1))))))
;(* 3 (* 2 1))
;(* 3 2)
;6
;
;(define (factorial n)
;  (fact-iter 1 1 n))
;
;(define (fact-iter product counter max-count)
;  (if (> counter max-count)
;    product
;    (fact-iter (* counter product)
;               (+ counter 1)
;               max-count)))
;
;(factorial 3)
;(fact-iter 1 1 n)
;(fact-iter 1 1 3)
;(if (> counter max-count)
;    product
;    (fact-iter (* counter product)
;               (+ counter 1)
;               max-count))
;(if (> 1 3)
;    1
;    (fact-iter (* 1 1)
;               (+ 1 1)
;               3))
;(fact-iter (* 1 1)
;           (+ 1 1)
;           3)
;(fact-iter 1 2 3)
;(if (> 2 3)
;    1
;    (fact-iter (* 2 1)
;               (+ 2 1)
;               3))
;(fact-iter (* 2 1)
;           (+ 2 1)
;           3)
;(fact-iter 2 3 3)
;(if (> counter max-count)
;    product
;    (fact-iter (* counter product)
;               (+ counter 1)
;               max-count))
;(if (> 3 3)
;    2
;    (fact-iter (* 3 2)
;               (+ 3 1)
;               3))
;(fact-iter (* 3 2)
;           (+ 3 1)
;           3)
;(fact-iter 6 4 3)
;(if (> 4 3)
;    6
;    (fact-iter (* 4 6)
;               (+ 4 1)
;               3))
;6
