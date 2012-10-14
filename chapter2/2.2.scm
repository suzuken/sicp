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

; 2.19

;(define (count-change amount)
;  (cc amount 5))
;
;(define (cc amount kinds-of-coins)
;  (cond ((= amount 0) 1)
;        ((or (< amount 0) (= kinds-of-coins 0)) 0)
;        (else (+ (cc amount
;                     (- kinds-of-coins 1))
;                 (cc (- amount
;                        (first-denomination kinds-of-coins))
;                     kinds-of-coins)))))
;
;(define (first-denomination kinds-of-coins)
;  (cond ((= kinds-of-coins 1) 1)
;        ((= kinds-of-coins 2) 5)
;        ((= kinds-of-coins 3) 10)
;        ((= kinds-of-coins 4) 25)
;        ((= kinds-of-coins 5) 50)))

(define us-coins (list 50 25 10 5 1))

(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define (no-more? coin-values)
  (null? coin-values))

(define (except-first-denomination coin-values)
  (cdr coin-values))

(define (first-denomination coin-values)
  (car coin-values))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
          (+ (cc amount
                  (except-first-denomination coin-values))
              (cc (- amount
                     (first-denomination coin-values))
                  coin-values)))))

;(first-denomination us-coins)
;(first-denomination uk-coins)
;(except-first-denomination us-coins)

;(cc 100 us-coins)
;(cc 100 uk-coins)

(define sample-coins (list 1 5 10 25 50))

;(cc 100 sample-coins)


; 2.20


