; huffman tree
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x)
  (cadr x))

(define (weight-leaf x)
  (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
    (list (symbol-leaf tree))
    (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
    (weight-leaf tree)
    (cadddr tree)))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
      (if (null? bits)
        '()
        (let ((next-branch
                (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
            (cons (symbol-leaf next-branch)
                  (decode-1 (cdr bits) tree))
            (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
    (cond ((= bit 0) (left-branch branch))
          ((= bit 1) (right-branch branch))
          (else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (adjoin-set x set)
    (cond ((null? set) (list x))
          ((< (weight x) (weight (car set))) (cons x set))
          (else (cons (car set)
                      (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
    (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)
                               (cadr pair))
                    (make-leaf-set (cdr pairs))))))

; 2.67
(define sample-tree
    (make-code-tree (make-leaf 'A 4)
                    (make-code-tree
                      (make-leaf 'B 2)
                      (make-code-tree (make-leaf 'D 1)
                                      (make-leaf 'C 1)))))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

;(print (decode sample-message sample-tree))
; (A D A B B C A)

; 2.68
;
(define (memq item x)
    (cond ((null? x) false)
          ((eq? item (car x)) x)
          (else (memq item (cdr x)))))

; 再帰的に通信文をencodeする
; 結果として符号のリストを返す
(define (encode message tree)
    (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

; 与えられた木に従って与えられた記号を符号化したビットのリストを返す
; まず、木に指定された符号が存在するか否かをチェック。
; あるなら探索開始。左に下れば0, 右に下れば1を追加する。見つかれば終了。
(define (encode-symbol symbol tree)
  (define (iter tree)
    (if (leaf? tree)
      '()
        (if (memq symbol (symbols (left-branch tree)))
          (cons 0 (iter (left-branch tree)))
          (cons 1 (iter (right-branch tree))))))
  (if (memq symbol (symbols tree))
    (iter tree)
    (error "記号が木に存在しません")))

(print (encode-symbol 'A sample-tree))
; '(0)
(print (encode-symbol 'B sample-tree))
; '(1 0)
(print (encode-symbol 'C sample-tree))
; '(1 1 1)
(print (encode-symbol 'D sample-tree))
; '(1 1 0)
(print (encode '(A D A B B C A) sample-tree))
; (0 1 1 0 0 1 0 1 0 1 1 1 0)
