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
;(acl2s-defaults :set testing-enabled nil)
;(set-defunc-termination-strictp nil)
;:program

(defunc sum-n (n)
  :input-contract (natp n)
  :output-contract (natp (sum-n n))
  (if (equal n 0)
    0
    (+ n (sum-n (+ n -1)))))


:logic

#|
;; GENERAL FORM for Contracts
(defunc f (x1 x2 .... xn)
:input-contract (and (R1 x1)(R2 x2)....(Rn xn) Po Pp)
:output-contract (R (f x1 x2 ....xn))


quote: 'x = (quote x)
|#


(defunc >5Sq (x)
  :input-contract (and (rationalp x)(> x 5))
  :output-contract (rationalp (>5Sq x))
  (* x x))


#|
(let ((val1  (+ 3 4))
      (val2  (+ 5 6))
      (val3  '(why does this seem complicated)))
  (+ (+ val1 val1) val2))

|#  
(defdata lor (listof rational))
(defunc min-l (l)
  :input-contract (and (lorp l)(consp l))
  :output-contract (rationalp (min-l l))
  (if (endp (rest l)) 
    (first l)
    (let ((mr (min-l (rest l))))
      (if (< (first l) mr)
          (first l)
          mr))))
(check= (min-l '(-2 4 3 -1 -3 17)) -3)#|ACL2s-ToDo-Line|#

(check= (min-l '(17)) 17)
(test? (implies (and (rationalp r)(lorp l)(in r l))(<= (min-l l) r)))
(test? (implies (and (lorp l)(consp l))(in (min-l l) l)))

(defunc foo ()
  :input-contract t
  :output-contract (listp (foo))
  (let* ((q '(a b c))
        (r '(c d))
        (s (app q q))
        (v (app r r)))
    (app s v)))



(defunc even-natp (n)
  :input-contract t
  :output-contract (booleanp (even-natp n))
  (if (natp n)
    (natp (/ n 2))
    nil))
; even-natp: All -> boolean
(defunc even-nat2p (n)
  :input-contract t
  :output-contract (booleanp (even-nat2p n))
  (cond ((equal n 0) t)
        ((natp n)   (not (even-nat2p (- n 1))))
        (t  nil)))

(test? (implies (natp n)(equal (even-nat2p n)(even-natp n))))
(thm (implies (natp n)(equal (even-nat2p n)(even-natp n))))



;and
;or
;cond
;list

#|
(and x y z)

(if x
  (if y
    (if z
      t
      nil)
    nil)
  nil)


(or x y z)

(if x
  t
  (if y
    t
    (if z
      t
      nil)))

(cond (c1 e1)
      (c2 e2)
      (c3 e3)
      (t e4))

(if c1
  e1
  (if c2
    e2
    (if c3
      e3
      (if t
        e4
        nil))))
     
|#



;; even-natp: Nat -> Boolean
;; Solution 1: intuitive
;; Solution 2: Data driven.....what is a nat?
(defunc even-natp (n)
  :input-contract t
  :output-contract (booleanp (even-natp n))
  (if (natp n)
    (natp (/ n 2))
    nil))

;(cond ((equal n 0) t)
;      ((natp n)   (not (even-natp (- n 1))))
;      (t  nil))
       
  





;(if (equal n 0)
  ;  t
  ;  (not (even-natp (- n 1)))))
;; Nat: (0 | (+ Nat 1))


;; What about even-intp ??

(defdata lor (listof rational))
(defunc min-l (l)
  :input-contract (and (lorp l)(consp l))
  :output-contract (rationalp (min-l l))
  (if (endp (rest l))
    (first l)
    (let ((min (min-l (rest l))))
      (if (< min (first l)) min (first l)))))

(check= (min-l '(3 4 1 -1 -17)) -17)
(check= (min-l '(3 4 1 -17 -1)) -17)
(check= (min-l '(30)) 30)


;; Is there a better way????


(defunc foo (x y)
  :input-contract (and (natp x) (posp y))
  :output-contract (listp (foo x y))
  (let ((q '(a b c))
        (r '(c d)))
    (app (app q r)(app q r))))













(defunc even-natp (n)
  :input-contract (natp n)
  :output-contract (booleanp (even-natp n))
  ;(natp (/ n 2)))
  (if (equal n 0)
    t
    (not (even-natp (- n 1)))))

(defunc even-nat2p (n)
  :input-contract (natp n)
  :output-contract (booleanp (even-nat2p n))
  (natp (/ n 2)))



  
(and x y z)
(if x (if y (if z t nil) nil) nil)

(or x y z)
(if x t (if y t (if z t nil)))

(thm (implies (natp n) (equal (even-nat2p n)(even-natp n))))

"((+ 2 2) 4)"

[[ 'object]] = object
[[ ''x]] = 'x

(cond (c1 e1)
      (c2 e2)
      (c3 e3)
      ...
      (t en))

(if c1
  e1
  (if c2
    e2
    (if c3
      e3
      ....
      (if cn
        en
        nil))))

(defunc f (x1 ... xn)
  :input-contract  t | (R1 xi) | (and (R1 y1)...(Rm ym))
  :output-contract (R (f x1 ... xn))
  ....)


