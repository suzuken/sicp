; q4.56
; a. Ben Bitdiddleが監督している人すべての名前とその住所;
(and (supervisor ?name (Bitdiddle Ben))
     (address ?name ?address))

; b. 給料がBen Bitdiddleのそれより少ない人のすべてと, その人たちの給料と, Ben Bitdiddleの給料;
(and 
  (salary (Bitdiddle Ben) ?ben_salary)
  (lisp-value < ?amount ?ben_salary)
  (salary ?name ?amount))

; c. 計算機部門にいない人が監督している人すべてと, その監督者の名前と担当. 
(and
  (not (job ?name (computer . ?role)))
  (supervisor ?supervised ?name))
