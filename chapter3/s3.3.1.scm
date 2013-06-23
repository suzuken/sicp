; 3.3 可変データのモデル化

(define (my-cons x y)
  (let ((new (get-new-pair)))
    (set-car! new x)
    (set-cdr! new y)
    new))
