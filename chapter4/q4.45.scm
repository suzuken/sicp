; q.45

(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))

; articleは冠詞のこと
(define articles '(article the a))

(define (parse-sentence)
  (list 'sentence
         (parse-noun-phrase)
         (parse-word verbs)))

(define (parse-noun-phrase)
  (list 'noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))

(define *unparsed* '())

(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))

(define amb '())
(define (require p)
  (if (not p) (amb)))

;;; Amb-Eval input:
; (parse '(the cat eats))
;;; Starting a new problem
;;; Amb-Eval value:
; (sentence (noun-phrase (article the) (noun cat)) (verb eats))
;
; 正常に出力された

(define prepositions '(prep for to in by with))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
        (parse-word prepositions)
        (parse-noun-phrase)))

(define (parse-sentence)
  (list 'sentence
         (parse-noun-phrase)
         (parse-verb-phrase)))

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
         (maybe-extend (list 'verb-phrase
                             verb-phrase
                             (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))

(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
         (maybe-extend (list 'noun-phrase
                             noun-phrase
                             (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

(parse '(the student with the cat sleeps in the class))

; (sentence
;  (noun-phrase
;   (simple-noun-phrase (article the) (noun student))
;   (prep-phrase (prep with)
;                (simple-noun-phrase
;                 (article the) (noun cat))))
;  (verb-phrase
;   (verb sleeps)
;   (prep-phrase (prep in)
;                (simple-noun-phrase
;                 (article the) (noun class)))))
;
; 出力された。

(parse '(the professor lectures to the student with the cat))

; (sentence
;  (simple-noun-phrase (article the) (noun professor))
;  (verb-phrase
;   (verb-phrase
;    (verb lectures)
;    (prep-phrase (prep to)
;                 (simple-noun-phrase
;                  (article the) (noun student))))
;   (prep-phrase (prep with)
;                (simple-noun-phrase
;                 (article the) (noun cat)))))
; 
; try-again
; 
; (sentence
;  (simple-noun-phrase (article the) (noun professor))
;  (verb-phrase
;   (verb lectures)
;   (prep-phrase (prep to)
;                (noun-phrase
;                 (simple-noun-phrase
;                  (article the) (noun student))
;                 (prep-phrase (prep with)
;                              (simple-noun-phrase
;                               (article the) (noun cat)))))))
;

;上の文法で次の文は異る五通りに構文解析出来る: 「The professor lectures to the student in the class with the cat」 五通りの構文解析を与え, それらの間の違いを説明せよ. 

; 教授は猫と一緒にクラスに居る学生に授業をした

(parse '(the professor lectures to the student in the class with the cat))
try-again

; ;;; Amb-Eval input:
; (parse '(the professor lectures to the student in the class with the cat))
; 
; ;;; Starting a new problem
; ;;; Amb-Eval value:
; (sentence (simple-noun-phrase (article the) (noun professor)) (verb-phrase (verb-phrase (verb-phrase (verb lectures) (prep-phrase (prep to) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep in) (simple-noun-phrase (article the) (noun class)))) (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; (sentence (simple-noun-phrase (article the) (noun professor)) (verb-phrase (verb-phrase (verb lectures) (prep-phrase (prep to) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep in) (noun-phrase (simple-noun-phrase (article the) (noun class)) (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; (sentence (simple-noun-phrase (article the) (noun professor)) (verb-phrase (verb-phrase (verb lectures) (prep-phrase (prep to) (noun-phrase (simple-noun-phrase (article the) (noun student)) (prep-phrase (prep in) (simple-noun-phrase (article the) (noun class)))))) (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; (sentence (simple-noun-phrase (article the) (noun professor)) (verb-phrase (verb lectures) (prep-phrase (prep to) (noun-phrase (noun-phrase (simple-noun-phrase (article the) (noun student)) (prep-phrase (prep in) (simple-noun-phrase (article the) (noun class)))) (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))))
; 
; ;;; Amb-Eval input:
; try-again
; 
; ;;; Amb-Eval value:
; (sentence (simple-noun-phrase (article the) (noun professor)) (verb-phrase (verb lectures) (prep-phrase (prep to) (noun-phrase (simple-noun-phrase (article the) (noun student)) (prep-phrase (prep in) (noun-phrase (simple-noun-phrase (article the) (noun class)) (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))))))
; 
; ;;; Amb-Eval input:
; try-again
; (parse '(the professor lectures to the student in the class with the cat))
