; 2.79

; equ?の実装
;

; install-scheme-number-package
(define (install-equ?-package)
  (define (equ?-rat x y)
    (and (= (car x) (car y))
         (= (cdr x) (cdr y))))
  (define (equ?-complex x y)
    (and (= (real-part x) (real-part y))
         (= (imag-part x) (imag-part y))))
  (put 'equ? '(scheme-number scheme-number) =)
  (put 'equ? '(rational rational) equ?-rat)
  (put 'equ? '(complex complex) equ?-complex)
  'done)

(define (equ? x y)
  (apply-generic 'equ? x y))
