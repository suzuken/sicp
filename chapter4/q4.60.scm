; q4.60
;
(rule (lives-near ?person-1 ?person-2)
      (and (address ?person-1 (?town . ?rest-1))
           (address ?person-2 (?town . ?rest-2))
           (not (same ?person-1 ?person-2))))

;;; ;;; Query input:
;;; (lives-near ?person (Hacker Alyssa P))
;;;
;;; ;;; Query results:
;;; (lives-near (Fect Cy D) (Hacker Alyssa P))
;;;
;;; ;;; Query input:
;;; (lives-near ?person-1 ?person-2)
;;;
;;; ;;; Query results:
;;; (lives-near (Aull DeWitt) (Reasoner Louis))
;;; (lives-near (Aull DeWitt) (Bitdiddle Ben))
;;; (lives-near (Reasoner Louis) (Aull DeWitt))
;;; (lives-near (Reasoner Louis) (Bitdiddle Ben))
;;; (lives-near (Hacker Alyssa P) (Fect Cy D))
;;; (lives-near (Fect Cy D) (Hacker Alyssa P))
;;; (lives-near (Bitdiddle Ben) (Aull DeWitt))
;;; (lives-near (Bitdiddle Ben) (Reasoner Louis))

; lives-nearから出力される結果がuniqな組み合わせであることを保証していないから
; query resultsを返す際に、結果をuniqueにするような実装にすると良いだろう。
; ただし、全ての手続き及び規則についてそれを行うのではなく、選択的に行えるようにする必要がある
