; q4.75
;
; uniqueの実装

(load "./query.scm")

(define (empty-assertion? exps) (null? exps))
(define (first-assertion exps) (car exps))
(define (rest-assertions exps) (cdr exps))

(define assertion-counter 0)

; uniqueは指定した質問を満足する項目がデータベースに唯一つある時に成功する.
; 表明の保持は一つのassertionsの中でuniqにする
(define (uniquely-asserted assertions frame-stream)
  (if (empty-assertion? assertions)
    frame-stream
    (uniquely-asserted (rest-assertions assertions)
                       (qeval (first-assertion assertions)
                              frame-stream))))

(put 'unique 'qeval uniquely-asserted)
