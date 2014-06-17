; q4.40

; 人の階への割り当てについて、すでに除外されている部分は計算させないようにambを構成する
; original from q4.38
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
  (let ((baker (amb 1 2 3 4 5)))
    (require (not (= baker 5)))
    (let ((fletcher (amb (1 2 3 4 5))))
      (require (not (= fletcher 5)))
      (require (not (= fletcher 1)))
      (require (distinct? (list baker fletcher)))
      (let ((cooper (amb (1 2 3 4 5))))
        (require (not (= cooper 1)))
        (require (not (= (abs (- fletcher cooper)) 1)))
        (require (distinct? (list baker fletcher cooper)))
        (let ((smith (amb 1 2 3 4 5)))
          (require (> miller cooper))
          (require (not (= (abs (- smith fletcher)) 1)))
          (require (distinct? (list baker fletcher cooper smith)))
          (let ((miller (amb 1 2 3 4 5)))
            (require
              (distinct? (list baker cooper fletcher miller smith)))
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))))))

(multiple-dwelling)

; 動かない？
