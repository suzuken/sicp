(load "./s2.5.scm")

; 多項式パッケージに=zero?を追加
(define (install-=zero?-polynomial-package)
  (define (=zero?-polynomial n)
    (eq? (car n) 0))
  (put '=zero? '(polynomial)
       (lambda (x) (=zero?-polynomial x)))
  'done)

; TESTING
(load "./q2.78.scm")
(load "./q2.80.scm")
(install-polynomial-package)
(install-scheme-number-package)
(install-=zero?-package)
(install-=zero?-polynomial-package)
(define p1 (make-polynomial 'x '((100 0) (1 10))))
(define p2 (make-polynomial 'x '((100 2) (1 10))))
; (use slib)
; (require 'trace)
; (trace add)
; (trace type-tag)
; (print (add p1 p2))
(test* 
  "test (2x^100 + 20x) = (0x^100 + 10x) + (2x^100 + 10x)"
  (make-polynomial 'x '((100 2) (1 20)))
  (add (make-polynomial 'x '((100 0) (1 10))) (make-polynomial 'x '((100 2) (1 10)))))

(test* 
  "test y1 * x^2 + y2 * x^1 + y3 = (y1 * x^2 + y2 * x^1 + y3) + (y4 * x^1 + y5)"
  (make-polynomial 'x '((2 ,y1) (1 ,y2) (0 ,y3) (1 ,y4) (0 ,y5)))
  (add (make-polynomial 'x '((2 ,y1) (1 ,y2) (0 ,y3)))
       (make-polynomial 'x '((1 ,y4) (0 ,y5)))))
