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
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading the CCG book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "ccg/ccg" :uncertified-okp nil :dir :acl2s-modes :ttags ((:ccg)) :load-compiled-file nil);v4.0 change

;Common base theory for all modes.
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s base theory book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "base-theory" :dir :acl2s-modes)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s customizations book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
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
(defdata lor (listof rational))


(defunc revt (x acc)
  :input-contract (and (listp x) (listp acc))
  :output-contract (listp (revt x acc)) 
  (if (endp x)
      acc
    (revt (rest x) (cons (first x) acc))))

(defunc rev* (x)
  :input-contract (listp x) 
  :output-contract (listp (rev* x)) 
  (revt x nil))

(defthm revt-rev
  (implies (and (listp x) (listp acc))
           (equal (revt x acc)
                  (acl2::append (rev x) acc))))

(defthm rev*-rev
  (implies (listp x) 
           (equal (rev* x)
                  (rev x))))

(defunc appt (x y acc)
  :input-contract (and (listp x) (listp y) (listp acc))
  :output-contract (listp (appt x y acc))
  (cond ((consp x) (appt (rest x) y (cons (first x) acc)))
        ((consp y) (appt x (rest y) (cons (first y) acc)))
        (t (rev* acc))))

(defunc app* (x y)
  :input-contract (and (listp x) (listp y))
  :output-contract (listp (app* x y))
  (appt x y nil))

(defthm appt-app
  (implies (and (listp x) (listp y) (listp acc))
           (equal (appt x y acc)
                  (app (rev acc) (app x y)))))

(defthm app*-app
  (implies (and (listp x) (listp y))
           (equal (app* x y)
                  (app x y))))
;; NOTHING TO SEE HERE

#|
Lemmas and Hard Core Tail Recursion: insert and isort
------------------------

0) Next Class?? / Review
1) Code
2) Reasoning 1
3) In-Class Exercise
4) Reasoning 2
5) Trace (2:25 or 2:30 at the latest)

|#


(defunc insert (e l)
  :input-contract (and (rationalp e) (lorp l))
  :output-contract (lorp (insert e l))
  (cond ((endp l) (list e))
        ((<= e (first l)) (cons e l))
        (t (cons (first l) (insert e (rest l))))))

(defunc isort (l) 
  :input-contract (lorp l)
  :output-contract (lorp (isort l))
  (if (endp l)
    l
    (insert (first l) (isort (rest l)))))


;(insert-t 4 '(1 2 3 5 6) nil)
;(insert-t 4 '(2 3 5 6) '(1))
;(insert-t 4 '(3 5 6) '(2 1))
;(insert-t 4 '(5 6) '(3 2 1))

; (rev* '(3 2 1)) + 4 + '(5 6)





(defunc insert-t (e l acc)
  :input-contract (and (rationalp e)(lorp l)(lorp acc))
  :output-contract (lorp (insert-t e l acc))
  (cond ((endp l)         (rev* (cons e acc)))
        ((<= e (first l)) (app* (rev* acc)(cons e l)))
        (t                (insert-t e (rest l) (cons (first l) acc)))))

(defunc insert* (e l)
  :input-contract (and (rationalp e)(lorp l))
  :output-contract (lorp (insert* e l))
  (insert-t e l nil))


(defunc isort-t (l acc)
  :input-contract (and (lorp l)(lorp acc))
  :output-contract (lorp (isort-t l acc))
  (if (endp l)
    acc
    (isort-t (rest l) (insert* (first l) acc))))

(defunc isort* (l)
  :input-contract (lorp l)
  :output-contract (lorp (isort* l))
  (isort-t l nil))





(defthm insert-insertt (implies (and (rationalp e)(lorp l)(lorp acc))
                                (equal (insert-t e l acc)
                                       (app (rev acc)(insert e l)))))
                                
(defthm insert-insert* (implies (and (rationalp e)(lorp l))
                                (equal (insert* e l)(insert e l))))
  
;(defthm isort-isortt (implies (and (lorp l)(lorp acc)) 
;                              (equal (isort-t l acc)
;                                     ???? (isort l) ?????)))

(isort-t '(5 3 1 9) nil)
(isort-t '(3 1 9) '(5))
(isort-t '(1 9) '(3 5))
(isort-t '(9) '(1 3 5))
(isort-t nil '(1 3 5 9))

;(isort '(5 3 1 9)) = '(1 3 5 9)
;(isort '(3 1 9)) = '(1 3 9)
;....

; (defthm isort-isortt (implies (and (lorp l)(lorp acc))
; (equal (isort-t l acc) = ???? (isort l) ?????
;(defthm isort-isort* (implies (lorp l) 
;                              (equal (isort* l)(isort l))))












;; NEW CODE HERE


(defunc orderedp (l)
  :input-contract (lorp l)
  :output-contract (booleanp (orderedp l))
  (or (endp l)
      (endp (rest l))
      (and (<= (first l) (second l))
           (orderedp (rest l)))))

(defthm insert-orderedp
  (implies (and (lorp l)
                (orderedp l)
                (rationalp e))
           (orderedp (insert e l))))

(defthm isort-orderedp
  (implies (lorp l)
           (orderedp (isort l))))

(defthm orderedp-isort
  (implies (and (lorp l) (orderedp l))
           (equal (isort l) 
                  l)))


(defthm insert-ab
  (implies (and (rationalp a)
                (rationalp b)
                (lorp l))
           (equal (insert b (insert a l))
                  (insert a (insert b l)))))

(defthm insert-isort-swap
  (implies (and (rationalp a)
                (lorp l))
           (equal (isort (insert a l))
                  (insert a (isort l)))))

(defthm insert-isort-app
  (implies (and (rationalp a)
                (lorp x)
                (lorp y))
           (equal (isort (acl2::append x (insert a y)))
                  (insert a (isort (acl2::append x y))))))

(defthm isortt-isort
  (implies (and (lorp l) (lorp acc) (orderedp acc))
           (equal (isort-t l acc)
                  (isort (app l acc)))))



(defthm isort*-isort
  (implies (lorp l)
           (equal (isort* l)
                  (isort l))))

;; HOMEWORK: 
;- Write app* and prove it's equal to app.
;- Do all the proofs and lemmata above










