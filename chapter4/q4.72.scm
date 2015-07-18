; q4.72
;
; disjoinとstream-flatmapが, 単に連接しないで, ストリームを差込みにするのはなぜか. 差込みがうまく働くのが分る例を示せ. (ヒント: 3.5.3節でinterleaveを使ったのはなぜか.)
;
; streamをinterleaveにしているのは、streamを片方のみを追いすぎず、順にcarするためである
; 片方のorで取得するストリームが無限になっていても、もう片方のストリームがいい感じに混ざるようになる
;
; 例
(assert! (married Minnie Mickey))
(assert! (rule (married ?x ?y)
               (married ?y ?x)))
(married Mickey ?who)

