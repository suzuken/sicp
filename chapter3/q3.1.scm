; q3.1

(define (make-accumulator sum)
  (define (dispatch val)
    (if (number? val)
      (begin (set! sum (+ sum val)) sum)
      (error "val should be number -- MAKE-ACCUMULATOR" val)))
  dispatch)

; test
(define A (make-accumulator 5))
(use gauche.test)
(test* "10 + 5" 15 (A 10))
(test* "15 + 10" 25 (A 10))

(define B (make-accumulator 5))
(use gauche.test)
;(B 'hoge)
;gosh: "error": val should be number -- MAKE-ACCUMULATOR hoge
