; pre-defined
(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (entry set)) true)
        ((< x (entry set))
         (element-of-set? x (left-branch set)))
        ((> x (entry set))
         (element-of-set? x (right-branch set)))))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
        ((= x (entry set)) set)
        ((< x (entry set))
         (make-tree (entry set)
                    (adjoin-set x (left-branch set))
                    (right-branch set)))
        ((> x (entry set))
         (make-tree (entry set)
                    (left-branch set)
                    (adjoin-set x (right-branch set))))))

; 2.64
(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
    (cons '() elts)
    (let ((left-size (quotient (- n 1) 2)))
      (let ((left-result (partial-tree elts left-size)))
        (let ((left-tree (car left-result))
              (non-left-elts (cdr left-result))
              (right-size (- n (+ left-size 1))))
          (let ((this-entry (car non-left-elts))
                (right-result (partial-tree (cdr non-left-elts)
                                            right-size)))
            (let ((right-tree (car right-result))
                  (remaining-elts (cdr right-result)))
              (cons (make-tree this-entry left-tree right-tree)
                    remaining-elts))))))))

; a. partial-treeがどう働くかを短く簡潔に書け
; -> 左側の要素と右側に残る要素をそれぞれ繰り返し部分木として各側に付け足していき、結果的にできた木をcar、あまった要素をcdrとして返す。
;
; '(1 3 5 7 9 11)に対して作る木をかけ

;quotientはあまりを捨てて整数で商を返す
;(print (quotient 10 2))
;-> 5
;(print (quotient 11 2))
;-> 5

;(print (list->tree '(1 3 5 7 9 11)))
;(5
;    (1
;        ()
;        (3 () ()))
;    (9
;        (7 () ())
;        (11 () ())))

; b. list->treeがn個の要素のリストを変換するのに必要なステップ数の増加の程度はどのくらいか
; -> log(n)では？
;
;(left-size (quotient (- n 1) 2)) でひとまず半分にリストを分けている
