; q2.78
(define (attach-tag type-tag contents)
  (if (eq? type-tag 'scheme-number)
    contents
    (cons type-tag contents)))

(define (type-tag datum)
    (if (pair? datum)
      (car datum)
      'scheme-number))
      ;(error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
    (if (pair? datum)
      (cdr datum)
      datum))
      ;(error "Bad tagged datum -- CONTENTS" datum)))
