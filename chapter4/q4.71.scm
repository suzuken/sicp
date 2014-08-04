; q4.71

(define (simple-query query-pattern frame-stream)
  (stream-flatmap
   (lambda (frame)
     (stream-append (find-assertions query-pattern frame)
                    (apply-rules query-pattern frame)))
   frame-stream))

(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (interleave
       (qeval (first-disjunct disjuncts) frame-stream)
       (disjoin (rest-disjuncts disjuncts) frame-stream))))

; 3.5.3より抜粋
(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

; Louis Reasonerの手続きではsimple-queryでruleのapplyにdelayを利用していない
; また、disjoinの際にもdisjoinの再帰をdelayしていない
;
; 望ましくない振る舞いとしては、orを使ったクエリで値を取り出す際におきるはず
; 全パターンを扱えなくなるのではないだろうか

; 参考になる規則
(assert! (rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (supervisor ?staff-person ?middle-manager)
               (outranked-by ?middle-manager ?boss))))

; 元の処理系

;;; Query input:
;;; (outranked-by ?x ?y)
;;;
;;; ;;; Query results:
;;; (outranked-by (Aull DeWitt) (Warbucks Oliver))
;;; (outranked-by (Cratchet Robert) (Warbucks Oliver))
;;; (outranked-by (Cratchet Robert) (Scrooge Eben))
;;; (outranked-by (Reasoner Louis) (Bitdiddle Ben))
;;; (outranked-by (Scrooge Eben) (Warbucks Oliver))
;;; (outranked-by (Tweakit Lem E) (Warbucks Oliver))
;;; (outranked-by (Bitdiddle Ben) (Warbucks Oliver))
;;; (outranked-by (Reasoner Louis) (Warbucks Oliver))
;;; (outranked-by (Reasoner Louis) (Hacker Alyssa P))
;;; (outranked-by (Fect Cy D) (Warbucks Oliver))
;;; (outranked-by (Tweakit Lem E) (Bitdiddle Ben))
;;; (outranked-by (Hacker Alyssa P) (Warbucks Oliver))
;;; (outranked-by (Fect Cy D) (Bitdiddle Ben))
;;; (outranked-by (Hacker Alyssa P) (Bitdiddle Ben))
;;;
;;;

; 単純なパターン

;;;
;;;;;; Query input:
;;;(outranked-by ?x ?y)
;;;
;;;

; or したものが前提となる条件がある場合、これを同期的に処理しなければならなくなるので、ループする
