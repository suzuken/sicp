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

; 重みによって並び替えてsetをつくる
(define (adjoin-set x set)
    (cond ((null? set) (list x))
          ((< (weight x) (weight (car set))) (cons x set))
          (else (cons (car set)
                      (adjoin-set x (cdr set))))))

; 対のリストを葉の順序付けられた集合へ変換する。
(define (make-leaf-set pairs)
    (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair) ;記号
                               (cadr pair))
                    (make-leaf-set (cdr pairs))))))

;2.69
;記号と頻度の対のリストを取り、huffman符号化木を生成する
(define (generate-huffman-tree pairs)
    (successive-merge (make-leaf-set pairs)))

; make-code-treeを使い、集合の最小重みの要素を順に合体させ、要素がひとつになったら止める。
(define (successive-merge set)
  (if (null? (cdr set))
    (car set)
    (successive-merge
      (adjoin-set
        (make-code-tree (car set) (cadr set))
      (cddr set)))))

;(print (make-leaf-set '((A 4) (B 2) (D 1) (C 1))))
(print (generate-huffman-tree '((A 4) (B 2) (D 1) (C 1))))
