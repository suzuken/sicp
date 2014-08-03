; q4.63
(assert! (son Adam Cain))
(assert! (son Cain Enoch))
(assert! (son Enoch Irad))
(assert! (son Irad Mehujael))
(assert! (son Mehujael Methushael))
(assert! (son Methushael Lamech))
(assert! (wife Lamech Ada))
(assert! (son Ada Jabal))
(assert! (son Ada Jubal))

; grandsonの規則を作る
(rule (grandson ?g ?s)
      (and (son ?f ?s)
           (son ?g ?f)))

(rule (son ?m ?s)
      (and (wife ?m ?w)
           (son ?w ?s)))

(assert! (rule (grandson ?g ?s) (and (son ?f ?s) (son ?g ?f))))
(assert! (rule (son ?m ?s) (and (wife ?m ?w) (son ?w ?s))))
(grandson Cain ?s)
(grandson Methushael ?who)
