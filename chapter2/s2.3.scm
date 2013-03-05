(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

;(define (make-sum a1 a2) (list '+ a1 a2))
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

;(define (make-product m1 m2) (list '* m1 m2))
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
         (else (list '+ m1 m2))))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

; 微分表現
;(define (deriv exp var)
;  (cond ((number? exp) 0)
;        ((variable? exp)
;         (if (same-variable? exp var) 1 0))
;        ((sum? exp)
;         (make-sum (deriv (addend exp) var)
;                   (deriv (augend exp) var)))
;        ((product? exp)
;         (make-sum
;           (make-product (multiplier exp)
;                         (deriv (multiplicand exp) var))
;           (make-product (deriv (multiplier exp) var)
;                         (multiplicand exp))))
;        (else
;          (error "unknown expression type -- DERIV" exp))))

;(print (deriv '(+ x 3) 'x))
;(print (deriv '(* x y) 'x))
;(print (deriv '(* (* x y) (+ x 3)) 'x))

; 2.56
(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base x) (car x))

(define (exponent x) (cadr x))

(define (make-exponentiation e1 e2)
  (print e1)
  (print e2)
  (cond ((=number? e2 1) e1)
        ((=number? e2 0) 1)
        ((=number? e1 0) 0)
        ((and (number? e1) (number? e2)) (** e1 e2))
         (else (list '** e1 e2))))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ((exponentiation? exp)
         (make-product
           (deriv exp base(exp))
           (deriv base(exp) var)))
        (else
          (error "unknown expression type -- DERIV" exp))))

(print (deriv '(** x 2) 'x))
;(print (deriv '(** u n) 'x))
