; q4.2

;a 
;
; 例えば式に対する(define x 3)評価を見ていく
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
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
          (error "Unknown expression type -- EVAL" exp))))

; 通常であればcond?は代入よりも前にある。
; (define x 3)ではcond?は使わない。Louisの評価機だと(define x 3)もcond?だとみなしてしまう。
; x 3はxがcondのとき、tagged-list?の条件に合致するためだ。
; するとexpand-clausesによって置き換えられるようにされていく
; else節はないので、make-ifが走る。
; firstのcdrは存在しないのでエラーになる

; b. 手続き作用がcallで始まるようにする
; 手続き作用をつくる手続きの発火条件を変えればいいはず
; 早く見つからなければならないので、適当に分岐する

(define (call? exp) (taged-list? exp 'call))
(define (eval-call exp env)
  (let (exp-body (car exp))
    (cond ((if? exp-body) (eval-if exp env))
          ((lambda? exp-body)
           (make-procedure (lambda-parameters exp-body)
                           (lambda-body exp-body)
                           env))
          ((begin? exp-body)
           (eval-sequence (begin-actions exp-body) env))
          ((cond? exp-body) (eval (cond->if exp) env))
          ((application? exp-body)
           (apply (eval (operator exp-body) env)
                  (list-of-values (operands exp-body) env)))
          (else (error "call error --" exp-body)))))

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((call? exp) (eval-call exp env))
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        (else
          (error "Unknown expression type -- EVAL" exp))))
