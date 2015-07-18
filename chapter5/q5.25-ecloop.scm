; q5.25の解答となるループ
(load "./register-machine.scm")
(load "./operations.scm")
(load "./q5.25-eceval.scm")

(define the-global-environment (setup-environment))
(start eceval)
