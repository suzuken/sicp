; 2.4 抽象データの多重表現

; 加法的に

; 2.4.1 複素数の表現
;
; 直交座標表現（加算には向いている）
; 複素数 z = x + iy
;
; 極座標表現（乗算に向いている）
; 複素数 z = r * e ^ (iA)
;
; ただし座標(x, y), 偏角A, 半径r
;
; すなわち、
;
; real-part(z1 + z2) = real-part(z1) + real-part(z2)
;
; imaginary-part(z1 + z2) = imaginary-part(z1) + imaginary-part(z2)
;
; magnitude(z1 * z2) = magnitude(z1) * magnitude(z2)
;
; angle(z1 * z2) = angle(z1) + angle(z2)
;
; 以上の事実をベースとして複素数空間に置ける計算を定義していく


; まずは上記の定理に基づいて四則演算を定義する。
(define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))

(define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))

(define (mul-complex z1 z2)
    (make-from-real-imag (* (magnitude z1) (magnitude z2))
                         (+ (angle z1) (angle z2))))

(define (div-complex z1 z2)
    (make-from-real-imag (/ (magnitude z1) (magnitude z2))
                         (- (angle z1) (angle z2))))

; 直交座標系式でも極座標系式でも実部虚部を定義できる。
;
; 直交座標系式から半径rと偏角Aを導くには以下のようにすればよい。
;
; x = r cos A
; -> r = (x^2 + y^2) ^ (1/2)
;
; y = r sin A
; -> A = arctan(y, x)

(define (real-part z)
    (car z))

(define (imag-part z)
    (cdr z))

(define (magnitude z)
    (sqrt (+ (square (real-part z)) (square (imag-part z)))))

(define (angl z)
    (atan (imag-part z) (real-part z)))

; 直交座標からそのまま表現するのでそのままconsで返す
(define (make-from-real-imag x y)
    (cons x y))

; r cos a, r sin a
(define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))

; 極座標系式から直交座標系を導き出すには以下のとおり

(define (real-part z)
    (* (magnitude z) (cos (angle z))))

(define (imag-part z)
    (* (magnitude z) (sin (angle z))))

(define (magnitude z)
    (car z))

(define (angle z)
    (cdr z))

(define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))

(define (make-from-mag-ang r a)
    (cons r a))

; 2.4.2 タグ付きデータ
;
; さて、上で直交座標系→極座標系、またはその逆について定義した。
; これらを上手く扱うために、できれば両方利用できたほうがもっと良い。
; 使う側が極座標系式のデータと直交座標系式のデータを区別しなくて良くなる。
; -> タグを使って内部的に利用する手続きを切り替えれば良い

(define (attach-tag type-tag contents)
    (cons type-tag contents))

(define (type-tag datum)
    (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
    (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))

; 直交座標と極座標のどちらかかを認識する手続きを定義する
(define (rectangular? z)
    (eq? (type-tag z) 'rectangular))

(define (polar? z)
    (eq? (type-tag z) 'polar))

; この型タグを利用して前述した表現を書き直す
;
; 改訂版の直交座標系

(define (real-part-rectangular z)
    (car z))

(define (imag-part-rectangular z)
    (cdr z))

(define (magnitude-rectangular z)
    (sqrt (+ (square (real-part-rectangular z))
             (square (imag-part-rectangular z)))))

(define (angle-rectangular z)
    (atan (imag-part-rectangular z)
          (real-part-rectangular z)))

(define (make-from-real-imag-rectangular x y)
    (attach-tag 'rectangular (cons x y)))

(define (make-from-mag-ang-rectangular r a)
    (attach-tag 'rectangular
                (cons (* r (cos a))( * r (sin a)))))

; そして改訂版の極座標系が以下のとおり

(define (real-part-polar z)
    (* (magnitude-polar z) (cos (angle-polar z))))

(define (imag-part-polar z)
    (* (magnitude-polar z) (sin (angle-polar z))))

(define (magnitude-polar z)
    (car z))

(define (angle-polar z)
    (cdr z))

(define (make-from-real-imag-polar x y)
    (attach-tag 'polar
                (cons (sqrt (+ (square x) (square y)))
                      (atan y x))))

(define (make-from-mag-ang-polar r a)
    (attach-tag 'polar cons(r a)))

; ということで各汎用選択肢は型を調べて直交座標系か極座標系のどちらかの手続きを使えば良い事になる

(define (real-part z)
  (cond ((rectangular? z)
         (real-part-rectangular (contents z)))
        ((polar? z)
         (real-part-polar (contents z)))
        (else (error "Unknown type -- REAL-PART" z))))

(define (imag-part z)
  (cond ((rectangular? z)
         (imag-part-rectangular (contents z)))
        ((polar? z)
         (imag-part-polar (contents z)))
        (else (error "Unknown type -- IMAG-PART" z))))

(define (magnitude z)
  (cond ((rectangular? z)
         (magnitude-rectangular (contents z)))
        ((polar? z)
         (magnitude-polar (contents z)))
        (else (error "Unknown type -- MAGNITUDE" z))))

(define (angle z)
  (cond ((rectangular? z)
         (angle-rectangular (contents z)))
        ((polar? z)
         (angle-polar (contents z)))
        (else (error "Unknown type -- ANGLE" z))))

; 実部と虚部を返す手続きについては、効率のよい方を選べば良いだろう。

(define (make-from-real-imag x y)
    (make-from-real-imag-rectangular x y))

(define (make-from-mag-ang r a)
    (make-from-mag-ang-polar r a))

; 2.4.3 データ主導プログラミングと加法性
;
; putとgetを用いてシステム設計をさらに部品化する。


; 直交座標系のためのパッケージ
(define (install-rectangular-package)
  ; internal procedure
  (define (real-part z)
      (car z))
  (define (imag-part z)
      (cdr z))
  (define (make-from-real-imag x y)
      (cons x y))
  (define (magnitude z)
      (sqrt (+ (square (real-part z))
               (square (imag-part z)))))
  (define (angle z)
      (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
      (cons (* r (cos a)) (* r (sin a))))

  ; public interface
  (define (tag x)
      (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang x y))))
  'done)

; 極座標系のためのパッケージ
(define (install-polar-package)
  ; internal procedure
  (define (magnitude z)
      (car z))
  (define (angle z)
      (cdr z))
  (define (make-from-mag-ang r a)
      (cons r a))
  (define (real-part z)
      (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
      (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y)
      (cons (sqrt (+ (square x) (square y)))
            (atan y x)))

  ; public interface
  (define (tag x)
      (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang x y))))
  'done)


; 複素数の算術演算の選択肢で表にアクセスするため、apply-genericを定義する
; 演算の名前と引数の型から表を探索し、得られた手続きがあればそれを作用させる。
(define (apply-generic op . args)
    (let ((type-tags (map type-tag args)))
      (let ((proc (get op type-tags)))
        (if proc
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC"
            (list op type-tags))))))

; したがって、
(define (real-part z)
    (apply-generic 'real-part z))
(define (imag-part z)
    (apply-generic 'imag-part z))
(define (magnitude z)
    (apply-generic 'magnitude z))
(define (angle z)
    (apply-generic 'angle z))

