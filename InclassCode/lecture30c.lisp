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
;; Prove:
;; phi: (lorp l) => (sortedp (ssort l))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; del: Any x List -> List
;; (del e l) takes an element e and a list l
;; and removes the FIRST occurance of e from l
;; If e is not in l then l is returned.
(defunc del (e l)
  :input-contract (listp l)
  :output-contract (listp (del e l))
  (if (endp l)
    l
    (if (equal e (first l))
      (rest l)
      (cons (first l) (del e (rest l))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; perm: List x List -> Boolean
;; (perm l1 l2) takes two lists (l1 and l2) and
;; returns true if and only if l1 and l2 have
;; the same elements (and the same number of each)
;; Essentially, is l2 a reordering of l1.
(defunc perm (l1 l2)
  :input-contract (and (listp l1)(listp l2))
  :output-contract (booleanp (perm l1 l2))
  (if (equal l1 l2)
    t
    (if (endp l1)
      nil
      (and (in (first l1) l2)
           (perm (rest l1) (del (first l1) l2))))))

;; Assume by "Def of lor" that each element is a rational
;; and a lor is (cons rational lor) | nil
;; A similar claim can be made about a lon
(defdata lor (listof rational))
(defdata lon (listof nat))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; min-l: lor -> rational
;; (min-l l) takes a non-empty list of rational numbers l
;; and returns the smallest element in the list.
(defunc min-l (l)
  :input-contract (and (lorp l)(consp l))
  :output-contract (rationalp (min-l l))
  (if (endp (rest l))
    (first l)
    (let ((ml (min-l (rest l))))
      (if (> (first l) ml)  
        ml
        (first l)))))

(check= (min-l '(1)) 1)
(check= (min-l '(1 5/2 17/2 13 -47)) -47)
(check= (min-l '(-48 5/2 17/2 13 -47)) -48)
(test? (implies (and (lorp l)(consp l))
                (in (min-l l) l)))

;; Let's give ACL2s the proofs we used last assignment
;; (to ensure ssort is admissible)
(defthm phi_in_min (implies (and (lorp l)(consp l))
                            (in (min-l l) l)))
(defthm phi_del_in (implies (and (listp l)(in e l))
                            (equal (+ (len (del e l)) 1)(len l))))
(defthm phi_del_min (implies (and (lorp l)(consp l))
                             (equal (+ (len (del (min-l l) l)) 1)(len l))))
;; Please ignore this line. It lets ssort work
(sig del (all (listof :b)) => (listof :b))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ssort: lor -> lor
;; (ssort l) or selection sort takes a lorp l as input,
;; and returns a permutation of l with elements in non-decreasing order.
(defunc ssort (l)
  :input-contract (lorp l)
  :output-contract (lorp (ssort l))
  (if (endp l)
      nil
      (let* ((min (min-l l))
            (del-l (del min l)))
        (cons min (ssort del-l)))))

;; Recall that variables min and del-l can be replaced with the function calls
;; in your proof. The let is just there to make the code faster.
(check= (ssort '(3 3/2 1)) '(1 3/2 3))
(check= (ssort '(3 3/2 1 2)) '(1 3/2 2 3))
(check= (ssort '(3 -3/2 2 2)) '(-3/2 2 2 3))
(check= (ssort nil) nil)


; Here are a bunch of theorems that ACL2s can figure out
; Used to help prove ssort terminates  
(defthm phi_min_perm 
  (implies (and (lorp l)(consp l)) 
           (perm l (cons (min-l l)(del (min-l l) l)))))

;(defthm phi_min_rec1 (implies (and (lorp l) (consp l)(consp (rest l))
;                                   (equal (min-l l) (min-l (rest l))))
;                             (<= (min-l l) (first l))))

(defthm phi_min_rec2 (implies (and (lorp l) (consp l)(consp (rest l))
                                   (< (min-l l) (first l)))
                              (equal (min-l l) (min-l (rest l)))))

; Prove
(defthm phi_order_ssort (implies (and (lorp l)(consp l)(consp (rest l)))
                                 (<= (min-l l)(min-l (del (min-l l) l)))))

(defthm phi_perm_ssort1 (implies (and (lorp l)(consp l))
                                 (perm l (cons (min-l l)(del (min-l l) l)))))


; ASSUME THESE THEOREMS (you an use them later)
(defthm phi_perm_sub (implies (and (listp l)(in e l))
                              (perm l (cons e (del e l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; orderedp: lor -> boolean
;; (orderedp l) takes a list of rationals
;; and returns true if and only if the elements 
;; are in non-decreasing order (ie they are sorted)
(defunc orderedp (l)
  :input-contract (lorp l)
  :output-contract (booleanp (orderedp l))
  (if (or (endp l)(endp (rest l)))
    t
    (and (<= (first l) (second l)) (orderedp (rest l)))))

(check= (orderedp '(-1 -1/2 0 4 9/2)) t)
(check= (orderedp '(-1 -1/2 0 4 7/2)) nil)
(check= (orderedp nil) t)


(test? (implies (lorp l)(orderedp (ssort l))))

(defthm phi_min_in (implies (and (lorp l)(consp l)(in e l))
                            (<= (min-l l) e)))
(defthm phi_min-in2 (implies (and (lorp l)(consp l))
                             (in (min-l l) l)))
(defunc del-depth (l)
  :input-contract (lorp l)
  :output-contract (natp (del-depth l))
  (if (endp l)
    0
    (+ 1 (del-depth (del (min-l l) l)))))
:program
(defunc ssort-t (l acc)
  :input-contract (and (lorp l)(lorp acc))
  :output-contract (lorp (ssort-t l acc))
  (if (endp l) (rev acc)
    (let* ((min (min-l l))
           (del-l (del min l)))
      (ssort-t del-l (cons min acc)))))#|ACL2s-ToDo-Line|#



;(defthm phi_del_perm (implies (and (lorp l1)(lorp l2)(perm l1 l2))
;                              (perm (del e l1)(del e l2))))
(defthm phi_perm_ssort (implies (lorp l)
                                (perm (ssort l) l)))
#|
2) 
Prove phi_in_rev: (implies (listp l)
                           (equal (in e l)(in e (rev l))))
..............
SOLUTION (not marked)
IS for listp 
1) (not (consp l)) => phi
2) (consp l) /\ phi|((l (rest l))) => phi

Case 1:
C1. (listp l)
C2. (not (consp l))
---------------
C3. (endp l) {Def endp, C1, C2}

(equal (in e l)(in e (rev l)))
= {Def rev, C3}
(equal (in e l)(in e l))
= {PL....this proof could be done in one step}
t

Case 2:
C1. (listp l)
C2. (consp l)
C3. (implies (listp (rest l))(equal (in e (rest l))(in e (rev (rest l)))))
----------
C4. (not (endp l)) {C2, C1, Def endp}
C5. (listp (rest l)) {C2, C1, Def. list}
C6. (equal (in e (rest l))(in e (rev (rest l)))) {C3, C5, MP}

(in e (rev l))
= {Def rev., C4}
(in e (app (rev (rest l))(list (first l))))
= {phi_in_app, C1, def list, MP}
(or (in e (rev (rest l)))(in e (cons (first l) nil)))
= {C6}
(or (in e (rest l))(in e (cons (first l) nil)))
= {phi_in_app, PL}
(in e (app (cons (first l) nil) (rest l)))
= {Def app, cons-axiom}
(in e (cons (first l)(rest l)))
= {First-rest axioms}
(in e l)
Q.E.D.

4)
Prove that (min-l l) is the smallest element in l. 
Notice that you want an induction scheme that doesn't stop 
at (endp l) since min-l doesn't stop at that.  
You may also need multiple cases for at 
least of your proof obligations (that's OK). The proof is a lot
longer than it would seem.

Phi_min_in: (implies (and (lorp l)(consp l)(in e l))
                     (<= (min-l l) e))
                     
.....................
SOLUTION
(IS for min-l)
1. ~((lorp l)/\(consp l)) => Phi_min_in
2. (lorp l)/\(consp l)/\(in e l)/\(endp (rest l)) => Phi_min_in
3. (lorp l)/\(consp l)/\(in e l)/\(not (endp (rest l)))
   /\(> (first l) (min-l (rest l)))/\ Phi_min_in|((l (rest l)))
   => Phi_min_in
4. (lorp l)/\(consp l)/\(in e l)/\(not (endp (rest l)))
   /\ ~(> (first l) (min-l (rest l))) => Phi_min_in

Obligation 1:
C1. ~((lorp l)/\(consp l))
C2. ((lorp l)/\(consp l))
C3. (in e l)
---------------
C4. nil {PL, C1, C2}

Obligation 2:
C1. (lorp l)
C2. (consp l)
C3. (in e l)
C4. (endp (rest l))
------------
C5. (equal e (first l)) {C3, C4, Def in, PL}

(<= (min-l l) e)
= {Def min-l, C4}
(<= (first l) e)
= {C5}
(<= e e)
= {Arithmetic}
t

Obligation 3a (e = (first l))
C1. (lorp l)
C2. (consp l)
C3. (consp (rest l))
C4. (in e l)
C5. ((first l) > (min-l (rest l)))
C6. (lorp (rest l)(consp (rest l))(in e (rest l))
    => (<= (min-l (rest l)) e))
C7. (e = (first l))
-------------
C6. (lorp (rest l)) {C2, C1, Def lorp}

(<= (min-l l) e)
= {Def. min-l, C3, PL}
(<= (min-l (rest l)) e)
= {C7, C5}
t

Obligation 3b: ~(e = (first l))
C1. (lorp l)
C2. (consp l)
C3. (consp (rest l))
C4. (in e l)
C5. ((first l) > (min-l (rest l)))
C6. (lorp (rest l)(consp (rest l))(in e (rest l))
    => (<= (min-l (rest l)) e))
C7. ~(e = (first l))
-------------
C6. (lorp (rest l)) {C2, C1, Def lorp}
C7. ((first l) = e) \/ (in e (rest l)) {Def in, PL, C4}
C8. (in e (rest l)) {C7, C5, PL}
C9. (<= (min-l (rest l)) e) {C4, C6, C3, C8, MP}

(<= (min-l l) e)
= {Def. min-l, C3, C5}
(<= (min-l (rest l)) e)
= {C9}
t

Obligation 4a (e = (first l)):

C1. (lorp l)
C2. (consp l)
C3. (consp (rest l))
C4. (in e l)
C5. ((first l) <= (min-l (rest l)))
;C6. (lorp (rest l)(consp (rest l))(in e (rest l))
;    => (<= (min-l (rest l)) e))
C6. (equal (first l) e)

(<= (min-l l) e)
= {Def. min-l, PL, C3, C5}
(<= (first l) e)
= {C6}
(<= (first l) (first l))
= {Arithmetic}
t

Obligation 4b ~(e = (first l)):

UPDATE: I accidentally included an inductive assumption for this condition
but in retrospect, I don't think I should.  The recursive call is in the previous
step (even if the negation of the recursive call is part of the proof obligation).
Hence I'm now using a lemma.  HOWEVER, we will overlook any jumps in this part of 
the proof given that my solution file originally had an error.  I should have given
you a lemma if you needed one:

L_less_min: (implies (and (rationalp e) (lorp l)(consp l)(rationalp f)(in f l)(<= e (min-l l)))
                     (<= e f))
Assumed to be valid without a proof


C1. (lorp l)
C2. (consp l)
C3. (consp (rest l))
C4. (in e l)
C5. ~((first l) > (min-l (rest l)))
C6. ~(equal (first l) e)
-------------
C7. ((first l) <= (min-l (rest l))) {C5, C6, Arithmetic}
C8. (lorp (rest l)) {C2, C1, Def lorp}
C9. (in e (rest l)) {Def. in, C4, C7}
C10. ((first l) <= e) {C9, C8, C7, C3, L_less_min, MP}

(<= (min-l l) e)
= {Def. min-l, PL, C3, C5}
(<= (first l) e)
= {C10}
t

Q.E.D.

|#

#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Section 4: SSORT PERMUTATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
I tried for a long time to prove (ssort l) is a permutation of l
but I kept running into dead ends.  Then I took a different approach

Assuming phi_perm_symm is a theorem (we'll revisit this in HW12): 
Phi_perm_symm: (listp l1)/\(listp l2) => (equal (perm l1 l2) (perm l2 l1)) 

we can see the following:
(lorp l1) => (in (min-l l) l) /\
              (perm (rest (ssort l)) (del (min-l l) l)))
Which is how perm would recurse if (ssort l) was the first list.

5) Prove the following:
(listp l1) => (perm l (ssort l))
Hint: Your induction scheme shouldn't go from l to (rest l) but instead
go from l to (del (min-l l) l).
..................
SOLUTION
Using the induction scheme for ssort
1. ~(lorp l) /\ (lorp l) => (perm l (ssort l))
2. (lorp l) /\ (endp l) => (perm l (ssort l))
3. (lorp l) /\ ~(endp l) 
   /\ ((lorp (del (min-l l) l)) => (perm (del (min-l l) l) (ssort (del (min-l l) l)))
   => (perm l (ssort l))
Obligation 1:
C1. ~(lorp l)
C2. (lorp l)
----------
C3. nil {C1, C2, PL}

Obligation 2:
C1. (lorp l) 
C2. (endp l)

(perm l (ssort l))
= {Def ssort l, C2}
(perm l l)
= {Def perm, C2}
t

Obligation 3:
C1. (lorp l)
C2. ~(endp l)
C3. (lorp (del (min-l l) l) 
    => (perm (del (min-l l) l) (ssort (del (min-l l) l)))
-----------
C4. (lorp (del (min-l l) l)) {Contract theorem del, C1}
C5. (perm (del (min-l l) l) (ssort (del (min-l l) l))) {C3, C4, MP}
C6. (in (min-l l) l) {C2, phi-in-min}

(perm l (ssort l))
= {phi-perm-symm}
(perm (ssort l) l)
= {Def ssort l, C2}
(perm (cons (min-l l) (ssort (del (min-l l) l))) l)
= {Def perm, first-rest axioms, consp axioms, C6}
(perm (ssort (del (min-l l)) l) (del (min-l l) l))
= {C5, Phi-Perm-symm}
t
|#


#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SECTION 5: SSORT ORDERED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
6).
OK. Now prove that ssort created a list that is ordered.
You may want to use a lemma. After all, how do you show
that (second (ssort l)) is also in l?

Phi_order_ssort: (lorp l) => (orderedp (ssort l))

..............

Main Proof using I.S. for ssort
1. ~(lorp l) => Phi_order_ssort
2. (lorp l)/\(endp l) => Phi_order_ssort
4. (lorp l)/\~(endp l)/\ (Phi_order_ssort|((l (del (min-l l) l)))
   => Phi_order_ssort

Lemma L2: (lorp l) /\ (consp l) /\ (consp (rest l)) 
          => (in (min-l (del (min-l l) l))  l)
C1. (lorp l)
C2. (consp l)
C3. (consp (rest l))
---------
C4. (consp (rest (ssort l))) {phi_dec_len, C3}

(in (min-l (del (min-l l) l)) l)
= {Def ssort, C2, C3, Def endp}
(in (second (ssort l)) l)
= {phi_perm_ssort2.....(perm (ssort l) l) is true, def perm, C4} 
t

   
Obligation 1:
C1. ~(lorp l)
C2. (lorp l)
----------
C3. nil {C1, C2, PL}

Obligation 2:
C1. (lorp l)
C2. (endp l)

(orderedp (ssort l))
= {Def ssort, C2}
(orderedp l)
= {Def. orderedp, C2}
t


Obligation 3:
C1. (lorp l)
C2. ~(endp l)
C4. (lorp (del (min-l l) l)) => (orderedp (ssort (del (min-l l) l)))
-------------
C5. (lorp (del (min-l l) l)) {contract theorem del, C1}
C6. (orderedp (ssort (del (min-l l) l))) {C4, C5, MP}

C7. (in (min-l l) l) {phi_in_min, C2, C1, MP}
C8. (consp (del (min-l l) l)) {phi_dec_len, C3}
C9. (in (min-l (del (min-l l) l))  l) 
    {phi_in_min, C2, contract theorem del, L2, MP}

Case 1: 
C10. (endp (rest l))

(orderedp (ssort l))
= {Def ssort, def min-l, C10, C2}
(orderedp l)
= {Def orderedp, C10, C2}
t

Case 2: 
C11. (consp (rest l))

(orderedp (ssort l))
= {Def. orderedp, C11}
(<= (first (ssort l))(second (ssort l))) /\ (orderedp (rest (ssort l)))
= {Def ssort, first-rest axioms}
(<= (min-l l)(min-l (del (min-l l) l)) 
    /\ (orderedp (ssort (del (min-l l) l)))
= {C6, PL}
(<= (min-l l)(min-l (del (min-l l) l))
= {phi_min_in2, C9}
t

|#
