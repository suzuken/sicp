; 処理系のテスト
(use gauche.test)
(test-start "超循環処理系のテスト")
(load "./s1.scm")

(define (test-helper description expected exps)
  (let ((ret (eval exps the-global-environment)))
    (test description expected (lambda () ret))))

(test-section "self-evaluating")
(test-helper "eval primitive integer" 1 1)
(test-helper "eval primitive string" "hoge" "hoge")
(test-helper "sum" 3 (+ 1 2))

(test-section "variable, begin and definition")
(test-helper "simple define" 3 (begin (define x 3) x))

(test-helper "begin and define" 3 (begin (define (inc x) (+ x 1)) (inc 2)))

(test-section "lambda")
(test-helper "simple lambda" 2 ((lambda (a b) (+ a b)) 1 1))

(test-section "")
