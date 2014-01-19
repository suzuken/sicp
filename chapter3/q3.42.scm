; q3.42
; 
; 安全な変更である。
;
; この宣言だとletをした段階で直列化している
; 直列変換器の生成のタイミングが異なっている、ということになる。
;
; Ben版ではdispatch手続きの外で局所変数として直列化された手続き、
; protected-withdraw, protected-depositを利用するので、
; 'withdraw, 'deposit, 'balanceでも全て同じように直列化された手続きを利用している。
; （使いまわす）
;
; 毎回withdrawやdepositのたびに直列化された手続きを生成しても結果的には機能的に同じものを生成しているので、
; Ben版でも元のものでも機能は変わらない。