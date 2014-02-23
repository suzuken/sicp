; q4.12

; いい感じにscanするのを共通化する
; TODO envのiterate
;
; 解答
(load "./s1.scm")

(define (walk-env var vars vals)
  (cond ((null? vars) '())
        ((eq? var (car vars)) vals)
        (else (walk-env (cdr vars) (cdr vals)))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env)))
        (let ((result (walk-env var (frame-variables frame) (frame-values frame))))
          (if (null? result)
            (env-loop (enclosing-environment env))
            (car result))))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
      (error "Unbound variable -- SET!" var)
      (let ((frame (first-frame env)))
        (let ((result (walk-env var (frame-variables frame) (frame-values frame))))
          (if (null? result)
            (env-loop (enclosing-environment env))
            (set-car! result val))))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (let ((result (walk-env var (frame-variables frame) (frame-values frame))))
      (if (null? result)
        (add-binding-to-frame! var val frame)
        (set-car! result val)))))
