; 4.38

; 単純にパズル
;
; miller
; cooper
; baker
; fletcher
; smith

; millerはcooperより上で、cooperは1階ではないので、3-5階
; miller 3 4 5
; cooper 2 3 4 5
; baker 1 2 3 4
; fletcher 2 3 4
; smith 制限なし

; original
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

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require
      (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))

(multiple-dwelling)

; q 4.38
(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require
      (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    ; (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))

; 実行結果

; ;;; Amb-Eval input:
; (multiple-dwelling)
; 
; ;;; Starting a new problem
; ;;; Amb-Eval value:
; ((baker 1) (cooper 2) (fletcher 4) (miller 3) (smith 5))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; ((baker 1) (cooper 2) (fletcher 4) (miller 5) (smith 3))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; ((baker 1) (cooper 4) (fletcher 2) (miller 5) (smith 3))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; ((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; ((baker 3) (cooper 4) (fletcher 2) (miller 5) (smith 1))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; ((baker 5) (cooper 2) (fletcher 4) (miller 3) (smith 1))

; 6通り
