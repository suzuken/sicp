; q4.44
(define amb '())
(define (require p)
  (if (not p) (amb)))

(define (member obj lst)
  (cond ((null? lst) false)
        ((eq? obj (car lst)) lst)
        (else (member obj (cdr lst)))))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

; queensの1つ目は+-1, 2つ目は+2,,,
(define (safe queen queens)
  (define (safe-iter queen queens diff)
    (if (= (abs (- queen (car queens)) diff))
      #f
      (if (= (length queens) 1)
        #t
        (safe-iter queen (cdr queens) (+ diff 1)))))
  (safe-iter queen queens 1))

(define (eight-queen)
  (let ((first (amb 1 2 3 4 5 6 7 8)))
    (let ((second (amb 1 2 3 4 5 6 7 8)))
      (require (distinct? (list first second)))
      (require (safe second (list first)))
      (let ((third (amb 1 2 3 4 5 6 7 8)))
        (require (distinct? (list first second third)))
        (require (safe third (list first second)))
        (let ((forth (amb 1 2 3 4 5 6 7 8)))
          (require (distinct? (list first second third forth)))
          (require (safe forth (list first second third)))
          (let ((fifth (amb 1 2 3 4 5 6 7 8)))
            (require (distinct? (list first second third forth fifth)))
            (require (safe fifth (list first second third forth)))
            (let ((sixth (amb 1 2 3 4 5 6 7 8)))
              (require (distinct? (list first second third forth fifth sixth)))
              (require (safe sixth (list first second third forth fifth)))
              (let ((seventh (amb 1 2 3 4 5 6 7 8)))
                (require (distinct? (list first second third forth fifth sixth seventh)))
                (require (safe seventh (list first second third forth fifth sixth)))
                (let ((eighth (amb 1 2 3 4 5 6 7 8)))
                  (require (distinct? (list first second third forth fifth sixth seventh eighth)))
                  (require (safe eighth (list first second third forth fifth sixth seventh)))
                  (list (list 'first first)
                        (list 'second second)
                        (list 'third third)
                        (list 'forth forth)
                        (list 'fifth fifth)
                        (list 'sixth sixth)
                        (list 'seventh seventh)
                        (list 'eighth eighth)))))))))))

(eight-queen)
try-again
