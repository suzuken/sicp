; 5.11

;a 

; 図5.12は以下のとおり

(controller
   (assign continue (label fib-done))
 fib-loop
   (test (op <) (reg n) (const 2))
   (branch (label immediate-answer))
   ;; Fib(n-1)を計算するよう設定
   (save continue)
   (assign continue (label afterfib-n-1))
   (save n)                           ; nの昔の値を退避
   (assign n (op -) (reg n) (const 1)); nを n-1 に変える
   (goto (label fib-loop))            ; 再帰呼出しを実行
 afterfib-n-1                         ; 戻った時 Fib(n-1)はvalにある
   (restore n)
   (restore continue)
   ;; Fib(n-2)を計算するよう設定
   (assign n (op -) (reg n) (const 2))
   (save continue)
   (assign continue (label afterfib-n-2))
   (save val)                         ; Fib(n-1)を退避
   (goto (label fib-loop))
 afterfib-n-2                         ; 戻った時Fib(n-2)の値はvalにある
   (assign n (reg val))               ; nにはFib(n-2)がある
   (restore val)                      ; valにはFib(n-1)がある
   (restore continue)
   (assign val                        ; Fib(n-1)+Fib(n-2)
           (op +) (reg val) (reg n))
   (goto (reg continue))              ; 呼出し側に戻る. 答えはvalにある
 immediate-answer
   (assign val (reg n))               ; 基底の場合: Fib(n)=n
   (goto (reg continue))
 fib-done)


; この振る舞いの場合ではaftebi-n-1のrestore continueとsave contineを省略可能

; b
;
; (restore y) がy以外の値で退避されたものをrestore仕様としてしまった場合にエラーにするには、saveするときにどのレジスタ名で値を保存したかをスタックに保持する必要がある
;
;まず、stackのpushでregをいれられるようにする
;と同時に、popでは(cons reg x)がかえるようにする
(define (make-stack)
  (let ((s '()))
    (define (push reg x)
      (set! s (cons (cons reg x) s)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            top)))
    (define (initialize)
      (set! s '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            (else (error "Unknown request -- STACK"
                         message))))
    dispatch))

(define (push stack reg value)
  ((stack 'push) reg value))

;次にsaveでregも一緒にpushするようにする
;regだけ渡せば良いようにしても良いが、とりあえず両方渡すことにする
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack reg (get-contents reg))
      (advance-pc pc))))

; 次にrestoreでもしregが同一のものではなかったらerrorを返すようにする
; と思ったが、popしてしまったらstackの内容変わってしまうし、どうしようか
(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (let ((head (pop stack)))
      (if (eq? (car head) reg)
        (lambda ()
          (set-contents! reg (pop stack))
          (advance-pc pc))
        (error "stored register is not match yours")))))
