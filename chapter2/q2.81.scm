(load "./s2.4.scm")
(load "./s2.5.scm")

; 2.81
;
; appply-genericは引数が既に同じ型を持っていても、互いの方へ強制変換を試みるべきだと考えた。

; ということで同じ型の変換を提案している
(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)
(put-coercion 'scheme-number 'scheme-number
              scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

; a.
;
; apply-genericが型scheme-numberの2つの引数や型complexの2つの引数で、これらの型で表に見つからない手続きに対して呼び出されると、

(define (exp x y)
    (apply-generic 'exp x y))

; 汎用計算にexpを追加
(define (install-scheme-number-package)

    (define (tag x)
      (attach-tag 'scheme-number x))
    (put 'add '(scheme-number scheme-number)
         (lambda (x y) (tag (+ x y))))
    (put 'sub '(scheme-number scheme-number)
         (lambda (x y) (tag (- x y))))
    (put 'mul '(scheme-number scheme-number)
         (lambda (x y) (tag (* x y))))
    (put 'div '(scheme-number scheme-number)
         (lambda (x y) (tag (/ x y))))
    (put 'make 'scheme-number
         (lambda (x) (tag x)))

    ;今回追加したexp手続き
    (put 'exp '(scheme-number scheme-number)
         (lambda (x y) (tag (expt x y))))
    'done)

(install-scheme-number-package)
(install-rectangular-package)
(install-polar-package)
(install-complex-package)

(define z1
    (make-complex-from-real-imag 3 4))
(define z2
    (make-complex-from-real-imag 4 5))

(use slib)
(require 'trace)
(trace apply-generic)
; (print (exp z1 z2))
;
; 何も返ってこない、というかずーーーーーーーっと型変換がループして死ぬ。
;
; b. このままだと動かないのでapply-genericを修正する必要がある。
;
; Louisの考えは正しいとは言えない。今のapply-genericの実装だと動かない。
;
; c. ということで2つの引数が同じ型をもっていたら強制型変換を試みないように、apply-genericを修正する
;
(define (apply-generic op . args)
    (let ((type-tags (map type-tag args)))
      (let ((proc (get op type-tags)))
        (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
            (let ((type1 (car type-tags))
                  (type2 (cadr type-tags))
                  (a1 (car args))
                  (a2 (cadr args)))
              (let ((t1->t2 (get-coercion type1 type2))
                    (t2->t1 (get-coercion type2 type1)))
                ; こんな感じ？
                (if (eq? type1 type2)
                  (error "Same type is defined." (list op type-tags)))

                (cond (t1->t2
                        (apply-generic op (t1->t2 a1) a2))
                      (t2->t1
                        (apply-generic op a1 (t2->t1 a2)))
                      (else
                        (error "No method for these types"
                               (list op type-tags))))))
            (error "No method for these types"
                   (list op type-tags)))))))

; (print (exp z1 z2))
; gosh: "error": Same type is defined. (exp (complex complex))
