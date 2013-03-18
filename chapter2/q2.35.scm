(load "./s2.2.scm")

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

; TESTTING

(use gauche.test)
(test* "count-leaves (list 1 2 3 4 5) is 5" 5 (count-leaves-acc (list 1 2 3 4 5)))
(test* "count-leaves (list 3 3) is 2" 2 (count-leaves-acc (list 3 3)))

