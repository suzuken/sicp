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

; 印字と読み取りも取り入れたgcd
(controller
  gcd-loop
    (assing a (op read))
    (assign b (op read))
  test-b
    (test (ope =) (reg b) (const 0))
    (branch (label gcd-done))
    (assign t (op rem) (reg a) (reg b))
    (assign a (reg b))
    (assign b (reg t))
    (goto (label test-b))
  gcd-done
    (perform (op print) (reg a))
    (goto (label gcd-loop)))

; s5.1.2

(define (remainder n d)
  (if (< n d)
    n
    (remainder (- n d) d)))

; s5.1.3

; continueを利用することで、gcd演算が終了したことを識別する
gcd
 (test (op =) (reg b) (const 0))
 (branch (label gcd-done))
 (assign t (op rem) (reg a) (reg b))
 (assign a (reg b))
 (assign b (reg t))
 (goto (label gcd))
gcd-done
 (test (op =) (reg continue) (const 0))
 (branch (label after-gcd-1))
 (goto (label after-gcd-2))
 ...
 (assign continue (const 0))
 (goto (label gcd))
after-gcd-1
 ...
 (assign continue (const 1))
 (goto (label gcd))
after-gcd-2

; しかしこれだとわかりづらいので、continueレジスタにlabelを導入する
gcd
 (test (op =) (reg b) (const 0))
 (branch (label gcd-done))
 (assign t (op rem) (reg a) (reg b))
 (assign a (reg b))
 (assign b (reg t))
 (goto (label gcd))
gcd-done
 (goto (reg continue))
 ...
 ...
 (assign continue (label after-gcd-1))
 (goto (label gcd))
after-gcd-1
 ...
 (assign continue (label after-gcd-2))
 (goto (label gcd))
after-gcd-2

; s5.1.4

(define (factorial n)
  (if (= n 1)
    1
    (* (factorial (- n 1)) n)))

(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))

(controller
    (assign continue (label fact-done))
  fact-loop
    (test (op =) (reg n) (const 1))
