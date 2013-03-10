(load "./s2.4.scm")
(load "./s2.5.scm")

; equ?のimport
(load "./q2.79.scm")

(load "./q2.83.scm")
(load "./q2.84.scm")

(use gauche.test)

; 2.85 drop手続きの設計
;
; 本節ではデータオブジェクトを、型の塔をできるだけ下げ、「単純化」する方法を述べた。q2.83で述べた塔についてこれを実施する手続きdropを設計せよ。
;
; 例:
; * 複素数 1.5 + 0i はrealまで下げられる
; * 複素数 1 + 0i はintegerまで下げられる
; * 複素数 2 + 3i は全く下げられない
;
; オブジェクトを塔に沿って下へ「押す」汎用演算projectの定義から始める
; 例えば、複素数の投影は虚部捨てることである。
; 数をprojectし、結果をraiseして出発した型に戻した時、出発したのと同じ何かで終われば、数は切り下げられる。
; オブジェクトをできるだけ下げるdrop手続きを書いて、この考えを実装する方法を詳しく述べよ。
;
; ---
;
; つまり、projectでは無理やり下げるようにして、raiseしたときに結果が同じかどうか見るってこと。

(define (install-project-package)
  ; 整数部分だけ渡す
  (define (project-rational x)
    (make-integer (round (/ (car x) (cdr x)))))
  ; なんとかしてそれっぽい分数にして渡すことになる
  ; 有理数近似の実装を要求されている…？
  ; とりあえず標準のx->integerを利用する
  ; 時間あれば有理数近似を実装
  (define (project-real x)
    (make-rational (x->integer x) 1))
  ; 実部を取って渡せば良い
  (define (project-complex x)
    (make-real (real-part x)))
  (put 'project '(rational)
       (lambda (x) (project-rational x)))
  (put 'project '(real)
       (lambda (x) (project-real x)))
  (put 'project '(complex)
       (lambda (x) (project-complex x)))
  'done)

(define (project x)
  (apply-generic 'project x))

; ================== TESTING =====================
(install-rectangular-package)
(install-polar-package)
(install-scheme-number-package)
(install-rational-package)
(install-complex-package)
(install-integer-package)
(install-real-package)
(install-raise-package)
(install-project-package)
(install-equ?-package)
;
; (test-start "project")
; (test* "project-rational" (make-integer 2) (project (make-rational 5 3)))
; (test* "project-rational" (make-integer 3) (project (make-rational 9 3)))
; (test* "project-real" (make-rational 10 1) (project (make-real 9.5)))
; (test* "project-complex" (make-real 3) (project (make-complex-from-real-imag 3 5)))
; (test-end)
;
; 数をprojectし、結果をraiseして出発した型に戻した時、出発したのと同じ何かで終われば、数は切り下げられる。
; オブジェクトをできるだけ下げるdrop手続きを書いて、この考えを実装する方法を詳しく述べよ。
;
; とのことだったので、projectとraiseの結果を比較して同じならprojectするような仕組みをdrop手続きに入れる

; 最下位の型か？
(define (lowest-type? t)
  (eq? (car tower) t))

; 再帰的にprojectする
; 最下位の型の場合にはprojectしない。
(define (drop x)
  (if (lowest-type? (type-tag x)) x
    (let ((project-x (project x)))
      (if project-x
        (if (equ? x (raise project-x))
          (drop project-x)
          x)
        x))))

; (use slib)
; (require 'trace)
; (trace raise)

(test* "drop" (make-integer 2) (drop (make-complex-from-real-imag 2 0)))
; 分数の処理が甘いのでこうなる
(test* "drop" (make-real 1.5) (drop (make-complex-from-real-imag 1.5 0)))
(test* "drop" (make-real 1.5) (drop (make-complex-from-real-imag 1.5 0)))
(test* "drop" (make-integer 4) (drop (make-rational 4 1)))
(test* "drop" (make-integer 4) (drop (make-real 4)))

; いろいろな投影演算を設計し、projectをシステムに汎用に実装する必要がる。また、q2.79で述べた汎用等価述語を利用する必要がある。
;
; 最後に答えを「単純化する」ようにq2.84のapply-genericを書きなおすのにdropを使え。

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (drop (apply proc (map contents args)))
        (if (= (length args) 2)
          (let ((type1 (car type-tags))
                (type2 (cadr type-tags))
                (a1 (car args))
                (a2 (cadr args)))
            (if (eq? type1 type2)
              (error "Same type is defined." (list op type-tags))
              ; lowerだったらraiseして回す
              (let ((low (lower type1 type2)))
                (cond ((eq? low type1) (apply-generic op (raise a1) a2))
                      ((eq? low type2) (apply-generic op a1 (raise a2)))
                      (else (error "Exception" (list op type-tags)))))))
          (error "No method for these types"
                 (list op type-tags)))))))

; (test* "drop" (make-integer 4) (drop (make-real 4)))
; (test* "3 + (2 + 3i) = 5 + 3i"
;        (make-complex-from-real-imag 5 3)
;        (add (make-integer 3) (make-complex-from-real-imag 2 3)))
