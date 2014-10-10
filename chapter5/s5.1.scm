; s5.1

(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))

(define (remainder n d)
  (if (< n d)
    n
    (remainder (- n 1))))

; s5.1.1

; さっきのgcd計算をするための計算機を文章で記述したもの
(data-paths
  (registers
    ((name a)
     (buttons ((name a<-b) (source (register b)))))
    ((name b)
     (buttons ((name b<-t) (source (register t)))))
    ((name t)
     (buttons ((name t<-r) (source (operation rem))))))

  (operations
    ((name rem)
     (inputs (register a) (register b)))
    ((name =)
     (inputs (register b) (constant 0)))))

(controller
  test-b
  (test =)
  (branch (label gcd-done))
  (t<-r)
  (a<-b)
  (b<-t)
  (goto (label test-b))
  gcd-done)


; controllerだけに記述した形式
(controller
  test-b
  ; テストの=を直書きしている
  (test (op =) (reg b) (const 0))
  (branch (label gcd-done))
  ; ボタンの操作を直書きしている
  (assign t (op rem) (reg a) (reg b))
  (assign a (reg b))
  (assign b (reg t))
  (goto (label test-b))
  gcd-done)

