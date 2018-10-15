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

(defunc booleanp (x)
  :input-contract t
  :output-contract (booleanp (booleanp x))
  (if (equal nil x)
    t
    (equal x t)))

;equal: all x all -> boolean

;<: rational x rational -> boolean
; if: "boolean" x all x all -> "all"

;for all IC => OC

(defunc natp (n)
  :input-contract t
  :output-contract (booleanp (natp n))
  (if (integerp n)
    (if (< -1 n)
      t
      nil)
    nil))




(defunc and (x y)
  :input-contract (if (booleanp x)(booleanp y) nil)
  :output-contract (booleanp (and x y))
  (if x y nil))
  
(defunc or (x y)
  :input-contract (and (booleanp x)(booleanp y))
  :output-contract (booleanp (or x y))
  (if x t y))

(defunc implies (x y)
  :input-contract (and (booleanp x)(booleanp y))
  :output-contract (booleanp (implies x y))
  (if x y t))

(defunc not (x)
  :input-contract (booleanp x)
  :output-contract (booleanp (not x))
  (if x nil t))

(defunc xor (x y)
  :input-contract (and (booleanp x)(booleanp y))
  :output-contract (booleanp (xor x y))
  (if x (not y) y))


(defunc and (a b)
  :input-contract (if (booleanp a)(booleanp b) nil)
  :output-contract (booleanp (and a b))
  (if a b nil))

(defunc endp (l)
  :input-contract (listp l)
  :output-contract (booleanp (endp l))
  (if (equal l nil)
    t
    nil))

(defunc - (x y)
  :input-contract (and (integerp x)(integerp y))
  :output-contract (integerp (- x y))
  (+ x (unary-- y)))

; End of library functions


; Input: list
;output: natural number
; input contract: the type of data
; output contract: given the input contract is true, then
; the output contract must be true
; IC=>OC
(defunc len (l)
  :input-contract (listp l)
  :output-contract (integerp (len l))
  (if (endp l)
    0
    (+ 1 (len (rest l)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; app: List x List -> List
;; (app x y) takes two lists
;; x and y and concatenates x
;; to y. Thus (app '(1 2 3) '(a b c))
;; returns '(1 2 3 a b c)
(defunc app (x y)
  :input-contract (and (listp x)(listp y))
  :output-contract (listp (app x y))
  (if (endp x)
    y
    (cons (first x)(app (rest x) y))))

;(app aB xY)
;(cons a (app B xY)

(check= (app (list 'a 'b)(list 'c 'd)) (list 'a 'b 'c 'd))
(check= (app (list 1 2) ()) (list 1 2))
(check= (app ()(list 'c 'd)) (list 'c 'd))
(check= (app () ()) ())


(defunc rl1 (l)
  :input-contract (listp l)
  :output-contract (listp (rl1 l))
  (if (endp l)
    l
    (app (rest l)(list (first l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rl: List x Nat -> List
;; (rl l n) rotates list l to the left
;; n times.
(defunc rl (l n)
  :input-contract (and (listp l)(natp n))
  :output-contract (listp (rl l n))
  (if (endp l)
    l
    (if (equal n 0)
      l
      (rl (rl1 l) (- n 1)))))

(check= (rl () 40) ())
(check= (rl () 0) ())
(check= (rl '(1 2 3) 0) '(1 2 3))
(check= (rl '(1 2 3) 4) '(2 3 1))
(check= (rl '(1 2 3) 4) (rl '(1 2 3) 1))
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  (if (equal n 0) 
    l
    (if (endp l)
      l
      (rl (app (rest l) (list (first l))) (- n 1)))))

;(check= (rl '(1 2 3) -1) '(3 1 2))
(check= (rl '(1 2 3) 1) '(2 3 1))
(check= (rl () 2) ())
(check= (rl '(1 2 3) 4) '(2 3 1))
(check= (rl '(1 2 3 4) 4) '(1 2 3 4))
(check= (rl '(1 2 3 4) 0) '(1 2 3 4))

  



  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

(defunc booleanp (x)
  :input-contract t
  :output-contract (booleanp (booleanp x))
  (if (equal nil x)
    t
    (equal x t)))

(defunc natp (n)
  :input-contract t
  :output-contract (booleanp (natp n))
  (if (integerp n)
    (if (< -1 n)
      t
      nil)
    nil))

(defunc and (a b)
  :input-contract (if (booleanp a)(booleanp b) nil)
  :output-contract (booleanp (and a b))
  (if a b nil))

(defunc endp (l)
  :input-contract (listp l)
  :output-contract (booleanp (endp l))
  (if (equal l nil)
    t
    nil))

(defunc - (x y)
  :input-contract (and (integerp x)(integerp y))
  :output-contract (integerp (- x y))
  (+ x (unary-- y)))

; End of library functions



;; len: List -> Nat
;; (len l) takes a list l and returns the number
;; of elements in the list. Empty lists (nil) return
;; 0
(defunc len (l)
  :input-contract (listp l)
  :output-contract (integerp (len l)) ;; HACK AROUND
  (if (endp l)
    0 
    (+ 1 (len (rest l)))))

(check= (len nil) 0)
(check= (len '(a b c)) 3)

; rl: List x Nat -> List
; (rl l n) rotates a list l to the left
; n times and returns the resultant list

; Define app: List x List -> List
; (app x y) takes two lists x and y 
; and returns a new list that is the concatenation
; of x and y
(defunc app (x y)
  :input-contract (and (listp x)(listp y))
  :output-contract (listp (app x y))
  (if (endp x)
    y
    (cons (first x) (app (rest x) y))))
    


(check= (app '(1 2 3) '(a b c)) '(1 2 3 a b c))
(check= (app nil '(a b c)) '(a b c))
(check= (app '(1 2 3) nil) '(1 2 3))
(check= (app nil nil) nil)
; if, and, cons, first, rest, listp, -, +, natp, endp, 
; consp



(check= (app nil '(a b c)) '(a b c))
(check= (app '(1 2 3) nil) '(1 2 3))
(check= (app nil nil) nil)



(defunc rl (l x)
  :input-contract (and (listp l) (natp x))
  :output-contract (listp (rl l x))
  (if (endp l)
    l
    (if (equal x 0)
      l
      (rl (app (rest l)(cons (first l) nil)) (- x 1)))))






(defunc mod (x y)
  :input-contract (and (integerp x)
                       (integerp y)
                       (< 0 y))
  :output-contract (natp (mod x y))
  (if (< x 0)
    (unary-- x)
    x))

(defunc rl2 (l x)
  :input-contract (and (listp l)(integerp x))
  :output-contract (listp (rl2 l x))
  (if (endp l)
    l
    (rl l (mod x (len l)))))

(if (< 0 -1) (/ 14 0) (/ 14 2))
