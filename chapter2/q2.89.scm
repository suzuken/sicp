(load "./s2.5.scm")

; 2.89 濃い多項式に適しているという項リストの表現を実現する手続きを定義せよ。
;
; 濃いというのは、
;
; x^100 + 2x^2 + 1 （薄い）
;
; などではなく、
;
; x^5 + 2x^4 + 3x^2 - 2x - 5 （濃い）
;
; のような多項式。なので((5 1) (4 2) (3 2) (1 -2) (0 -5))と表現するよりも、(1 2 0 3 -2 -5)と表現してしまったほうが効率的だよね、という話。ただこれだと薄い多項式だととても長いリストになってしまう。けど、まぁとりあえず濃い多項式向けの項リストの表現を実現してね、という問題

; 実装方針としてはインタフェースをinstall-polynoiral-packageと替えず、中身を濃い多項式に適している項リストの表現にするパッケージを書く
(define (install-dense-polynomial-package)
  (define (make-poly variable term-list)
    (print variable term-list)
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
    (print 'adjoin-term term term-list)
    (if (=zero? (coeff term))
      term-list
      (cons term term-list)))

  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list)
    (if (pair? term-list)
      (cdr term-list)
      the-empty-termlist))
  (define (empty-termlist? term-list) (null? term-list))
  ;(define (make-term order coeff) (list order coeff))
  ; lengthによって変わる。term-listを渡すように変更
  (define (order term-list)
    (if (> (length term-list) 1)
      (length (rest-terms term-list))
      1))
  (define (coeff term) (first-term term))

  ; p.120
  ; このadd-termsは新しい項表現向けに書き換える必要がある
  ; 低い項から足していく必要がある
  (define (add-terms L1 L2)
    (print L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
            (let ((t1 (first-term L1)) (t2 (first-term L2)))
              (cond ((> (order L1) (order L2))
                     (adjoin-term
                       t1 (add-terms (rest-terms L1) L2)))
                    ((< (order L1) (order L2))
                     (adjoin-term
                       t2 (add-terms L1 (rest-terms L2))))
                    (else
                      (if (pair? L1)
                        (adjoin-term
                          (add t1 t2)
                          (add-terms (rest-terms L1)
                                     (rest-terms L2)))
                        (+ t1 t2)
                        )))))))

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

(install-dense-polynomial-package)
(install-scheme-number-package)
(install-=zero?-package)
(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

(test* 
  "(x^5 + 2x^4 + 3x^2 - 2x - 5) = (x^5 + x^4 -10) + (x^4 + 3x^2 - 2x + 5)"
  (make-polynomial 'x '(1 2 0 3 -2 -5))
  (add (make-polynomial 'x '(1 1 0 0 0 -10)) (make-polynomial 'x '(1 0 3 -2 5))))
