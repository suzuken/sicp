; q5.8

; 問題のレジスタ計算機を定義した
(define machine58
  (make-machine
    '(a)
    '()
    '(start
       (goto (label here))
      here
       (assign a (const 3))
       (goto (label there))
      here
       (assign a (const 4))
       (goto (label there))
      there)))

(start machine58)
(get-register-contents machine58 'a)

; と思ったが、まだシミュレータが動作しない
; make-execution-procedureを定義していなかった
;
; まず、assemble手続きによってcontroller-textでの命令列を返す
; extract-labelsを確認していく
;
; まずhereの1つ目がextract-labelsされていく際、symbolなので
;
(receive insts
        (cons (make-label-entry next-inst
                                insts)
              labels))
; として処理される
; すなわち、instsのlabelとしてhereがここで登録される。
; extract-labelsの処理はcarのtextから実行されていく
; よって最初のhereをreceiveにいれるlambdaが最初に返される
; その後全て居textについてextract-lablesが終わると、update-instsが行われる
; この際、labelを最初に入れた順番にupdate-insts!が実行されることになる
; これはinstsにlabelがどの順序で格納されているかに依存する
; update-instsはlabelに対応するinstsの実行内容を制御する
; この際、同様のlabelであるhereは後から対応付けられたもので上書きされる
; したがって、register aには4が格納されることになる
;
; これを修正するためにはextract-labelsで重複したラベルが異なる2つの場所を指す場合、
; エラーを返すようにすればよい
;
(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
             (if (assoc next-inst all-labels-at-once)
               (error "ERROR --- labels is duplicated.")
               (receive insts
                        (cons (make-label-entry next-inst
                                                insts)
                              labels)))
             (receive (cons (make-instruction next-inst)
                            insts)
                      labels)))))))
