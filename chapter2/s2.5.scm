; 2.5
(define true #t)
(define false #f)
(use gauche.test)

; attach-tagなどのインポート
(load "./s2.4.scm")
;
; 一旦3.3.3からput, getの実装を借りてくる

(define (make-table)
    (let ((local-table (list '*table*)))
      (define (lookup key-1 key-2)
          (let ((subtable (assoc key-1 (cdr local-table))))
            (if subtable
              (let ((record (assoc key-2 (cdr subtable))))
                (if record
                  (cdr record)
                  false))
                false)))
      (define (insert! key-1 key-2 value)
          (let ((subtable (assoc key-1 (cdr local-table))))
            (if subtable
              (let ((record (assoc key-2 (cdr subtable))))
                (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
              (set-cdr! local-table
                        (cons (list key-1
                                    (cons key-2 value))
                              (cdr local-table)))))
          'ok)
      (define (dispatch m)
          (cond ((eq? m 'lookup-proc) lookup)
                ((eq? m 'insert-proc!) insert!)
                (else (error "Unknown operation --TABLE" m))))
      dispatch))
(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

; 2.5.1 汎用算術演算
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

; 汎用計算
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
    'done)

(define (make-scheme-number n)
    ((get 'make 'scheme-number) n))

(define (install-rational-package)
    (define (numer x) (car x))
    (define (denom x) (cdr x))
    (define (make-rat n d)
        (let ((g (gcd n d)))
          (cons (/ n g) (/ d g))))
    (define (add-rat x y)
        (make-rat (+ (* (numer x) (denom y))
                     (* (numer y) (denom x)))
                  (* (denom x) (denom y))))
    (define (sub-rat x y)
        (make-rat (- (* (numer x) (denom y))
                     (* (numer y) (denom x)))
                  (* (denom x) (denom y))))
    (define (mul-rat x y)
        (make-rat (* (numer x) (numer y))
                  (* (denom x) (denom y))))
    (define (div-rat x y)
        (make-rat (* (numer x) (denom y))
                  (* (denom x) (numer y))))

    ;; interface to reset of the system
    (define (tag x) (attach-tag 'rational x))
    (put 'add '(rational rational)
         (lambda (x y) (tag (add-rat x y))))
    (put 'sub '(rational rational)
         (lambda (x y) (tag (sub-rat x y))))
    (put 'mul '(rational rational)
         (lambda (x y) (tag (mul-rat x y))))
    (put 'div '(rational rational)
         (lambda (x y) (tag (div-rat x y))))

    (put 'make 'rational
         (lambda (n d) (tag (make-rat n d))))
    'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))


; 複素数パッケージ
(define (install-complex-package)
  ;; 直交座標と極座標パッケージから取り入れた手続き
  (define (make-from-real-imag x y)
    (( get 'make-from-real-imag ' rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))

  ;;internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))

  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))

  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))

(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))


; =================
; 2.5.2 異なるデータの統合
; =================
;
; ここから私の担当部分 (2013/03/11 sicp)
; 複素数 + 通常の数などはどのようにしよう？

; 煩わしい方法
(define (add-complex-to-schemenum z x)
    (make-from-real-imag (+ (real-part z) x)
                         (imag-part z)))

(put 'add '(complex scheme-number)
     (lambda (z x) (tag (add-complex-to-schemenum z x))))

; しかし、すべての型同士の組み合わせについてこれをやるのは非常に面倒だし管理容易とはいえない
; 有理数と複素数の計算を複素数パッケージの責任にするのは合理的。
; しかしこれが他の型がある場合にどのように毎回責任を判断するかというのは大変なこと。

; 強制型変換
; ある方のオブジェクトが他の方と見做す方法

; 与えられた通常の数を、その実部とゼロの虚部を持つ複素数に変更する
(define (scheme-number->complex n)
    (make-complex-from-real-imag (contents n) 0))

; この強制返還手続きを2つの型でひく特別の強制型変換表に設定する
(define coercion-table (make-table))
(define get-coercion (coercion-table 'lookup-proc))
(define put-coercion (coercion-table 'insert-proc!))

(put-coercion 'scheme-number 'complex scheme-number->complex)

; 強制変換表が出来上がると、apply-generic手続きを修正することで強制型変換を画一的に扱うことができる。
; 第一の型->第二の型が可能であれば行なう
; できないなら、逆を試す
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
                (cond (t1->t2
                        (apply-generic op (t1->t2 a1) a2))
                      (t2->t1
                        (apply-generic op a1 (t2->t1 a2)))
                      (else
                        (error "No method for these types"
                               (list op type-tags))))))
            (error "No method for these types"
                   (list op type-tags)))))))

; ================== TESTING =====================
; (install-rectangular-package)
; (install-polar-package)
; (install-scheme-number-package)
; (install-rational-package)
; (install-complex-package)
;
; 強制的に型変換が行われ、scheme-numberとcomplexの加算を行うことができるようになっている
; (test-start "apply-generic")
; (test* "2 + (3 + 2i) = 5 + 2i"
;        (make-complex-from-real-imag 5 2)
;        (add (make-scheme-number 2) (make-complex-from-real-imag 3 2)))
; (test-end)

; 明示的に型の間の演算を定義するより多くの利点がある。
;
; --------
; 型の階層構造
; --------

; 汎用算術演算システムの場合には比較的明確な階層構造があった。
; 整数、有理数、実数、複素数
;
; --------
; 階層構造の不適切さ
; --------

; 2.5.3 例: 記号台数

; same-variable?手続きを持ってくる
; (load "./s2.3.scm")
(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

; (define (add-poly p1 p2)
;     (if (same-variable? (variable p1) (variable p2))
;       (make-poly (variable p1)
;                  (add-terms (term-list p1)
;                             (term-list p2)))
;       (error "Polys not in same var -- ADD-POLY"
;              (list p1 p2))))
; 
; (define (mul-poly p1 p2)
;     (if (same-variable? (variable p1) (variable p2))
;       (make-poly (variable p1)
;                  (mul-terms (term-list p1)
;                             (term-list p2)))
;       (error "Polys not in same var -- MUL-POLY"
;              (list p1 p2))))

(define (install-polynomial-package)
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  ; 2.3.2より
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
                 (add-terms (term-list p1)
                            (term-list p2)))
      (error "Polys not in same var -- ADD-POLY"
             (list p1 p2))))

  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
                 (mul-terms (term-list p1)
                            (term-list p2)))
      (error "Polys not in same var -- MUL-POLY"
             (list p1 p2))))

  ; 項リストの表現
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
      term-list
      (cons term term-list)))

  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))

  ; p.120
  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
            (let ((t1 (first-term L1)) (t2 (first-term L2)))
              (cond ((> (order t1) (order t2))
                     (adjoin-term
                       t1 (add-terms (rest-terms L1) L2)))
                    ((< (order t1) (order t2))
                     (adjoin-term
                       t2 (add-terms L1 (rest-terms L2))))
                    (else
                      (adjoin-term
                        (make-term (order t1)
                                   (add (coeff t1) (coeff t2)))
                        (add-terms (rest-terms L1)
                                   (rest-terms L2)))))))))

  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
      (the-empty-termlist)
      (add-terms (mul-term-by-all-terms (first-term L1) L2)
                 (mul-terms (rest-terms L1) L2))))

  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
      (the-empty-termlist)
      (let ((t2 (first-term L)))
        (adjoin-term
          (make-term (+ (order t1) (order t2))
                     (mul (coeff t1) (coeff t2)))
          (mul-term-by-all-terms t1 (rest-terms L))))))

  (define (tag p) (attach-tag 'polynomial p))

  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  'done)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

; 実際に多項式を作る
(load "./q2.78.scm")
(load "./q2.80.scm")
; (install-polynomial-package)
; (install-scheme-number-package)
; (install-=zero?-package)
; (define p1 (make-polynomial 'x '((100 1) (1 10))))
; (define p2 (make-polynomial 'x '((100 2) (1 10))))
; (use slib)
; (require 'trace)
; (trace add)
; (trace type-tag)
; (print (add p1 p2))
