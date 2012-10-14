(define (list-ref items n)
  (if (= n 0)
    (car items)
    (list-ref (cdr items) (- n 1))))

(define squares (list 1 4 9 16 25))

(define (length items)
  (if (null? items)
    0
    (+ 1 (length (cdr items)))))

(define odds (list 1 3 5 7))

; (define (length items)
;   (define (length-iter a count)
;     (if (null? a)
;       count
;       (length-iter (cdr a) (+ 1 count))))
;   (length-iter items 0))

(define (append list1 list2)
  (if (null? list1)
    list2
    (cons (car list1) (append (cdr list1) list2))))

; (append odds squares)

; 2.17

(define (last-pair items)
  (list-ref items (- (length items) 1)))

;(last-pair squares)
;(last-pair odds)

; 2.18

(define (reverse items)
  (if (null? (cdr items))
    items
    (append (reverse (cdr items)) (list(car items)))))

;(reverse squares)
