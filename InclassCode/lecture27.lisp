; **************** BEGIN INITIALIZATION FOR ACL2s B MODE ****************** ;
; (Nothing to see here!  Your actual file is after this initialization code);

#|
Pete Manolios
Fri Jan 27 09:39:00 EST 2012
----------------------------

Made changes for spring 2012.


Pete Manolios
Thu Jan 27 18:53:33 EST 2011
----------------------------

The Beginner level is the next level after Bare Bones level.

|#

; Put CCG book first in order, since it seems this results in faster loading of this mode.
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading the CCG book.~%") (value :invisible))
(include-book "acl2s/ccg/ccg" :uncertified-okp nil :dir :system :ttags ((:ccg)) :load-compiled-file nil);v4.0 change

;Common base theory for all modes.
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s base theory book.~%") (value :invisible))
(include-book "acl2s/base-theory" :dir :system :ttags :all)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s customizations book.~%") (value :invisible))
(include-book "custom" :dir :acl2s-modes :uncertified-okp nil :ttags :all)

;Settings common to all ACL2s modes
(acl2s-common-settings)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading trace-star and evalable-ld-printing books.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "trace-star" :uncertified-okp nil :dir :acl2s-modes :ttags ((:acl2s-interaction)) :load-compiled-file nil)
(include-book "hacking/evalable-ld-printing" :uncertified-okp nil :dir :system :ttags ((:evalable-ld-printing)) :load-compiled-file nil)

;theory for beginner mode
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s beginner theory book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "beginner-theory" :dir :acl2s-modes :ttags :all)


#+acl2s-startup (er-progn (assign fmt-error-msg "Problem setting up ACL2s Beginner mode.") (value :invisible))
;Settings specific to ACL2s Beginner mode.
(acl2s-beginner-settings)

; why why why why 
(acl2::xdoc acl2s::defunc) ; almost 3 seconds

(cw "~@0Beginner mode loaded.~%~@1"
    #+acl2s-startup "${NoMoReSnIp}$~%" #-acl2s-startup ""
    #+acl2s-startup "${SnIpMeHeRe}$~%" #-acl2s-startup "")


(acl2::in-package "ACL2S B")

; ***************** END INITIALIZATION FOR ACL2s B MODE ******************* ;
;$ACL2s-SMode$;Beginner
(defunc rev-t (l acc)
  :input-contract (and (listp l)(listp acc))
  :output-contract (listp (rev-t l acc))
  (if (endp l)
    acc
    (rev-t (rest l) (cons (first l) acc))))

(defunc rev* (l)
  :input-contract (listp l)
  :output-contract (listp (rev* l))
  (rev-t l nil))


(defunc make-nats (n)
  :input-contract (natp n)
  :output-contract (listp (make-nats n))
  (if (equal n 0)
    (list 0)
    (cons n (make-nats (- n 1)))))

(let ((l (make-nats 5)))
  (acl2::time$ (rev l)))
(let ((l (make-nats 500)))
  (acl2::time$ (rev l)))


(acl2::er-progn
 (let ((l (make-nats 5000)))
   (acl2::time$ (acl2::value-triple (rev l))))
 (acl2::value-triple nil))

(acl2::er-progn
 (let ((l (make-nats 10000)))
   (acl2::time$ (acl2::value-triple (rev l))))
 (acl2::value-triple nil))

(acl2::er-progn
 (let ((l (make-nats 20000)))
   (acl2::time$ (acl2::value-triple (rev l))))
 (acl2::value-triple nil))
(acl2::er-progn
 (let ((l (make-nats 40000)))
   (acl2::time$ (acl2::value-triple (rev l))))
 (acl2::value-triple nil))


(let ((l (make-nats 5)))
  (acl2::time$ (rev* l)))
(let ((l (make-nats 500)))
  (acl2::time$ (rev* l)))

(acl2::er-progn
 (let ((l (make-nats 5000)))
   (acl2::time$ (acl2::value-triple (rev* l))))
 (acl2::value-triple nil))

(acl2::er-progn
 (let ((l (make-nats 10000)))
   (acl2::time$ (acl2::value-triple (rev* l))))
 (acl2::value-triple nil))

(acl2::er-progn
 (let ((l (make-nats 20000)))
   (acl2::time$ (acl2::value-triple (rev* l))))
 (acl2::value-triple nil))

(acl2::er-progn
 (let ((l (make-nats 40000)))
   (acl2::time$ (acl2::value-triple (rev* l))))
 (acl2::value-triple nil))
;; Now let's try some huge numbers.
; Should be > 100 seconds!
;(acl2::er-progn
; (let ((l (make-nats 100000)))
;   (acl2::time$ (acl2::value-triple (rev* l))))
; (acl2::value-triple nil))
;  (If I ran this) what the heck went wrong?











(defunc make-nats-t (n acc)
  :input-contract (and (natp n) (listp acc))
  :output-contract (listp (make-nats-t n acc))
  (if (equal n 0)
    (cons 0 acc)
    (make-nats-t (- n 1) (cons n acc))))

(defunc make-nats* (n)
  :input-contract (natp n)
  :output-contract (listp (make-nats* n))
  (make-nats-t n nil))
(make-nats* 4)
(make-nats 4)
;(test? (implies (natp n) (equal (make-nats* n)(make-nats n))))

(make-nats* 2)
(make-nats 2)

;; So we make make-nats* which is equivalent to make-nats right?
;; (you can comment this out)
;(thm (implies (natp n) (equal (make-nats* n)(make-nats n))))


(acl2::er-progn
 (let ((l (make-nats* 100000)))
   (acl2::time$ (acl2::value-triple (rev* l))))
 (acl2::value-triple nil))

(acl2::er-progn
 (let ((l (make-nats* 400000)))
   (acl2::time$ (acl2::value-triple (rev* l))))
 (acl2::value-triple nil))


;; Let's prove that rev* = rev
(defthm rev-lemma
  (implies (and (listp l)(listp acc))
           (equal (rev-t l acc)(app (rev l) acc))))

(defthm rev*-rev-thm
  (implies (listp l)
           (equal (rev* l)(rev l))))#|ACL2s-ToDo-Line|#


#|
Accumulator Proof Recipe
Part 1
1) Write a function f (ex rev)
2) Write a tail recursive function f-t such that it 
calculates the same thing as f BUT uses an accumulator
3) Write a non-recursive function f* that has the 
same IC as f and outputs
the SAME value (with the same OC value type) as f.

