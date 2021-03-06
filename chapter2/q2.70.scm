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

; 2.70
; まず、木を作っておく
(define rock-tree (generate-huffman-tree '((A 2) (BOOM 1) (GET 2) (JOB 2) (NA 16) (SHA 3) (YIP 9) (WAH 1))))

(define rock-message (encode '(GET A JOB SHA NA NA NA NA NA NA NA NA GET A JOB SHA NA NA NA NA NA NA NA NA WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP SHA BOOM) rock-tree))
(print rock-message)
(print (length rock-message))
(print (decode rock-message rock-tree))

; 固定長符号だと、8記号なら3ビット。36単語 * 3 = 108必要なはず。上だと84ビット。お得？残り24ビットで符号化木送れば効率的？
