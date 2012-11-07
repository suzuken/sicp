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

; goshでsquareが使えないのでここで定義
(define (square x)
  (* x x))

;(print (square 3))

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
; TODO: lastがnilかどうかで判断する

(define (last-pair items)
  (list(list-ref items (- (length items) 1))))

;(print squares)
;(print (last-pair squares))
;(last-pair odds)

; 2.18
; TODO: 計算量減らそう
; 線形反復プロセスで書こう

(define (reverse items)
  (if (null? (cdr items))
    items
    (append (reverse (cdr items)) (list(car items)))))

(define (reverse items)
  (if (null? (cdr items))
    items
    (cons (reverse (cdr items)) (car items))))

; (print (reverse squares))

; 2.19
; 計算量はやはり異なるっぽい

; 1.2.2
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
  (print "hoge")
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
          (+ (cc amount
                  (except-first-denomination coin-values))
              (cc (- amount
                     (first-denomination coin-values))
                  coin-values)))))

; (print (first-denomination us-coins))
; (print (first-denomination uk-coins))
; (print (except-first-denomination us-coins))


;(print (cc 100 us-coins))
;(cc 100 uk-coins)

;(define sample-coins (list 1 5 10 250 500))
;(define sample-coins (list 1 5 10 250 500))
;(define us-coins (list 50 25 10 5 1))

;(print (cc 100000 (reverse sample-coins)))
;(print (cc 500 (reverse us-coins)))


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

;(print (same-parity 1 2 3 4 5 6 7))

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
    (cons (square (car items))
          (square-list (cdr items)))))

(define (square-list items)
  (map square items))

;(print (square-list (list 1 2 3 4)))

; 2.22

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (cons (square (car things))
                  answer))))
  (iter items nil))

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
;
;;Value 14: ((((() . 1) . 4) . 9) . 16)
;;
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

;(square-list (list 1 2 3 4))
;Value 17: (1 4 9 16)

; 2.23

(define (for-each proc items)
  (cond ((null? items) #t)
        (else
          (proc (car items))
          (for-each proc (cdr items)))))

;(for-each (lambda (x) (newline) (display x))
;         (list 57 321 88))

(define (count-leaves x)
  (cond ((null? x) 0)
		((not (pair? x)) 1)
		(else (+ (count-leaves (car x))
				 (count-leaves (cdr x))))))

; 2.24
; (list 1 (list 2 (list 3 4)))

; 以下の様な形になる
; (1 (2 (3 4)))
; 1 | (2 (3 4))
; 1 | 2 | (3 4)
; 1 | 2 | 3 | 4

; 2.25
;(print (car (cdr (car (cdr (cdr (list 1 3 (list 5 7) 9)))))))

;(print (car (car ((7)))))

; 2.27
;(print reverse)
(define (deep-reverse src-items)
  (if (list? src-items)
	(reverse (map deep-reverse src-items))
	src-items))

; (print (deep-reverse (list 1 3 (list 5 7) 9)))
; (print (deep-reverse (list 1 (list 5 7) 9)))
; (print (deep-reverse (list (cons 1 2) (cons 3 4))))
; (print (count-leaves (list (cons 1 2) (cons 3 4))))


(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))

;(print (accumulate + 0 (list 1 2 3 4 5)))
; 15

; 2.33
(define (my-map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

;置き換え
; (my-map square (list 1 2))
; (accumulate (lambda (x y) (cons (square x) y)) nil (list 1 2))
; ((lambda (x y) (cons (square x) y)) (car (list 1 2))
;     (accumulate (lambda (x y) (cons (square x) y)) nil (cdr (list 1 2))))
; ((lambda (x y) (cons (square x) y)) 1
;     (accumulate (lambda (x y) (cons (square x) y)) nil (list 2)))
; ((lambda (x y) (cons (square x) y)) 1
;     ((lambda (x y) (cons (square x) y) 2 nil)))
; ((lambda (x y) (cons (square x) y)) 1
;     (cons(square 2) nil))
; ((lambda (x y) (cons (square x) y)) 1 (list 4))
; (cons (square 1) (list 4))
; (list 1 4)
;
; つまり、
;
; (accumulate op iniital sequence)
; (op s1
;   (op s2
;     (op s3
;     ......
;       (op sn
;           ini))))))))))
;
; 的な感じになる
;
; ※ consのcdrがlistのものがlist！

; For my reference
;(define (append list1 list2)
;  (if (null? list1)
;    list2
;    (cons (car list1) (append (cdr list1) list2))))

(define (my-append seq1 seq2)
  (accumulate cons seq2 seq1))

; (print (append (list 1 2 3)(list 4 5 6)))
; (print (my-append (list 1 2 3)(list 4 5 6)))

;置き換え
; (my-append (list 1 2) (list 3 4))
; (accumulate cons (list 3 4) (list 1 2))
; (cons (car (list 1 2)) (accumulate cons (list 3 4) (cdr (list 1 2))))
; (cons 1 (accumulate cons (list 3 4) (list 2)))
; (cons 1 (accumulate cons (list 3 4) (list 2)))
; (cons 1 (cons 2 (accumulate cons (list 3 4) nil)))
; (cons 1 (cons 2 (list 3 4)))
; (list 1 2 3 4)

(define (my-length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

; (print (length (list 2 3 4 5)))
; (print (my-length (list 2 3 4 5)))

; 2.34
