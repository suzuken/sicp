(load "./s2.4.scm")
(load "./s2.5.scm")

; 2.84
;
; 2.83で作ったraiseの手続きを利用して、apply-generic手続きを書きなおせ、という問題。
; 引数を同じ型になるまで強制型変換するようにする。
; 2つの方のいずれかが等の中で高いかをテストする方法を考えなければならない。
; これをシステムの他の部分と「整合している」方法で行い、塔に新レベルを追加するときの問題を生じないようにせよ。
;
;
; なので、apply-genericを変えつつ、挙動を維持しつつ、強制型変換するようにする。
; 難点は「どちらの方が高いか」を判断する部分だろうか。さて。
; 型のリストを持っておいて、高い方を見つけるように？

; 最初の要素のほうが低い
(define tower '(integer rational real complex))

; t1とt2で低い方を返す
(define (lower t1 t2)
  (define (iter rest)
    (if (null? rest)
      (error "Tower of types is not defined. -- HIGHER" rest)
      (cond ((eq? t1 (car rest)) t1)
            ((eq? t2 (car rest)) t2)
            (else (iter (cdr rest))))))
  (iter tower))

; lower使って高いほう返す
(define (higher t1 t2)
  (let ((low-type (lower t1 t2)))
    (cond ((eq? t1 low-type) t2)
          ((eq? t2 low-type) t1)
          ((eq? low-type #f) #f)
          (else (error "illegal exception")))))

; とりあえずテストから書いておく
(use gauche.test)
(test-start "apply-generic-raise")
(test* "rational is higher than integer"
       'rational
       (higher 'rational 'integer))
(test* "real is higher than integer"
       'real
       (higher 'real 'integer))
(test* "when equals types, return itself"
       'real
       (higher 'real 'real))
(test-end)

; 2.5.2で出てきたget-coercionを利用したパターンではなく、
; 各型におけるraiseを呼ぶようにする。
;
;
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (if (= (length args) 2)
          (let ((type1 (car type-tags))
                (type2 (cadr type-tags))
                (a1 (car args))
                (a2 (cadr args)))
            (if (eq? type1 type2)
              (error "Same type is defined." (list op type-tags))
              ; lowerだったらraiseして回す
              (let ((low (lower type1 type2)))
                (cond ((eq? low type1) (apply-generic op ((raise low) a1) a2))
                      ((eq? low type2) (apply-generic op a1 ((raise low) a2)))
                      (else (error "Exception" (list op type-tags)))))))
          (error "arg length is not 2"))
        (error "No method for these types"
               (list op type-tags))))))

; ジャストアイディアだけど、もし等しくなかったら1つ目をraise
; また等しくなかったらまたraise
; もしraiseが定義されてなかったら終了
; 2つ目の引数でも同様に、とやれば、一応動きそう
; エレガントではないけど。
