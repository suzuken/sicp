; q4.46

; amb評価器が左から右に評価しないと動かなくなる理由

; analyzeしているとlist-of-values的にevalの順番を制御できなくなるからか？
; list-of-valuesが全てのevalに対して利用できるのであれば、後に続く処理の制御を全て右から左へ制御できる。これはconsの引数をどちらから制御するかに依存して変えることができた。

; 4.2の場合にはactual-valueを利用して単なるevalの代わりに利用することができた。
; これをlist-of-arg-valuesの中で利用することによって遅延評価を実現している
; ここで利用されるconsが引数をどちらから制御するかに依存して、右から左に評価することお可能である

; ambを利用している場合にはこれを行うことができない
; (list (amb 1 2 3) (amb 'a 'b))を評価する場合、それぞれの可能性が曖昧に返される
; これらの各選択肢を分岐とし、各分岐での計算が続くと考えられるようにしている

; parse-sentenceの例で考える。
; これは語の並びに依存している。
; *unparsed* な状態をまずリストの最初にもっておき、処理される
; 右から評価するとparse-wordの処理を行う場合のword-listが*unparsed*になってしまう
; これによりmemqのxが*unparsed*となり、falseになってしまう。
; したがってparse-wordが通らなくなる。
