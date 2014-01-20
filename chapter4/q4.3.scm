; q4.3

; データ手動の流儀で

; たしかデータの型というか、種類によって呼び出される手続きが異なるような感じにすればよいはず
; 評価系に依存する部分だけをcondで比較して、あとはgetだったはず
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        (else ((get 'eval (first-exp exp)) (rest-exps exp) env)))))

; primitiveな表現だけevalに持っておいて、あとは表でやる
