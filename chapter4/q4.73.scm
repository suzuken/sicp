; q4.73
;
; flatten-streamがdelayを陽に使うのはなぜか. 次のような定義が悪いのはなぜか:
;
; 
(define (flatten-stream stream)
  (if (stream-null? stream)
    the-empty-stream
    (interleave
      (stream-car stream)
      (flatten-stream (stream-cdr stream)))))


; 実際の定義
(define (flatten-stream stream)
  (if (stream-null? stream)
    the-empty-stream
    (interleave-delayed
      (stream-car stream)
      (delay (flatten-stream (stream-cdr stream))))))

; interleave-delayedでforceして後者のストリームを待つようにしているため
; q4.71と同様、前者のストリームが無限ストリームの場合にflattenが作用しなくなる
