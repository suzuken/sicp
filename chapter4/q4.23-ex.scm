; 例
(begin 
  (print "Hello 1")
  (print "Hello 2")
  (print "Hello 3")
  'done)

(begin 
  (define x 5)
  (print x)
  'done)

(begin 
  (define (sqrt x) (* x x))
  (print (sqrt 5))
  'done)

(begin
  (define (sum x) (+ 1 x))
  (print (sum 5))
  'done)

; http://sicp.iijlab.net/fulltext/x311.html より
(define balance 100)
(define (withdraw amount)
  (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
