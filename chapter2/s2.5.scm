; 2.5
(define true #t)
(define false #f)
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
