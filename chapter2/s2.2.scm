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

; (define (map proc items)
;   (if (null? items)
;     nil
;     (cons (proc (car items))
;           (map proc (cdr items)))))
;
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

; 2.34
(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))

; (print (horner-eval 2 (list 1 3 0 5 0 1)))
; ->79
;
; (x=2) 1 + 3x + 5x^3 + x^5
; 1 + x * ( high )
; 1 + x * ( 3 + x * ( high ))
; 1 + x * ( 3 + x * ( 0 + x * ( high )))
; 1 + x * ( 3 + x * ( 0 + x * ( 5 + x * ( high ))))
; 1 + x * ( 3 + x * ( 0 + x * ( 5 + x * ( 0 + x * ( high )))))
; 1 + x * ( 3 + x * ( 0 + x * ( 5 + x * ( 0 + x * ( 1  + x * (0))))))

; 2.35
;
; (define (count-leaves x)
;   (cond ((null? x) 0)
;         ((not (pair? x)) 1)
;         (else (+ (count-leaves (car x))
;                  (count-leaves (cdr x))))))

; 穴埋め
(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

(define (count-leaves-acc t)
  (accumulate + 0 (map (lambda (x) 1) (enumerate-tree t))))

; (print (count-leaves-acc (list 1 2 3 4 5)))
; -> 5

; 2.36

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
    nil
    (cons (accumulate op init (map car seqs))
          (accumulate-n op init (map cdr seqs)))))

; (print (accumulate-n + 0 (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12))))
; -> (22 26 30)

; (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)) から (list 1 4 7 10)をどうつくるか
; それぞれ先頭の要素をcarで取り出せれば良い
;
; (map (lambda (x) (car x)) seqs) -> (map car seqs)

; 2.37
(define mat (list (list 1 2) (list 3 4)))
(define vec (list 1 1))

; 内積
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

; (print (dot-product vec vec))

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (matrix-*-vector cols row)) m)))

; 2.38


; p.71

; (accumulate append
;             nil
;             (map (lambda (i)
;                    (map (lambda (j) (list i j))
;                         (enumerate-interval i (- i 1))))
;                  (enumerate-interval 1 n)))

(define (enumerate-interval low high)
  (if (> low high)
    nil
    (cons low (enumerate-interval (+ low 1) high))))

;(print (enumerate-interval 2 6))

(accumulate append
            nil
            (map (lambda (i)
                   (map (lambda (j) (list i j))
                        (enumerate-interval 1 (- i 1))))
                 (enumerate-interval 1 6)))

; ちなみに置き換えると
(accumulate append
            nil
            (map (lambda (i)
                   (map (lambda (j) (list i j))
                        (enumerate-interval 1 (- i 1))))
                 (enumerate-interval 1 2)))

(accumulate append
            nil
            (map (lambda (i)
                   (map (lambda (j) (list i j))
                        (enumerate-interval 1 (- i 1))))
                 (list 1 2)))

(accumulate append
            nil
            (list ((lambda (i)
                   (map (lambda (j) (list i j))
                        (enumerate-interval 1 (- i 1)))) 1)
                  ((lambda (i)
                   (map (lambda (j) (list i j))
                        (enumerate-interval 1 (- i 1)))) 2)))

(accumulate append
            nil
            (list
              (map (lambda (j) (list 1 j))
                   (enumerate-interval 1 (- 1 1)))
              (map (lambda (j) (list 2 j))
                   (enumerate-interval 1 (- 2 1)))
              ))

(accumulate append
            nil
            (list
              (map (lambda (j) (list 1 j))
                   (enumerate-interval 1 0))
              (map (lambda (j) (list 2 j))
                   (enumerate-interval 1 1))
              ))

(accumulate append
            nil
            (list
              (map (lambda (j) (list 1 j))
                   nil)
              (map (lambda (j) (list 2 j))
                   (list 1))
              ))

(accumulate append
            nil
            (list
              nil
              (list (list 2 1))
              ))

(accumulate append
            nil
            (list nil (list (list 2 1))))



(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

; 素数か否か
(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

; goshにはないので定義した
(define (prime? n)
  (let ((m (sqrt n)))
    (let loop ((i 2))
      (or (< m i)
          (and (not (zero? (modulo n i)))
               (loop (+ i (if (= i 2) 1 2))))))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (flatmap
                 (lambda (i)
                   (map (lambda (j) (list i j))
                        (enumerate-interval 1 (- i 1))))
                 (enumerate-interval 1 n)))))

; (print (prime-sum-pairs 6))
