; q5.28 末尾再帰しない評価器
(load "./register-machine.scm")
(load "./operations.scm")
(load "./q5.28-eceval.scm")

(define the-global-environment (setup-environment))
(start eceval)
