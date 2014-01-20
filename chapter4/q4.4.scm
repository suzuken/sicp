; q4.4
; andとorをつくる
(define (eval-and exp env)
  (if (null? exp)
    true
    (if (true? (eval (car exp) env))
      (eval-and (cdr exp) env)
      false)))

(define (eval-or exp env)
  (if (null? exp)
    false
    (if (true? (eval (car exp) env))
      (eval (car exp) env)
      (eval-or (cdr exp) env))))

