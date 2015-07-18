; q5.23
; condやletを評価器でつかえるようにする
; 
; まずはifをつかってcondを表現する

; cond->ifという構文変換器がcond式をifに変換することとする
; (cond ((= 0 x) ('hoge))
;       ((null? x) ('oh null)
;       (else ('hoge))))

; まず、eval-dispatchに

eval-dispatch
  (test (op self-evaluating?) (reg exp))
  (branch (label ev-self-eval))
  (test (op variable?) (reg exp))
  (branch (label ev-variable))
  (test (op quoted?) (reg exp))
  (branch (label ev-quoted))
  (test (op assignment?) (reg exp))
  (branch (label ev-assignment))
  (test (op definition?) (reg exp))
  (branch (label ev-definition))
  (test (op if?) (reg exp))
  (branch (label ev-if))
  ; 追加した
  (test (op cond?) (reg exp))
  (branch (label ev-cond))
  (test (op lambda?) (reg exp))
  (branch (label ev-lambda))
  (test (op begin?) (reg exp))
  (branch (label ev-begin))
  (test (op application?) (reg exp))
  (branch (label ev-application))
  (goto (label unknown-expression-type))

; という形でev-condへのテストと分岐を追加する
; cond->ifのoperationが使えるとして、condからifへの書き換えを行う

ev-cond
  (assign exp (op cond->if) (reg exp))
  (goto (label eval-dispatch))

; 同様にletも
ev-let
  (assign exp (op let->combination) (reg exp))
  (goto (label eval-dispatch))

; という感じに、とりあえず置き換えを行わせる
;
; 以下のとおり
;
; $ gosh q5.23-ecloop.scm
;;; EC-Eval input:
(define (cond-test x)
  (cond ((> x 0) x)
      ((= x 0) '(zero))
      (else (- x))))
(total-pushes = 3 maximum-depth = 3)

;;; EC-Eval value:
ok

;;; EC-Eval input:
(cond-test 2)
(cond-test 0)
(cond-test -5)
(total-pushes = 16 maximum-depth = 8)

;;; EC-Eval value:
2

;;; EC-Eval input:
(total-pushes = 27 maximum-depth = 8)

;;; EC-Eval value:
(zero)

;;; EC-Eval input:
(total-pushes = 32 maximum-depth = 8)

;;; EC-Eval value:
5



; letについてもテスト
;
;;; EC-Eval input:
(define (test-let x)
  (let ((hoge (+ x 1))) hoge))
(test-let 2)
(total-pushes = 3 maximum-depth = 3)

;;; EC-Eval value:
ok

;;; EC-Eval input:
(total-pushes = 18 maximum-depth = 8)

;;; EC-Eval value:
3

