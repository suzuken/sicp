(define (install-=zero?-package)
  (define (=zero?-scheme-number n)
    (eq? n 0))
  (define (=zero?-rational x)
    (eq? (car x) 0))
  (define (=zero?-complex x)
    (eq? (magnitude x) 0))
  (put '=zero? '(scheme-number)
       (lambda (x) (=zero?-scheme-number x)))
  (put '=zero? '(rational)
       (lambda (x) (=zero?-rational x)))
  (put '=zero? '(complex)
       (lambda (x) (=zero?-complex x)))
  'done)

(define (=zero? x) (apply-generic '=zero? x))
