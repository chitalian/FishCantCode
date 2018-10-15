; **************** BEGIN INITIALIZATION FOR ACL2s BB MODE ****************** ;
; (Nothing to see here!  Your actual file is after this initialization code);

#|
Pete Manolios
Fri Jan 27 09:39:00 EST 2012
----------------------------

Made changes for spring 2012.

Pete Manolios
Thu Jan 20 08:50:00 EST 2011
----------------------------

The idea of the Bare Bones level is to introduce ACL2 as a
programming language with contracts (a "typed" ACL2) to the
students, using a "minimal" subset of primitive functions.
For example, in the case of the Booleans, all that is built-in
are the constants t and nil and the functions if and equal.

Everything else is built on top of that. 

|#

;Common base theory for all modes.
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s base theory book.~%") (value :invisible))
(include-book "acl2s/base-theory" :dir :system)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading the CCG book.~%") (value :invisible))
(include-book "acl2s/ccg/ccg" :uncertified-okp nil :dir :system :ttags ((:ccg)) :load-compiled-file nil);v4.0 change

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s customizations book.~%") (value :invisible))
(include-book "custom" :dir :acl2s-modes :uncertified-okp nil :ttags :all)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem setting up ACL2s Bare Bones mode.") (value :invisible))

;Settings common to all ACL2s modes
(acl2s-common-settings)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading trace-star and evalable-ld-printing books.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "trace-star" :uncertified-okp nil :dir :acl2s-modes :ttags ((:acl2s-interaction)) :load-compiled-file nil)
(include-book "hacking/evalable-ld-printing" :uncertified-okp nil :dir :system :ttags ((:evalable-ld-printing)) :load-compiled-file nil)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s bare-bones theory book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "bare-bones-theory" :dir :acl2s-modes :ttags :all)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem setting up ACL2s Bare Bones mode.") (value :invisible))

;Settings specific to ACL2s Bare Bones mode.
(acl2s-bare-bones-settings)
(acl2::xdoc acl2s::defunc)

(cw "~@0Bare Bones mode loaded.~%~@1"
    #+acl2s-startup "${NoMoReSnIp}$~%" #-acl2s-startup ""
    #+acl2s-startup "${SnIpMeHeRe}$~%" #-acl2s-startup "")

(acl2::in-package "ACL2S BB")


; ***************** END INITIALIZATION FOR ACL2s BB MODE ******************* ;

;$ACL2s-SMode$;Bare Bones
#|
; For Beginner Mode Only
(defunc sum-n (n)
  :input-contract (natp n)
  :output-contract (natp (sum-n n))
  (if (equal n 0)
    0
    (+ n (sum-n (- n 1)))))
            
(defunc foo (x1 x2 x3)
  :input-contract (and (listp x1)(listp x2)(listp x3))
  :output-contract (listp (foo x1 x2 x3))  
  (let* ((v1 (app x1 x2))
        (v2 (app x2 x3))
        (v3 (app v1 v2)))
    (app (app v3 v3) (app v3 v3))))
|#



;; (<blah>p: Any -> Boolean)
(defunc booleanp (x)
 :input-contract t
 :output-contract (booleanp (booleanp x))
 (if (equal x t)
   t
   (equal x nil)))

;; IC => OC
;; For all x:: t => (booleanp (booleanp x))

;; Equal: Any x Any => Boolean

;; and: boolean x boolean -> boolean
(defunc and (x y)
  :input-contract (if (booleanp x) (booleanp y) nil)
  :output-contract (booleanp (and x y))
  (if x y nil))#|ACL2s-ToDo-Line|#




;; Revisit later
(defunc >5Sq (x)
  :input-contract (and (rationalp x)(< x 5))
  :output-contract (rationalp (>5Sq x))
  (* x x))



;; or: boolean x boolean -> boolean
(defunc or (x y)
  :input-contract (and (booleanp x)(booleanp y))
  :output-contract (booleanp (or x y))
  (if x t y))

;; not: Bool -> Bool
(defunc not (x)
  :input-contract (booleanp x)
  :output-contract (booleanp (not x))
  (equal x nil))
  ; (if x nil t)

;; xor : Bool x Bool -> Bool
(defunc xor (x y)
  :input-contract (and (booleanp x)(booleanp y))
  :output-contract (booleanp (xor x y))
  (if (equal x y) nil t))
  ;;(if x (not y) y)
  ;;(not (equal x y)))

;; implies: Boolean x Boolean -> Boolean
(defunc implies (x y)
  :input-contract (and (booleanp x)(booleanp y))
  :output-contract (booleanp (implies x y))
  (if x y t))

  

;; iff: boolean x boolean -> boolean
(defunc iff (x y)
  :input-contract (and (booleanp x)(booleanp y))
  :output-contract (booleanp (iff x y))
  (and (implies x y)(implies y x)))
  ;(not (xor x y))
  ;(if x y (not y))
;; 

;; + * unary-/ unary-- numerator denominator < 
;; rationalp 
;; integerp

