; q3.38

Peter: (set! balance (+ balance 10))
Paul (set! balance (- balance 20))
Mary (set! balance (- balance (/ balance 2)))

; a. balanceのとりうるすべての場合

; * Peter -> Paul -> Mary
; 100 + 10 = 110
; 110 - 20 = 90
; 90 - (90 / 2) = 45
; 
; * Peter -> Mary -> Paul
; 100 + 10 = 110
; 110 - (110 / 2) = 55
; 55 - 20 = 35
; 
; * Paul -> Peter -> Mary
; 100 - 20 = 80
; 80 + 10 = 90
; 90 - (90 / 2) = 45
; 
; * Paul -> Mary -> Peter
; 100 - 20 = 80
; 80 - (80 / 2) = 40
; 40 + 10 = 50
; 
; * Mary -> Peter -> Paul
; 100 - (100 / 2) = 50
; 50 + 10 = 60
; 60 - 20 = 40
; 
; * Mary -> Paul -> Peter
; 100 - (100 / 2) = 50
; 50 - 20 = 30
; 30 + 10 = 40
; 
; 40, 45, 50, 55

; b. 
;
; 省略（図書く
; 90$のパターンも有る
