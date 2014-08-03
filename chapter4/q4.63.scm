; q4.63
;
; ref. http://en.wikipedia.org/wiki/Generations_of_Adam
; CainはAdamの息子 etc.
(assert! (son Adam Cain))
(assert! (son Cain Enoch))
(assert! (son Enoch Irad))
(assert! (son Irad Mehujael))
(assert! (son Mehujael Methushael))
(assert! (son Methushael Lamech))
(assert! (wife Lamech Ada))  ; AdaはLamechの妻
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

(grandson-of Cain ?who)
(grandson-of Methushael ?s)

; 結果
;;; Query input:
;;; (grandson-of Cain ?who)
;;;
;;; ;;; Query results:
;;; (grandson-of Cain Irad)
;;;
;;; ;;; Query input:
;;; (grandson-of Methushael ?s)
;;;
;;; ;;; Query results:
;;; (grandson-of Methushael Jubal)
;;; (grandson-of Methushael Jabal)
