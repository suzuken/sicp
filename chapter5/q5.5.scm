; q5.5

; まず階乗について処理を書き下す

(define (factorial n)
  (if (= n 1)
    1
    (* (factorial (- n 1)) n)))

; レジスタ計算機については以下のとおりとする

(controller
   (assign continue (label fact-done))
 fact-loop
   (test (op =) (reg n) (const 1))
   (branch (label base-case))
   (save continue)
   (save n)
   (assign n (op -) (reg n) (const 1))
   (assign continue (label after-fact))
   (goto (label fact-loop))
 after-fact
   (restore n)
   (restore continue)
   (assign val (op *) (reg n) (reg val))
   (goto (reg continue))
 base-case
   (assign val (const 1))
   (goto (reg continue))
 fact-done)

; 3!に関する計算を行う

; n=3
; continueにfact-doneが入る
; n=1ではないので処理続行
; stack: continue=fact-done
; stack: n=3
; n=3-1=2
; continue=after-fact
; loopを繰り返す
; このとき stackは
;
; fact-done
; 3
;
; n=1ではないので処理続行
; stack: continue=after-fact
; stack: n=2
; n=2-1=1
; continue=after-fact
; 再度ループ。このときstackは、
;
; fact-done
; 3
; after-fact
; 2
;
; n=1なのでbase-caseへ
; val=1
; continue=after-factへジャンプ
;
; restore
; n=2
; continue=after-fact
; val=2*1=2
; continue=after-factへジャンプ
; このときstackは

; fact-done
; 3
;
; restore
; n=3
; continue=fact-done
; val=3*2=6
; continue=fact-doneへジャンプ
;
; 以上。


; 続いてfibonacciをシミュレートする

(define (fib n)
  (if (< n 2)
    n
    (+ (fib (- n 1)) (fib (- n 2)))))

; レジスタ計算機は以下のとおり

(controller
   (assign continue (label fib-done))
 fib-loop
   (test (op <) (reg n) (const 2))
   (branch (label immediate-answer))
   (save continue)
   (assign continue (label afterfib-n-1))
   (save n)
   (assign n (op -) (reg n) (const 1))
   (goto (label fib-loop))
 afterfib-n-1
   (restore n)
   (restore continue)
   (assign n (op -) (reg n) (const 2))
   (save continue)
   (assign continue (label afterfib-n-2))
   (save val)
   (goto (label fib-loop))
 afterfib-n-2
   (assign n (reg val))
   (restore val)
   (restore continue)
   (assign val
           (op +) (reg val) (reg n))
   (goto (reg continue))
 immediate-answer
   (assign val (reg n))
   (goto (reg continue))
 fib-done)

; (fib 3) についてシミュレートする

; n=3
; continue=fib-done
;
; n<2ではないのでそのまま
; stack: continue=fib-done
; continue=afterfib-n-1
; stack: n=3
; n=3-1=2
; このときstackは
;
; fib-done
; 3
;
; n<2ではないのでそのまま
; stack: continue=afterfib-n-1
; continue=afterfib-n-1
; stack: n=2
; n=2-1=1
; このときstackは
;
; fib-done
; 3
; after-fib-n-=
; 2
;
; n<2なのでジャンプ
; val=1
; continue=afterfib-n-1へジャンプ
; 
; restore
; n=2
; continue=afterfib-n-1
;
; n=2-2=0
; stack: continue=afterfib-n-1
; continue=afterfib-n-2
; stack: val=1
; fib-loopへジャンプ
; このときstackは
;
; fib-done
; 3
; after-fib-n-1
; 1
;
; n<2なのでジャンプ
; val=0
; continue=afterfib-n-2へジャンプ
;
; n=0
; 
; restore
; val=1
; continue=after-fib-n-1
;
; val=1+0=1
; afterfib-n-1へジャンプ
; このときstackは
;
; fib-done
; 3
;
; restore
; n=3
; continue=fib-done
;
; n=3-2=1
; stack: continue=fib-done
; continue=afterfib-n-1
; stack: val=1
; fib-loopへ
; このときstackは
;
; fib-done
; 1
;
; n<2なのでジャンプ
; 
; val=1
; afterfib-n-1へジャンプ
;
; restore
; n=1
; continue=fib-done
; ....


