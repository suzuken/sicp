; q4.57

(rule (can-replace ?person1 ?person2)
      (or
        (and (job ?person1 ?job1)
             (job ?person2 ?job2)
             (same ?job1 ?job2)
             (not (same ?person1 ?person2)))
        (and (job ?person1 ?job1)
             (job ?person2 ?job2)
             (can-do-job ?job1 ?job2)
             (not (same ?person1 ?person2)))))

; a. Cy D. Fectに代れる人すべて;
(can-replace (Fect Cy D) ?person)

; b. 誰かに代れて, その誰かの方が多くの給料を貰っている人すべてと, 両者の給料.
(and (can-replace ?person1 ?person2)
     (salary ?person1 ?amount1)
     (salary ?person2 ?amount2)
     (lisp-value < ?amount1 ?amount2))

; person1が代わられる人
