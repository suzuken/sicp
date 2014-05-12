(load "./amb.scm")

(driver-loop)

(define amb '())
; 4.3.1
(define (require p)
  (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

; 本文にないので足した
(define (prime? n)
  (define (prime-iter n i)
    (print n i)
    (if (< n 2)
      #f
      (if (= n 2) #t))

    (if (= (modulo n 2) 0) #f)

    ; (if (<= i (/ n i)) #t)
    (if (= (modulo n i) 0)
      #f
      (if (<= (+ i 2) (/ n (+ i 2)))
        #t
        (prime-iter n (+ i 2)))))
  (prime-iter n 3))


(define (prime-sum-pair list1 list2)
  (let ((a (an-element-of list1))
        (b (an-element-of list2)))
    (require (prime? (+ a b)))
    (list a b)))
(prime-sum-pair '(1 3 5 8) '(20 35 110))
