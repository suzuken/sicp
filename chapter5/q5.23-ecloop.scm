; q5.23の解答となるループ
(load "./register-machine.scm")
(load "./operations.scm")
(load "./q5.23-eceval.scm")

(define the-global-environment (setup-environment))
(start eceval)
