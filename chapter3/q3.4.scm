; q3.4

; 連続の失敗回数を記憶するようにする
(define (make-account balance password)
  (let ((count 0))
    (define (withdraw amount)
      (set! count 0)
      (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
    (define (deposit amount)
      (set! count 0)
      (set! balance (+ balance amount)))
    (define (incorrect amount)
      (set! count (+ count 1))
      (if (>= count 7)
        call-the-cops
        "Incorrect password"))
    (define call-the-cops "call-the-cops is called!")
    (define (dispatch p m)
      (if (eq? p password)
        (cond 
          ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT" m)))
        incorrect))
    dispatch))

(define acc (make-account 100 'secret-password))
;(print ((acc 'hoge-secret-password 'withdraw) 40))
;(print ((acc 'secret-password 'withdraw) 40))
;(print ((acc 'secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))
;(print ((acc 'hoge-secret-password 'deposit) 50))

; OUTPUT
;
;Incorrect password
;60
;110
;Incorrect password
;Incorrect password
;Incorrect password
;Incorrect password
;Incorrect password
;Incorrect password
;call-the-cops is called!
;160
;Incorrect password
;Incorrect password
;Incorrect password
;Incorrect password
;Incorrect password
;Incorrect password
;call-the-cops is called!
;call-the-cops is called!
