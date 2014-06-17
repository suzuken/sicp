; q4.43
(define amb '())
(define (require p)
  (if (not p) (amb)))

(define (member obj lst)
  (cond ((null? lst) false)
        ((eq? obj (car lst)) lst)
        (else (member obj (cdr lst)))))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (and a b)
  (if a (if b true false) false))
(define (or a b)
  (if a true (if b true false)))
(define (xor a b)
  (or (and a (not b)) (and (not a) b)))

(define (daughter)
  (let ((moore (amb 'gabrielle 'lorna 'rosalind 'melissa 'mary))
        (downing (amb 'gabrielle 'lorna 'rosalind 'melissa 'mary))
        (hall (amb 'gabrielle 'lorna 'rosalind 'melissa 'mary))
        (barnacle (amb 'gabrielle 'lorna 'rosalind 'melissa 'mary))
        (parker (amb 'gabrielle 'lorna 'rosalind 'melissa 'mary)))
    (require
      (distinct? (list moore downing hall barnacle parker)))
    ; has yacht
    (require (not (eq? barnacle 'gabrielle)))
    (require (not (eq? moore 'lorna)))
    (require (not (eq? hall 'rosalind)))
    (require (not (eq? downing 'melissa)))
    (require (eq? barnacle 'melissa))

    ; Mary Ann "Moore"
    (require (eq? moore 'mary))
    ; Gabrielleの父親はParker博士の娘の名前をつけたヨットを持っている.
    (require (not (eq? parker 'gabrielle)))

    (list (list 'moore moore)
          (list 'downing downing)
          (list 'hall hall)
          (list 'barnacle barnacle)
          (list 'parker parker))))

(daughter)
try-again

; Amb-Eval input:
;
; ;;; Starting a new problem
; ;;; Amb-Eval value:
; ((moore mary) (downing gabrielle) (hall lorna) (barnacle melissa) (parker rosalind))
;
; ;;; Amb-Eval input:
;
; ;;; Amb-Eval value:
; ((moore mary) (downing lorna) (hall gabrielle) (barnacle melissa) (parker rosalind))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore mary) (downing rosalind) (hall gabrielle) (barnacle melissa) (parker lorna))
;
; ;;; Amb-Eval input:
; try-again
; (daughter)
;
; 3通り

; Mary Annの姓がMooreと言われない場合
; ;;; Amb-Eval input:
;
; ;;; Starting a new problem
; ;;; Amb-Eval value:
; ((moore gabrielle) (downing lorna) (hall mary) (barnacle melissa) (parker rosalind))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore gabrielle) (downing rosalind) (hall lorna) (barnacle melissa) (parker mary))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore gabrielle) (downing rosalind) (hall mary) (barnacle melissa) (parker lorna))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore gabrielle) (downing mary) (hall lorna) (barnacle melissa) (parker rosalind))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore rosalind) (downing gabrielle) (hall lorna) (barnacle melissa) (parker mary))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore rosalind) (downing gabrielle) (hall mary) (barnacle melissa) (parker lorna))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore rosalind) (downing lorna) (hall gabrielle) (barnacle melissa) (parker mary))
;
; ;;; Amb-Eval input:
; try-again
;
; Amb-Eval value:
; ((moore rosalind) (downing mary) (hall gabrielle) (barnacle melissa) (parker lorna))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore mary) (downing gabrielle) (hall lorna) (barnacle melissa) (parker rosalind))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore mary) (downing lorna) (hall gabrielle) (barnacle melissa) (parker rosalind))
;
; ;;; Amb-Eval input:
; try-again
;
; ;;; Amb-Eval value:
; ((moore mary) (downing rosalind) (hall gabrielle) (barnacle melissa) (parker lorna))
;
; ;;; Amb-Eval input:
; try-again
; (daughter)
;
; 12通り？ lornaの父親になるのは3通り
