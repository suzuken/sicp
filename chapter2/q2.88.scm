(load "./s2.5.scm")

; 多項式システムを拡張せよ、とのことなので、新しいpackageを作らず、とりあえずinstall-polnomial-packageを拡張することにする
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

  ; q2.88 
  ; add-polyに対して汎用符号反転演算を利用して引き算を渡すようにした
  (define (sub-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (add-poly p1 (nega-poly p2))
      (error "Polys not in same var -- SUB-POLY"
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

  ; 符号を反転させる手続き
  (define (nega-poly p)
      (define nega-term-list (map nega-term (term-list p)))
      (cons (variable p) nega-term-list))

  ; termの各係数についてnegaを作用させる手続き
  (define (nega-term t)
      (make-term (order t)
                 (nega (coeff t))))

  (define (tag p) (attach-tag 'polynomial p))

  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (sub-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  'done)

(install-polynomial-package)
(install-scheme-number-package)
(install-=zero?-package)

; 実際に符号を反転させる手続きを定義するパッケージ
(define (install-nega-package)
  ; scheme-numberの符号を反転させる手続き
  (define (nega-scheme-number n)
    (- n))
  (put 'nega '(scheme-number)
       (lambda (x) (nega-scheme-number x)))
  'done)
(define (nega x) (apply-generic 'nega x))

(install-nega-package)

(test* 
  "(2x^100 + 20x) = (0x^100 + 10x) + (2x^100 + 10x)"
  (make-polynomial 'x '((100 2) (1 20)))
  (add (make-polynomial 'x '((100 0) (1 10))) (make-polynomial 'x '((100 2) (1 10)))))

(test*
  "2x^2 + 5x = (5x^2 + 10x) - (3x^2 + 5x)"
  (make-polynomial 'x '((2 2) (1 5)))
  (sub (make-polynomial 'x '((2 5) (1 10))) (make-polynomial 'x '((2 3) (1 5)))))