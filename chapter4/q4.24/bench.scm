; q4.24
; Gauche ユーザリファレンス: 9.30 gauche.time - 時間の計測
; http://practical-scheme.net/gauche/man/gauche-refj_104.html
(define (fib n)
  (define (fib-iter a b count)
    (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))
  (fib-iter 1 0 n))
(fib 100000)

; analyzed
; ;;; M-Eval input:
; ;(time (eval input the-global-environment))
; ; real   1.278
; ; user   1.270
; ; sys    0.000

; original
; ;;; M-Eval input:
; ;(time (eval input the-global-environment))
; ; real   1.516
; ; user   1.520
; ; sys    0.000

; 会社
;
; analyzed
; ;;; M-Eval input:
; (fib 100000)
; ;(time (eval input the-global-environment))
; ; real   1.269
; ; user   1.260
; ; sys    0.000

; original
; ;;; M-Eval input:
; (fib 100000)
; ;(time (eval input the-global-environment))
; ; real   1.524
; ; user   1.530
; ; sys    0.000

(define (fib n)
  (if (< n 2)
    n
    (+ (fib (- n 1)) (fib (- n 2)))))

; original
; ;;; M-Eval input:
; (fib 20)
; ;(time (eval input the-global-environment))
; ; real   0.167
; ; user   0.170
; ; sys    0.000

;; M-Eval input:
;; (fib 30)
;; ;(time (eval input the-global-environment))
;; ; real  20.527
;; ; user  20.520
;; ; sys    0.010

; analyzed
; ;;; M-Eval input:
; (fib 20)
; ;(time (eval input the-global-environment))
; ; real   0.129
; ; user   0.120
; ; sys    0.000
;
;;; M-Eval input:
;;; (fib 30)
;;; ;(time (eval input the-global-environment))
;;; ; real  15.495
;;; ; user  15.490
;;; ; sys    0.010

(define (factorial n)
  (if (= n 1)
    1
    (* (factorial (- n 1)) n)))
(factorial 100000)

(define (factorial n)
  (define (fact-iter product count)
    (if (= count 1)
      product
      (fact-iter (* product count)
                 (- count 1))))
  (fact-iter 1 n))
(factorial 100000)

; original
; ;;; M-Eval input:
; (factorial 100000)
; ;(time (eval input the-global-environment))
; ; real   9.286
; ; user   9.260
; ; sys    0.030

; analyzed
; ;;; M-Eval input:
; (factorial 100000)
; ;(time (eval input the-global-environment))
; ; real   9.643
; ; user   9.600
; ; sys    0.040

(define (sum n)
  (if (= n 1)
    1
    (+ (sum (- n 1)) n)))
(sum 100000)

; original
; ;;; M-Eval input:
; (sum 100000)
; ;(time (eval input the-global-environment))
; ; real   0.901
; ; user   0.890
; ; sys    0.010

; analyzed
; ;;; M-Eval input:
; (sum 100000)
; ;(time (eval input the-global-environment))
; ; real   1.309
; ; user   1.290
; ; sys    0.010

(define (sum5 n)
  (cond ((= (mod n 2) 0) 2)
        ((= (mod n 3) 0) 3)
        ((= (mod n 4) 0) 4)
        ((= (mod n 5) 0) 5)
        ((= (mod n 6) 0) 6)
        ((= (mod n 7) 0) 7)
        ((= (mod n 8) 0) 8)
        ((= (mod n 9) 0) 9)
        (else (sum5 (+ n 1)))))

(define (mini-sum5 n)
  (cond ((= (mod n 2) 0) 2)
        (else (mini-sum5 (+ n 1)))))
(define (times f n)
  (f n)
  (if (= n 1)
    (f n)
    (times f (- n 1))))
(times sum5 1000000)

; original
; ;;; M-Eval input:
; (times sum5 1000000)
; ;(time (eval input the-global-environment))
; ; real  32.568
; ; user  32.560
; ; sys    0.010

; analyzed
; ;;; M-Eval input:
; (times sum5 1000000)
; ;(time (eval input the-global-environment))
; ; real  19.635
; ; user  19.600
; ; sys    0.040
;

(times mini-sum5 1000000)

; original
; ;;; M-Eval input:
; (times mini-sum5 1000000)
; ;(time (eval input the-global-environment))
; ; real  21.071
; ; user  21.070
; ; sys    0.000

; analyzed
; ;;; M-Eval input:
; (times mini-sum5 1000000)
; ;(time (eval input the-global-environment))
; ; real  13.647
; ; user  13.630
; ; sys    0.020


(define (sum n)
  (if (= n 1)
    1
    (+ (sum (- n 1)) n)))
(sum 100000)

(define (hoge)
  (+ 1 1))

(times hoge 100000)
