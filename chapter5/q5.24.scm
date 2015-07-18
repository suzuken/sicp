; q5.24
;
; cond->ifで単純に簡約せずに基本特殊形式として実装し直す問題
; 述語を順に評価して、trueだったらbodyをevalするような作りにすればいいはず
ev-cond
  ; loopのため、述語の環境を保存させる
  (assign unev (op cond-clauses) (reg exp))
  (save continue)
  (goto (label ev-cond-loop))
ev-cond-loop
  ; expはclauseになっている
  ; 先頭の句を評価していく
  (assign exp (op car) (reg unev))

  (test (op cond-else-clause?) (reg exp))
  (branch (label ev-cond-else))

  (save exp)
  ; elseではないので評価を行う。
  (assign exp (op cond-predicate) (reg exp))
  (save unev)
  (save env)
  (assign continue (label ev-cond-decide))
  (goto (label eval-dispatch))

ev-cond-else
  ; 並びの評価ではunevをわたす
  (assign unev (op cond-actions) (reg exp))
  ; expをそのまま実行させる
  (goto (label ev-sequence))

ev-cond-decide
  (restore env)
  (restore unev)
  (restore exp)
  ; cond句の中の条件節を評価する
  (test (op true?) (reg val))
  (branch (label ev-cond-consequent))
  ; このcond句は条件が満たされなかったので、condの続きを渡してloopに渡す
  (assign unev (op cdr) (reg unev))
  (goto (label ev-cond-loop))

ev-cond-consequent
  ; 真だったcondの結果の句について、unevとして評価させる
  (assign unev (op cond-actions) (reg exp))
  ; 評価の場のexpは変わらず
  (goto (label ev-sequence))

; テスト
; gosh q5.24-ecloop.scm

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
(total-pushes = 17 maximum-depth = 9)

;;; EC-Eval value:
2

;;; EC-Eval input:
(cond-test 0)
(total-pushes = 28 maximum-depth = 9)

;;; EC-Eval value:
(zero)

;;; EC-Eval input:
(cond-test -5)
(total-pushes = 33 maximum-depth = 9)

;;; EC-Eval value:
5
