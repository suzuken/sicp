; q4.68

; reverse演算の実装
;
; 問題 2.18 (抜粋)
;
; 引数としてリストをとり, 同じ要素の逆順のリストを返す手続きreverse演算を実装する規則を定義する
;
; (reverse (list 1 4 9 16 25))
; (25 16 9 4 1)
;
; これと同じように逆順に含むリストを返す

(rule (append-to-form () ?y ?y))
(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))


(rule (reverse (?x . ?y))
      (and (reverse ?y ?reversed)
           (append-to-form ?reversed (?x) ?y)))

