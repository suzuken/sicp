(load "./s2.4.scm")

; 2.3.2節の記号微分プログラムをデータ主導型の形に変換する問題
(define (deriv exp var)
    (cond ((number? exp) 0)
          ((variable? exp) (if (same-variable? exp var) 1 0))
          ((sum? exp)
           (make-sum (deriv (addend exp) var)
                     (deriv (augend exp) var)))
          ((product? exp)
           (make-sum
             (make-product (multiplier exp)
                           (deriv (multiplicand exp) var))
             (make-product (deriv (multiplier exp) var)
                           (multiplicand exp))))
          (else (error "unknown expression type -- DERIV" exp))))


; データ主導型
; (get 'deriv (operator exp)) これがoperatorによって返ってくる手続きを返す
(define (deriv exp var)
    (cond ((number? exp) 0)
          ((variable? exp) (if (same-variable? exp var) 1 0))
          (else ((get 'deriv (operator exp)) (operands exp)
                                             var))))

(define (operator exp)
    (car exp))

(define (operands exp)
    (cdr exp))

; a. 上でやったことの説明。number?, variable?がデータ主導型の振り分けに吸収できない理由
;
; deriv手続きの中でderivの演算をする箇所、加算か乗算かで計算が変わる部分をデータ主導型に置き換えた。
; number?, variable?についてはこのパッケージで定義されているのではなくより上のレイヤーで切り替えているものなので、
; ここで切り替える必要はないし、そもそも加算か乗算かという切り替えの上の前の段階で必要。
;
; b. 和と積の微分の手続きを書き、上のプログラムで使う表に、それらを設定するのに必要な補助プログラムをかけ

(define (install-deriv-sum)
  ;... その他の関数
  ;
  (define (deriv-sum ops var)
     (make-sum (deriv (car ops) var)
               (deriv (cadr exp) var)))

  (put 'deriv '(sum) deriv-sum)
  'done)

(define (install-deriv-product)

  (define (deriv-product ops var)
     (make-sum
       (make-product (multiplier exp)
                     (deriv (multiplicand exp) var))
       (make-product (deriv (multiplier exp) var)
                     (multiplicand exp))))

  (put 'deriv '(product) deriv-product)
  'done)