; + and *: Rational x Rational -> rational
(defunc / (x y)
  :input-contract (and (rationalp x)
                       (and (rationalp y)(not (equal y 0))))
  :output-contract (rationalp (/ x y))
  (* x (unary-/ y)))

(defunc posp (x)
  :input-contract t
  :output-contract (booleanp (posp x))
  (if (integerp x)
    (< 0 x)
    nil))

;Lists
;cons: All x All (but should be a list!!) -> Cons
;consp: All ->Boolean
;first: Cons -> All
;rest: Cons -> All (normally a list)
;listp: All -> Boolean


; list2p: t -> boolean
; (list2p l) returns whether l is a list
(defunc list2p (l)
  :input-contract t
  :output-contract (booleanp (list2p l))
  (if (consp l)
    (list2p (rest l))
    (equal nil l))
   
   

;atom: All -> Boolean
(defunc atom (x)
  :input-contract t
  :output-contract (booleanp (atom x))
  (not (consp x)))

;endp: List -> Boolean
(defunc endp (x)
  :input-contract (listp x)
  :output-contract (booleanp (endp x))
  (not (consp x)))

  
  
(check= (posp t) nil)
(check= (posp 5/3) nil)
(check= (posp -2) nil)
(check= (posp 6/2) t)
(check= (posp nil) nil)
(check= (posp 0) nil)


;; Termination
(defunc list2p (a)
  :input-contract t
  :output-contract (booleanp (list2p a))
  (if (consp a)
    (list2p a)
    (equal a nil)))



(defunc foo (a)
  :input-contract (natp a)
  :output-contract (integerp (foo a))
  (if (not (equal a 0))
    (foo (- a 2))
    a));(integerp a)))

(check= ()()
(test? (implies (listp x) (equal (endp x) (equal x nil))))


(defunc foo2 (a)
  :input-contract (consp a)
  :output-contract (natp (foo2 a))
  (if (endp a)
    0
    (+ 1 (foo2 (rest a)))))

;; consp: All -> booleanp

;; listp2: All -> Booleanp
(defunc listp2 (x)
  :input-contract t
  :output-contract (booleanp (listp2 x))
  (if (consp x)
    (listp2  (rest x))
    (equal x nil)))

(defunc natp (n)
  :input-contract t
  :output-contract (booleanp (natp n))
  ;(and (integerp n) (< -1 n)))
  (if (integerp n)
    (< -1 n)
    nil))

(acl2s-defaults :set testing-enabled nil)

(defunc sum-n (n)
  :input-contract (integerp n)
  :output-contract (integerp (sum-n n))
  (if (equal n 0)
    0
    (+ n (sum-n (+ n -1)))))

(check= (listp2 (list 1 2 3)) t)
(check= (listp2 nil) t)
(check= (listp2 4) nil)
(check= (listp2 (cons 3 4)) nil)

;; endp: List -> Boolean
(defunc endp (l)
  :input-contract (listp l)
  :output-contract (booleanp (endp l))
  (not (consp l)))
   
;; atom: All -> boolean
(defunc atom (l)
  :input-contract t
  :output-contract (booleanp (atom l))
  (not (consp l)))
  

(defunc app (l1 l2)
  :input-contract (and (listp l1)(listp l2))
  :output-contract (listp (app l1 l2))
  (if (endp l1)
    l2
    (cons (first l1) (app (rest l1) l2))))

(defunc in (e X)
  :input-contract (listp X)
  :output-contract (booleanp (in e X))
  (if (endp X)
    nil
    (if (equal e (first X))
      t
      (in e (rest X)))))
(defdata lor (listof rational))


; for (defunc f (r1 r2 .....rn)
;IC: (and (R1 r1)(R2 r2).....(Rn rn)(O1 r1)(O2 r2).....)
;OC: (R* (f r1 r2 .....rn))

(defunc min-l (lr)
  :input-contract (and (lorp lr)(consp lr))

;; rev: List -> List
;; (rev l) takes a list l and reverses the order
;; of the elements. You can use app.
;; app: List x List -> List

(defunc rev (l)
  :input-contract (listp l)
  :output-contract (listp (rev l))
  (if (endp l)
    l
    (app (rev (rest l)) (list (first l)))));(cons (first l) nil)
  
(check= (rev '(1 2 3 4)) '(4 3 2 1))



;; 
#|
Here is my block comment

(and p q r) = (if p (if q r q) p)
(or p q) = (if p p q)




|#


;; first: Cons -> Any

;; rest: Cons -> List

(defunc foo (a)
  :input-contract (integerp a)
  :output-contract (booleanp (foo a))
  (if (posp a)
    (foo (+ a -1))
    t))

;; Sum up the first n values from 0 to n.
(defunc sum-n (n)
  :input-contract (natp n)
  :output-contract (natp (sum-n n))
  (if (equal 0 n)
    0
    (+ n (sum-n (+ -1 n)))))
    



