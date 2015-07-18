; q5.25
;
; 積極制御評価器で正規順序での評価を行うようにする
; 必要になった時に評価させるようにすれば良い
;
; http://sicp.iijlab.net/fulltext/x421.html
;
; (define (try a b)
;   (if (= a 0) 1 b))
;
; の
;
; (try 0 (/ 1 0))
;
; とかが通るようにする。
; つまり、expがprimitiveな場合にのみdispatchするようにしてあげればよい
; ev-definitionで、definition-valueをexpに退避させて、定義する値を評価してしまっているんだけど
; これを最後の最後で評価させるように変更すれば良い
; 幸い、評価されていないexpはprimitiveになるまで評価され続けるので、
; この部分でexpがevalされなければ大丈夫、なはず
ev-definition
  (assign unev (op definition-variable) (reg exp))
  (save unev)
  (assign exp (op definition-value) (reg exp))
  (save env)
  (save continue)
  (assign continue (label ev-definition-1))
  (goto (label eval-dispatch))
ev-definition-1
  (restore continue)
  (restore env)
  (restore unev)
  (perform
   (op define-variable!) (reg unev) (reg val) (reg env))
  (assign val (const ok))
  (goto (reg continue))

; と思ったが、そうすると全て評価されなくなってしまう気がしてきた
; というか、defineするところ以外でも、ifだったりあらゆるところで
; その式が評価される場合というのはある
; ifの条件節だと実際の値を返して欲しくなるはずである
;
; 意外と、
;
; http://sicp.iijlab.net/fulltext/x422.html
;
; を置き換えて実装したほうが楽な気がしてきた
;
; delay-itとforce-itは使えるものとする
; operationsに追加しておいた


