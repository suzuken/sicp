; 積極制御評価器の駆動ループ
(load "./register-machine.scm")
(load "./operations.scm")
(load "./eceval.scm")

(define the-global-environment (setup-environment))
(start eceval)
