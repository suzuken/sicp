; q4.70

; よくないadd-assertion!の実装
(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (set! THE-ASSERTIONS
    (cons-stream assertion THE-ASSERTIONS))
  'ok)

; 今の実装
(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
      (cons-stream assertion old-assertions))
    'ok))

; 良くない方をつかってしまおうと、THE-ASSERTIONSをset!する際に環境が作られなくなってしまうため
; 一旦old-assertionsとして束縛することで、THE-ASSERTIONSに正常に表明を追加できる
