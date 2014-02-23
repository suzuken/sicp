; q4.11

; フレームをリストの対ではなく名前-値の対であるような束縛のリストで。
;
; 現状のフレームはmake-frameでやっているように
;
; (define (make-frame variables values)
;   (cons variables values))
;
; なので、(cons (k1 k2 k3 ...) (v1 v2 v3 ...)) みたいになってる。
; これを '((k1 v1) (k2 v2) (k3 v3) ...) みたいにしたい。

(load "./s1.scm")

(define (make-frame variables values)
  (define (make-pair k v)
    (list ((cons (car k) (car v))
           (make-pair (cdr k) (cdr v)))))
  (make-pair variables values))

(define (frame-variables frame)
  (map car frame))

(define (frame-values frame)
  (map cadr frame))

; carに対を加えれば良い
(define (add-binding-to-frame! var val frame)
  (set! frame (cons (cons var val) frame)))

; lookup-variable-valueはそのまま
; set-variable-value!もそのまま
; define-variable!もそのまま
