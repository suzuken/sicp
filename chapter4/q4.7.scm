; q4.7

(let* ((x 3)
       (y (+ x 2))
       (z (+ x y 5)))
  (* x z))

; は、letで書き直すと

(let (x 3)
  (let (y (+ x 2))
    (let (z (+ x y 5))
      (* x z))))

; となる。

(define (let*? exp) (tagged-list? exp 'let*))

(define (let*->parameters exp)
  ((car exp) (let*->parameters (cdr exp))))

(define (let*->body)
  (cdr exp))

(define (make-let parameter body)
  (list 'let parameter body))

(define (let*->nested-lets exp)
  (make-let (let*->parameters exp) (let*->body exp)))
