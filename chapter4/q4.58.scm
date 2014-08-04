; q4.58

; big shotのruleをつくる
(rule (bigshot ?name ?division)
      (and (job ?name (?division . ?rest))
           (or (not (supervisor ?name ?boss))
               (and (supervisor ?name ?boss)
                    (not (job ?boss (?disivion . ?rest)))))))
