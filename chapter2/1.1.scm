(define (sum-of-squares x y)
  (+ (square x) (square y)))

(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

; 置き換えモデル
(f 5)
(sum-of-squares (+ a 1) (* a 2))
(sum-of-squares (+ 5 1) (* 5 2))
(sum-of-squares 6 10)
(+ (square x) (square y))
(+ (square 6) (square 10))
(+ 36 100)
136


(define (factorial n)
  (if (= n 1)
    1
    (* n (factorial (- n 1)))))

(factorial 3)
(if (= n 1)
    1
    (* n (factorial (- n 1))))
(if (= 3 1)
    1
    (* 3 (factorial (- 3 1))))
(* 3 (factorial (- 3 1)))
(* 3 (factorial 2))
(* 3 (if (= n 1)
    1
    (* n (factorial (- n 1)))))
(* 3 (if (= 2 1)
    1
    (* 2 (factorial (- 2 1)))))
(* 3 (* 2 (factorial (- 2 1))))
(* 3 (* 2 (factorial 1)))
(* 3 (* 2 (if (= n 1)
    1
    (* n (factorial (- n 1))))))
(* 3 (* 2 (if (= 1 1)
    1
    (* 1 (factorial (- 1 1))))))
(* 3 (* 2 1))
(* 3 2)
6

(define (factorial n)
  (fact-iter 1 1 n))

(define (fact-iter product counter max-count)
  (if (> counter max-count)
    product
    (fact-iter (* counter product)
               (+ counter 1)
               max-count)))

(factorial 3)
(fact-iter 1 1 n)
(fact-iter 1 1 3)
(if (> counter max-count)
    product
    (fact-iter (* counter product)
               (+ counter 1)
               max-count))
(if (> 1 3)
    1
    (fact-iter (* 1 1)
               (+ 1 1)
               3))
(fact-iter (* 1 1)
           (+ 1 1)
           3)
(fact-iter 1 2 3)
(if (> 2 3)
    1
    (fact-iter (* 2 1)
               (+ 2 1)
               3))
(fact-iter (* 2 1)
           (+ 2 1)
           3)
(fact-iter 2 3 3)
(if (> counter max-count)
    product
    (fact-iter (* counter product)
               (+ counter 1)
               max-count))
(if (> 3 3)
    2
    (fact-iter (* 3 2)
               (+ 3 1)
               3))
(fact-iter (* 3 2)
           (+ 3 1)
           3)
(fact-iter 6 4 3)
(if (> 4 3)
    6
    (fact-iter (* 4 6)
               (+ 4 1)
               3))
6
