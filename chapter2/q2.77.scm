(load "./s2.4.scm")
(load "./s2.5.scm")

; 直交座標系式での 3+4iの表現、
; '(complex rectangular 3 4)
; に対して(magnitude z)を評価しようとするとapply-genericのエラーメッセージが出る。

(install-rectangular-package)
(install-polar-package)
(install-complex-package)

(define z
    (make-complex-from-real-imag 3 4))

; 404 Blog Not Found:scheme - traceとslib
; http://blog.livedoor.jp/dankogai/archives/50458135.html
(use slib)
(require 'trace)
(trace apply-generic)
; (magnitude z)
; gosh: "error": No method for these types -- APPLY-GENERIC (magnitude (complex))
; CALL apply-generic magnitude (complex rectangular 3 . 4)

; 「complex数に対して複素数の選択肢は定義されていず、polarとrectangularだけ定義されているのが問題である。」

(put 'real-part '(complex) real-part)
(put 'imag-part '(complex) imag-part)
(put 'magnitude '(complex) magnitude)
(put 'angle '(complex) angle)

; (print (magnitude z))
; CALL apply-generic magnitude (complex rectangular 3 . 4)
;   CALL apply-generic magnitude (rectangular 3 . 4)
;   RETN apply-generic 5
; RETN apply-generic 5
; 5

