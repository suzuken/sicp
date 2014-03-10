; q4.6

; let式が現れたらlambdaに置き換えれば良い
(define (let? exp)
  (tagged-list? exp 'let))
(define (let-parameters exp)
  (cadr exp))
(define (let-body exp)
  (cddr exp))
(define (let-variables exp)
  (map car (let-parameters exp)))
(define (let-expressions exp)
  (map cadr (let-parameters exp)))

(define (let->combination exp)
  (if (null? (let-parameters exp))
    '()
    (cons
      (make-lambda (let-variables exp) (let-body exp))
      (let-expressions exp))))

; eval
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((let? exp) (eval (let->combination exp) env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
          (error "Unknown expression type -- EVAL" exp))))
