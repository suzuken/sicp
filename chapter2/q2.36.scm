(load "./s2.2.scm")

; 2.36

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
    nil
    (cons (accumulate op init (map car seqs))
          (accumulate-n op init (map cdr seqs)))))

; (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)) から (list 1 4 7 10)をどうつくるか
; それぞれ先頭の要素をcarで取り出せれば良い
;
; (map (lambda (x) (car x)) seqs) -> (map car seqs)

(use gauche.test)
(test* "hoge" (list 22 26 30) (accumulate-n + 0 (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12))))
