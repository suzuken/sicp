; q4.1
;(load "./s1.scm")
(define val 10)
(define expression '((set! val (+ val 2)) (set! val (* val 2))))
(define no-operands? null?)
(define first-operand car)
(define rest-operands cdr)

; もとの形式
(define (list-of-values exps env)
  (if (no-operands? exps)
    '()
    (cons (eval (first-operand exps) env)
          (list-of-values (rest-operands exps) env))))
(print (list-of-values expression val))

; 超循環評価器に依存しないで左から右
(define (list-of-values-from-left exps env)
  (if (no-operands? exps)
    '()
    (cons (eval (car exps) env)
          (list-of-values-from-left (cdr exps) env))))
(print (list-of-values-from-left expression val))

; 超循環評価器に依存しないで右から左
(define (list-of-values-from-right exps env)
  (if (no-operands? exps)
    '()
    (let ((first-eval (list-of-values-from-right (cdr exps) env)))
    (cons (eval (car exps) env)
          first-eval))))
(print (list-of-values-from-right expression val))
