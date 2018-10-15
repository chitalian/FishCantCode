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
;; Using LET
(defunc foo ()
  :input-contract t
  :output-contract (listp (foo))
  (let ((q '(a b c))
        (r '(c d))
        (s (app q r)))
    (app s s)))


#| We introduce the ACL2s data definition framework via a sequence of 
examples.

Singleton types allow us to define types that contain only one object. 
For example:

|#
(defdata one 1)

#| All data definitions give rise to a recognizer. The above data definition gives rise to the recognizer onep.

|#
(onep 1) 
(onep '1) 
(onep 2) 
(onep 'hello) 
(onep "1")
(onep 3/3)

#| Enumerated types allow you to define finite types.

|#
(defdata name (enum '(Pete Thomas david)))

(thm (implies (namep x) (or (equal x 'Pete) 
                            (equal x 'Thomas) 
                            (equal x 'David)))) 

(check= (namep 'Bob) nil)

#| 

Range types allow you to define a range of numbers. The two examples below show how to define the rational interval [0..1] and the integers greater than 264.

|#
(defdata probability (range rational (0 <= _ <= 1))) 
(defdata big-nat (range integer ((* 1024 1024) < _)))

;(test? (implies (and (probabilityp x) (probabilityp y)) 
;                (probabilityp (+ x y))))

;(test? (implies (and (probabilityp x) (probabilityp y)) 
;                (probabilityp (- x y))))

(test? (implies (and (probabilityp x) (probabilityp y)) 
                (probabilityp (* x y))))
(test? (implies (and (big-natp x) (big-natp y)) 
                (big-natp (+ x y))))

;(test? (implies (and (big-natp x) (big-natp y)) 
;                (big-natp (- x y))))

(test? (implies (and (big-natp x) (big-natp y)) (big-natp (* x y))))




#| 
Notice that we need to provide a domain, which is either integer or rational, 
and the set of numbers is specified with inequalities using < and <=. 
One of the lower or upper bounds can be omitted, in which case the 
corresponding value is taken to be negative or positive infinity.

Product types allow us to define structured data. The example below defines a 
type consisting of list with exactly two strings.

|#

(defdata fullname (list string string))

(check= (fullnamep '("David" "Sprague") ) t)

#| 
Records are product types, where the fields are named. For example, we 
could have defined fullname as follows.

|#
(defdata fullname-rec (record (first . string) (last . string) (id . integer)))

#| 
In addition to the recognizer fullname-recp, the above type definition 
gives rise to the constructor fullname-rec which takes two strings as 
arguments and constructs a record of type fullname-rec. The type definition 
also generates the accessors fullname-rec-first and fullname-rec-last that 
when applied to an object of type fullname-rec return the first and last 
fields, respectively.

|#
(fullname-rec-first (fullname-rec "Wade" "Wilson" 12345)) 

(fullname-rec-last (fullname-rec "Wade" "Wilson" 12345))
(fullname-rec-id (fullname-rec "Wade" "Wilson" 12345))

#| We can create list types using the listof combinator as follows.

|#
(defdata loi (listof integer))

#| This defines the type consisting of lists of integers.

Union types allow us to take the union of existing types. Here is an example.

|#
(defdata intstr (oneof integer string))
(intstrp "hello")

(intstrp 4)
(intstrp 'hello)
#| Recursive type expressions involve the oneof combinator and product 
combinations, where additionally there is a (recursive) reference to the type 
being defined. For example, here is another way of defining a list of integers.

|#
(defdata loint (oneof nil (cons integer loint)))

#| 
Notice that this is how we’ve been describing recursive types so far!
We now discuss what templates user-defined datatypes that are recursive 
give rise to. Many of the datatypes we define are just lists of existing 
types. For example, we can define a list of rationals as follows.

|#

(defdata lor (listof rational))

#| 
If we define a function that recurs on one of its arguments, which is 
a list of rationals, we just use the list template and can assume that 
if the list is non-empty then the first element is a rational and the 
rest of the list is a list of rationals.

If we have a more complex data definition, say:

|#
(defdata UnaryOp '~) 
(defdata BinOp (enum '(^ v <> => ==))) 
(defdata PropEx (oneof boolean symbol 
                       (list UnaryOp PropEx) 
                       (list Binop PropEx PropEx)))

(defdata PxOp (oneof UnaryOp BinOp))
(defdata lopx (listof PxOp))













;; Note we would normally add theorems to help functions like
;; extract-ops go through.  Given the timeframe in class, I 
;; just threw things into program mode.
:program
(defunc extract-ops (px)
  :input-contract (PropExp px)
  :output-contract (lopxp (extract-ops px))
  (cond ((booleanp px)  nil)
        ((symbolp px) nil)
        ((UnaryOpp (first px)) (cons (first px)(extract-ops (second px))))
        (t (cons (first px)(app (extract-ops (second px))
                 (extract-ops (third px)))))))
  
(extract-ops '(~ (^ (v a b) c)))
  
#| 
Then the template we wind up with is exactly what you would expect 
from the data definition.

(defunc foo (px …) 
:input-contract (and (PropExp px) …) 
:output-contract (… (foo px …)) 
(cond ((booleanp px) …) 
      ((symbolp px) …) 
      ((UnaryOpp (first px)) … (foo (second px)) …) 
      (t …(foo (second px)) … (foo (third px)) …)))

Notice that in the last case, there is no need to check (BinOpp (first px)),

since it has to hold, hence the t. Also, for the recursive cases, 
we get to assume that foo works correctly on the destructed argument 
((second px) and (third px)).

Let’s look at one more example. Consider a filesystem.

A file is a pair consisting of a string (name) and a natural number (inode).

|#
(defdata file (list string nat))

#| 
A directory is a pair consisting of a string (the directory name) and a 
list whose elements are either files or directories (subdirectories). 
This is a mutually-recursive type definition.

|#
(defdata (dir (list string dir-file-list)) 
  (dir-file-list (listof file-dir)) 
  (file-dir (oneof file dir)))

#| For example, here is a directory that contains you cs2800 hwks

|#
(defconst *cs2800-dir* '("cs2800" (("hw2.lisp" 12) ("hw3.lisp" 34))))

#| It might be a subdirectory of a classes directory

|#
(dirp `("classes" (,*cs2800-dir* ("cs2500" (("hw2.lisp" 92))))))

#| 
Notice the backquote, comma duo.

The data definition framework has more advanced features, e.g., it supports 
recursive record types, map types, custom types, and so on. 
We will introduce such features as needed.

|#

#|
Now an example of test? In my sections we went over tests for
even-intp and same-multiplicity. I left only even-intp tests in. 
|#
:logic
(defunc even-nat2p (n)
  :input-contract (natp n)
  :output-contract (booleanp (even-nat2p n))
  (natp (/ n 2)))

(defunc even-natp (n)
  :input-contract (natp n)
  :output-contract (booleanp (even-natp n))
  (if (equal n 0)
    t
    (not (even-natp (- n 1)))))

(test? (implies (natp n)
                (equal (even-natp n)(even-nat2p n))))

(thm (implies (natp n)
              (equal (even-natp n)(even-nat2p n))))
        
(test? (implies (natp n)(even-natp (* 2 n))))

(test? (implies (natp n)(not (even-natp (+ (* 2 n) 1)))))





(defunc even-intp (i)
  :input-contract (integerp i)
  :output-contract (booleanp (even-intp i))
  (cond ((equal i 0) t)
        ((< i 0)     (not (even-intp (+ i 1))))
        (t           (not (even-intp (- i 1))))))

(defunc even-int2p (i)
  :input-contract (integerp i)
  :output-contract (booleanp (even-int2p i))
  (if (< i 0) 
    (even-natp (unary-- i))
    (even-natp i)))









(test? (implies (integerp i) (even-intp (* 2 i))))
(test? (implies (and (integerp i)(>= i 0) )
                     (equal (even-intp i) (even-natp i))))
(test? (implies (natp n) (equal (even-intp n)(even-natp n))))
;; DOES NOT WORK
;;(test? (implies (< i 0) (equal (even-intp i)(even-natp (unary-- i)))))
(test? (implies (and (integerp i)(< i 0)) 
                (equal (even-intp i)(even-natp (unary-- i)))))
;; Nice student solution but even-natp gives a stack overflow due to how
;; the algorithm runs.
;;(test? (implies (integerp i) 
;;  (equal (even-intp i)(even-natp (* i i)))))

;; Also notice the difference between thm and test?
(thm (implies (and (integerp i)(< i 0)) 
              (equal (even-intp i)(even-natp (unary-- i)))))

(defdata lob (listof boolean))
;; Convert a binary number like (nil t t) to
;; a natural number (in this case 6)
(defunc b-to-n (lb)
  :input-contract (lobp lb)
  :output-contract (natp (b-to-n lb))
  (cond ((endp lb)  0)
        ((first lb) (+ 1 (* 2 (b-to-n (rest lb)))))
        (t          (* 2 (b-to-n (rest lb))))))
:program
(defunc n-to-b (n)
  :input-contract (natp n)
  :output-contract (lobp (n-to-b n))
  (cond ((equal n 0)   nil)
        ((even-natp n) (cons nil (n-to-b (/ n 2))))
        (t             (cons t (n-to-b (/ (- n 1) 2))))))

(check= (n-to-b 10) '(nil t nil t))
(check= (b-to-n '(nil t t t)) 14)





(test? (implies (natp n) (equal (b-to-n (n-to-b n)) n)))

(defunc simplest-lob (lb)
  :input-contract (lobp lb)
  :output-contract (booleanp (simplest-lob lb))
  (cond ((endp lb)        t)
        ((endp (rest lb)) (first lb))
        (t                (simplest-lob (rest lb)))))

(test? (implies (and (lobp lb)(simplest-lob lb))
                (equal (n-to-b (b-to-n lb)) lb)))