; q4.69

; 規則greatをつくる

; q4.63より
(assert! (son Adam Cain))
(assert! (son Cain Enoch))
(assert! (son Enoch Irad))
(assert! (son Irad Mehujael))
(assert! (son Mehujael Methushael))
(assert! (son Methushael Lamech))
(assert! (wife Lamech Ada))
(assert! (son Ada Jabal))
(assert! (son Ada Jubal))

; 「SがFの息子であり, かつFがGの息子であるなら, SはGの孫[grandson]である」
(assert! (rule (grandson-of ?g ?s)
               (and (son-of ?f ?s)
                    (son-of ?g ?f))))

; 「WがMの妻であり, かつSがWの息子であるなら, SはMの息子である」
(assert! (rule (son-of ?m ?s)
               (or (son ?m ?s)
                   (and (wife ?m ?w)
                        (son ?w ?s)))))

; 問題4.63のデータベースとそこで形式化した規則から始めて, 孫の関係に「great[孫の子]」を追加する規則を考案せよ. これによりシステムはIradはAdamの孫の子[great-grandson]である, JabalとJubalはAdamの孫の子の子の子の子の子[great-great-great-great-great-grandson]であると推論出来る. (ヒント: 例えばIradについての事実を((great grandson) Adam Irad)のように表そう. リストの最後が語grandsonで終るかどうかを見る規則を書く. ?relをgrandsonで終るリストとし, 関係((great . ?rel) ?x ?y)を導く規則を表すのにこれを使え.) 出来た規則を((great grandson) ?g ?ggs)や(?relationship Adam Irad)のような質問でチェックせよ.
;
; greatは孫の子供のことを示す
; ?xが孫で、?wがその子どもとなる。
; ?relは?wと?yの関係性を示していて、greatやson-ofがはいる
(assert! (rule ((great . ?rel) ?x ?y)
               (and (son-of ?x ?w)
                    (?rel ?w ?y))))
(assert! (rule ((grandson) ?x ?y)
               (grandson-of ?x ?y)))

;;; ;;; Query input:
;;; (?relationship Adam Irad)
;;;
;;; ;;; Query results:
;;; ((great grandson) Adam Irad)
;;; ((great great . son) Adam Irad)
;;; ((great . grandson-of) Adam Irad)
;;; ((great great . son-of) Adam Irad)
;;;

;;; Query input:
;;; ((great grandson) ?g ?ggs)
;;;
;;; ;;; Query results:
;;; ((great grandson) Mehujael Jubal)
;;; ((great grandson) Irad Lamech)
;;; ((great grandson) Mehujael Jabal)
;;; ((great grandson) Enoch Methushael)
;;; ((great grandson) Cain Mehujael)
;;; ((great grandson) Adam Irad)
;;;
