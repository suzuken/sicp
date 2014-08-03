; q4.74
;
; Alyssa P. Hackerはnegate, lisp-valueとfind-assertionsでの stream-flatmapに, より単純な版を使うことを提案した. 彼女は, これらの場合で, フレームのストリームにマップされるこの手続きは, 常に空ストリームか単一ストリームを生じ, ストリームを組み合せるのに差込みは必要ないと考えた.

; a. Alyssaのプログラムの欠けた式を補え.
;
; どうやらapply-rules, simple-queryでは利用しないようだ

(define (simple-stream-flatmap proc s)
  (simple-flatten (stream-map proc s)))

; とりあえず1つずつ頭からstreamをとるようにして、nullじゃないのを出力すればよい、はず
(define (simple-flatten stream)
  (stream-map stream-car
              (stream-filter
                (lambda (s) (not (stream-null? s)))
                stream)))

; b. このように変更すると, 質問システムの振舞いは変るか. 
; negate, lisp-value, find-assertionsではstreamが2つくることはないので、これで問題ない
