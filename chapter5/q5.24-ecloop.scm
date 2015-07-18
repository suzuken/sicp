; q5.24の解答となるループ
(load "./register-machine.scm")
(load "./operations.scm")
(load "./q5.24-eceval.scm")

(define the-global-environment (setup-environment))
(start eceval)