Part 2
3b) play with some values
4) Write a lemma relating f-t, the accumulator and f.  There
should be no constants.
5) Prove f* = f using the lemma from 4.
6) Prove the lemma from 4 using the induction scheme that
f-t gives rise to.
7) Prove any additional lemmas you used.

|#

(defdata lor (listof rational))
(defunc add-lists (x y)
  :input-contract (and (lorp x)(lorp y))
  :output-contract (lorp (add-lists x y))
  (cond ((endp x) y)
        ((endp y) x)
        (t (cons (+ (first x) (first y))
                 (add-lists (rest x)(rest y))))))

;x: (1 2 3)
;y: '(2 3 4 5 6)
;-----------
;Original: '(3 5 7 5 6)
;


;; Challenge Problems: 
;; 1) Write the tail recursive version of weave
;; 2)prove weave terminates.....and what is the IS for weave?
(defunc weave (x y)
  :input-contract (and (listp x)(listp y))
  :output-contract (listp (weave x y))
  (cond ((endp x) y)
        ((endp y) x)
        (t (cons (first x) 
                 (cons (first y)
                       (weave (rest x)(rest y)))))))
























(defunc add-lists-t (x y acc)
  :input-contract (and (lorp x)(lorp y)(lorp acc))
  :output-contract (lorp (add-lists-t x y acc))
  (cond ((endp x) (app (rev* acc) y))
        ((endp y) (app (rev* acc) x))
        (t   (add-lists-t (rest x) (rest y) 
                          (cons (+ (first x) (first y)) acc)))))

(add-lists-t '(1 2 3 4) '(5 6 7 8 9 10) nil)
(add-lists '(1 2 3 4) '(5 6 7 8 9 10))


(add-lists-t '(1 2 3 4) '(5 6 7 8 9 10) nil)
(add-lists-t '(2 3 4) '(6 7 8 9 10) '(6))
(add-lists-t '(3 4) '(7 8 9 10) '(8 6))
#|
....
(add-lists-t nil '(9 10) '(12 10 8 6)) = '(6 8 10 12 9 10)
|#  
(add-lists '(1 2 3 4) '(5 6 7 8 9 10))
(add-lists '(2 3 4) '(6 7 8 9 10))
(add-lists '(3 4) '(7 8 9 10))


(defunc add-lists* (x y)
  :input-contract (and (lorp x)(lorp y))
  :output-contract (lorp (add-lists* x y))
  (add-lists-t x y nil))
;OR (if add-lists-t is implemented differently)
; ((rev* (add-lists-t x y nil)))

(defthm lemma-addlist (implies (and (lorp x) (lorp y)(lorp acc))
                               (equal (add-lists-t x y acc)
                                      (app (rev acc) (add-lists x y)))))

(defthm phi-addlist (implies (and (lorp x) (lorp y))
                               (equal (add-lists* x y)
                                      (add-lists x y))))