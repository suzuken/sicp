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
