; q3.3

; make-accountを修正する問題

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount)))
  (define (incorrect amount) "Incorrect password")
  (define (dispatch p m)
    (if (eq? p password)
      (cond 
        ((eq? m 'withdraw) withdraw)
        ((eq? m 'deposit) deposit)
        (else (error "Unknown request -- MAKE-ACCOUNT" m)))
      incorrect))
  dispatch)

(define acc (make-account 100 'secret-password))
(print ((acc 'hoge-secret-password 'withdraw) 40))
;Incorrect password
(print ((acc 'secret-password 'withdraw) 40))
;60
(print ((acc 'secret-password 'deposit) 50))
;110
(print ((acc 'hoge-secret-password 'deposit) 50))
;Incorrect password
