; q4.5
; cond節のなかで<test> => <recipient>形式をサポートする
; condの中に入ってきたcarをevalしてtrueだったらcddarを返す

; condはcond->ifでifに変わってる

; 真ん中が=>だったらcond-recipientということにする
(define (cond-recipient? clause)
  (tagged-list? (cadr clause) '=>))

(define (eval-recipient clause)
  (let (ret (eval (car clause)))
  (if ret (eval (caddr clause) ret))))

(define (cond-predicate clause)
  (if (cond-recipient? clause)
    (eval-recipient clause)
    (car clause)))
