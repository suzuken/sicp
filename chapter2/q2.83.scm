(load "./s2.4.scm")
(load "./s2.5.scm")

; 2.83

; 複素数
; ↑
; 実数
; ↑
; 有理数
; ↑
; 整数
;
; 図2.25
;
; 上の図のような型の塔: 整数、有理数、実数、複素数を扱う汎用算術演算システムを設計しているとしよう。
; 複素数を除く各型について、その型のオブジェクトを塔の中で位置レベル高める手続きを設計せよ。
; 複素数を除く各型に働く汎用raise演算はどう設計するか。
;
;
; http://ja.wikipedia.org/wiki/実数
; http://ja.wikipedia.org/wiki/有理数
;
; つまり、
;
; 整数 -> 有理数
; 有理数 -> 実数
;
; な型変換の手続きを書けと言っている、っぽい。
;
; ひとまず一つ上の型に変換する手続きがraiseなので、
;
; * 'integerが来たら'rationalに変換する
; * 'rationalが来たら、'realに変換する
;
; としてあげればよい。
;

; 実数の算術演算パッケージがないので作る
(define (install-integer-package)
  (define (tag x)
    (attach-tag 'integer x))
  (put 'add '(integer integer)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(integer integer)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(integer integer)
       (lambda (x y) (tag (* x y))))
  (put 'div '(integer integer)
       (lambda (x y) (tag (/ x y))))
  (put 'equ? '(integer integer)
       (lambda (x y) (= x y)))
  (put '=zero? '(integer)
       (lambda (x) (= x 0)))
  (put 'make 'integer
       (lambda (x) (if (integer? x)
                     (tag x)
                     (error "Non-integer value is given." x))))
  'done)

(define (make-integer n)
  ((get 'make 'integer) n))

; (install-integer-package)
; (print (make-integer 3))

(define (install-real-package)
  (define (tag x)
    (attach-tag 'real x))
  (put 'add '(real real)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(real real)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(real real)
       (lambda (x y) (tag (* x y))))
  (put 'div '(real real)
       (lambda (x y) (tag (/ x y))))
  (put 'equ? '(real real)
       (lambda (x y) (= x y)))
  (put '=zero? '(real)
       (lambda (x) (= x 0.0)))
  (put 'make 'real
       (lambda (x) (tag x)))
  'done)

(define (make-real n)
  ((get 'make 'real) n))

(install-integer-package)
(install-rational-package)
(install-real-package)

(define (install-raise-package)
  ;; interface to rest of the system
  (put 'raise '(integer)
       (lambda (z) (make-rational z 1)))
  (put 'raise '(rational)
       (lambda (z) (make-real (/ (car z) (cdr z)))))
  (put 'raise '(real)
       (lambda (x) (make-complex-from-real-imag x 0)))
  'done)

(install-raise-package)

(define (raise x)
    (apply-generic 'raise x))

;(use slib)
;(require 'trace)
;(trace raise)
;(print (raise (make-integer 1)))
;(print (make-integer 1))

; (use gauche.test)
; (test-start "raise")
; (test* "integerを作ってみる" '(integer . 1) (make-integer 1))
; (test* "integerをraiseしてみる" (raise (make-integer 1)) (make-rational 1 1))
; (test* "rational->realの型変換してみる" (raise (make-rational 1 1)) (make-real 1))
; (test-end)

