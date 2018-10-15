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
#|
Accumulator Proof Recipe
Part 1
1) Write a function f (ex rev)
2) Write a tail recursive function f-t such that it 
calculates the same thing as rev BUT uses an accumulator
3) Write a non-recursive function f* that has the 
same IC as f and outputs
the SAME value (with the same OC value type) as f.

Part 2
4) Write a lemma relating f-t, the accumulator and f.  There
should be no constants.
5) Prove f* = f using the lemma from 4.
6) Prove the lemma from 4 using the induction scheme that
f-t gives rise to.
7) Prove any additional lemmas you used.

|#


(defunc rev-t (x acc)
  :input-contract (and (listp x)(listp acc))
  :output-contract (listp (rev-t x acc))
  (if (endp x)
    acc
    (rev-t (rest x)(cons (first x) acc))))

(defunc rev* (x)
  :input-contract (listp x)
  :output-contract (listp (rev* x))
  (rev-t x nil))

(defthm phi-revt-rev (implies (and (listp acc) (listp x))
                              (equal (rev-t x acc)(app (rev x) acc))))
(defthm phi-rev*-rev (implies (listp x)(equal (rev* x)(rev x))))

(defunc make-nats (n)
  :input-contract (natp n)
  :output-contract (listp (make-nats n))
  (if (equal n 0)
    nil
    (cons n (make-nats (- n 1)))))

(let ((l (make-nats 5)))(acl2::time$ (rev l)))

;; 5000
(acl2::er-progn (let ((l (make-nats 5000)))
                  (acl2::time$ (acl2::value-triple (rev l))))
(acl2::value-triple nil))

(acl2::er-progn (let ((l (make-nats 5000)))
                  (acl2::time$ (acl2::value-triple (rev* l))))
(acl2::value-triple nil))
;; 10000
(acl2::er-progn (let ((l (make-nats 10000)))(acl2::time$ (acl2::value-triple (rev l))))
(acl2::value-triple nil))
(acl2::er-progn (let ((l (make-nats 10000)))(acl2::time$ (acl2::value-triple (rev* l))))
(acl2::value-triple nil))
  
(acl2::er-progn (let ((l (make-nats 20000)))(acl2::time$ (acl2::value-triple (rev l))))
(acl2::value-triple nil))
(acl2::er-progn (let ((l (make-nats 20000)))(acl2::time$ (acl2::value-triple (rev* l))))
(acl2::value-triple nil))
(acl2::er-progn (let ((l (make-nats 40000)))(acl2::time$ (acl2::value-triple (rev l))))
(acl2::value-triple nil))
(acl2::er-progn (let ((l (make-nats 40000)))(acl2::time$ (acl2::value-triple (rev* l))))
(acl2::value-triple nil))
(acl2::er-progn (let ((l (make-nats 80000)))(acl2::time$ (acl2::value-triple (rev* l))))
(acl2::value-triple nil))

(defunc make-nats-t (n acc)
  :input-contract (and (natp n)(listp acc))
  :output-contract (listp (make-nats-t n acc))
  (if (equal n 0)
    acc
    (make-nats-t (- n 1) (cons n acc))))


(acl2::er-progn (let ((l (make-nats-t 160000 nil)))(acl2::time$ (acl2::value-triple (rev* l))))
(acl2::value-triple nil))

(acl2::er-progn (let ((l (make-nats-t 1000000 nil)))(acl2::time$ (acl2::value-triple (rev* l))))
(acl2::value-triple nil))
(acl2::er-progn (let ((l (make-nats-t 10000000 nil)))(acl2::time$ (acl2::value-triple (rev* l))))
(acl2::value-triple nil))
;(acl2::er-progn (let ((l (make-nats-t 50000000 nil)))(acl2::time$ (acl2::value-triple (rev* l))))
;(acl2::value-triple nil))

(defunc weave (x y)
  :input-contract (and (listp x)(listp y))
  :output-contract (listp (weave x y))
  (cond ((endp x) y)
        ((endp y) x)
        (t (cons (first x)(cons (first y)
                 (weave (rest x)(rest y)))))))


;; a b c d
;; 1 2 3 4 5 6 7 8
(defunc weave-t (x y acc)
  :input-contract (and (listp x)(listp y)(listp acc))
  :output-contract (listp (weave-t x y acc))
  (cond ((endp x) (app (rev acc) y))
        ((endp y) (app (rev acc) x))
        (t  (weave-t (rest x)(rest y)
                     (cons (first y)(cons (first x) acc))))))

(defunc weave* (x y)
  :input-contract (and (listp x)(listp y))
  :output-contract (listp (weave* x y))
  (weave-t x y nil))

(test? (implies (and (listp x)(listp y))
                (equal (weave* x y)(weave x y))))


 
(defthm lemma_weave (implies (and (listp x)(listp y)(listp acc))
                             (equal (weave-t x y acc) 
                                    (app (rev acc) (weave x y)))))
(defthm phi_weave (implies (and (listp x)(listp y))
                           (equal (weave* x y) (weave x y))))


(defunc ! (n)
  :input-contract (natp n)
  :output-contract (posp (! n))
  (if (equal n 0)
    1
    (* n (! (- n 1)))))














(defunc !-t (n acc)
  :input-contract (and (natp n)(posp acc))
  :output-contract (posp (!-t n acc))
  (if (equal n 0)
    acc
    (!-t (- n 1)(* n acc))))

(defunc !* (n)
  :input-contract (natp n)
  :output-contract (posp (!* n))
  (!-t n 1))

(test? (implies (natp n) (equal (!* n) (! n))))