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

(define (same-parity x . z)
  (define (iter items results)
    (if (null? items)
      results
      (iter (cdr items)
            (if (= (remainder (car items) 2)
              (remainder x 2))
              (append results (list (car items)))
            results))))
  (iter z (list x)))

; (same-parity 1 2 3 4 5 6 7)

; list mapping
(define nil '())

(define (scale-list items factor)
  (if (null? items)
    nil
    (cons (* (car items) factor)
          (scale-list (cdr items) factor))))

;(scale-list (list 1 2 3 4 5) 10)

(define (map proc items)
  (if (null? items)
    nil
    (cons (proc (car items))
          (map proc (cdr items)))))

;(map abs (list -10 2.5 -11.6 17))

;(map (lambda (x) (* x x))
;     (list 1 2 3 4))

;(define (scale-list items factor)
;  (map (lambda (x) (* x factor))
;       items))

; 2.21
(define (square-list items)
  (if (null? items)
    nil
    (cons (* (car items) (car items))
          (square-list (cdr items)))))

; (define (square-list items)
;   (map (lambda (x) (* x x))
;        items))

; (square-list (list 1 2 3 4))

; 2.22

; (define (square-list items)
;   (define (iter things answer)
;     (if (null? things)
;       answer
;       (iter (cdr things)
;             (cons (square (car things))
;                   answer))))
;   (iter items nil))

; consでanswerの先頭に導き出した結果を対にしているため

; (square-list (list 1 2 3 4))

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (cons answer
                  (square (car things))))))
  (iter items nil))

; (square-list (list 1 2 3 4))
;;Value 14: ((((() . 1) . 4) . 9) . 16)
; consの後ろはlistにならなければならない。
; 書きなおすとしたら以下のようにする。

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (append answer
                  (list (square (car things)))))))
  (iter items nil))

(square-list (list 1 2 3 4))
;Value 17: (1 4 9 16)

; 2.23
