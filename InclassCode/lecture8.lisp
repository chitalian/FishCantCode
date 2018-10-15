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
(defconst *mydef* 42)

#|
We introduce the ACL2s data definition framework via a sequence
of examples.

Singleton types allow us to define types that contain only one
object. For example:
|#

(defdata one 1)
(defdata instr 'David)

; From labs this week
(defdata uoper '-)

#|
All data definitions give rise to a recognizer.  The above data
definition gives rise to the recognizer onep.
|#

(onep 1)
(onep '1)
(onep 2)
(onep 'hello)
(onep "1")

#|
Enumerated types allow you to define finite types.
|#

(defdata name (enum '(bob ken david)))

(thm (implies (namep x)
              (or (equal x 'pete)
                  (equal x 'ken)
                  (equal x 'david))))

(namep 'steve)
(namep 'DAVID)
#|
Range types allow you to define a range of numbers.  The two
examples below show how to define the rational interval [0..1]
and the integers greater than 2^{64}.
|#

(defdata probability (range rational (0 <= _ <= 1))) 
(defdata big-nat (range integer ((* 1024 1024) < _)))

(test? (implies (and (probabilityp x)
                     (probabilityp y))
                (probabilityp (* x y))))

(test? (implies (and (probabilityp x)
                     (probabilityp y))
                (probabilityp (- x y))))

(test? (implies (and (big-natp x)
                     (big-natp y))
                (big-natp (+ x y))))

(test? (implies (and (big-natp x)
                     (big-natp y))
                (big-natp (- x y))))

(test? (implies (and (big-natp x)
                     (big-natp y))
                (big-natp (* x y))))

#|
Notice that we need to provide a domain, which is either integer
or rational, and the set of numbers is specified with
inequalities using < and <=.  One of the lower or upper bounds
can be omitted, in which case the corresponding value is taken to
be negative or positive infinity.

Product types allow us to define structured data. The example
below defines a type consisting of list with exactly two strings.
|#

(defdata fullname (list string string probability))

(fullnamep '("David" "Sprague" 1/2))
(fullnamep '("David" "Sprague"))
#|
Records are  product types, where the fields are named. For
example, we could have defined fullname as follows.
|#


(defdata fullname-rec (record (first . string)
                              (last . string)
                              (numcomics . nat)))

(fullname-recp (fullname-rec "David" "Sprague" 937))

(fullname-rec-first (fullname-rec "David" "Sprague" 937))
(fullname-rec-numcomics (fullname-rec "David" "Sprague" 937))
#|
In addition to the recognizer fullname-recp, the above type
definition gives rise to the constructor fullname-rec which
takes two strings as arguments and constructs a record of
type fullname-rec. The type definition also generates the
accessors fullname-rec-first and fullname-rec-last
that when applied to an object of type fullname-rec return
the first and last fields, respectively.
|#

(fullname-rec-first (fullname-rec "Wade" "Wilson" 45))
(fullname-rec-last (fullname-rec "Wade" "Wilson" 45))
(fullname-rec-numcomics (fullname-rec "Wade" "Wilson" 45))
(third '("Wade" "Wilson" 3/4))
#|
We can create list types using the listof combinator as
follows.
|#

(defdata lop (listof probability))
(defdata loi (listof integer))
(loip '(1 2 3 4))
(loip '(1 2 3 4/3))
(loip '(1 2 3 "sprague"))
(loip '(1 2 (3 4)))
(loip '(1 4/2 3))
(loip '(1 4/3 3))
(loip nil)

#|
This defines the type consisting of lists of integers.

Union types allow us to take the union of existing types.
Here is an example.
|#

(defdata intstr (oneof integer string))

(intstrp 4)
(intstrp "hello")

#|
Recursive type expressions involve the oneof
combinator and product combinations, where additionally there is
a (recursive) reference to the type being defined.
For example, here is another way of defining a list of integers.
|#

(defdata loint (oneof nil (cons integer loint)))


#|
Notice that this is how we've been describing recursive types so
far!

We now discuss what templates user-defined datatypes that are
recursive give rise to. Many of the datatypes we define are just
lists of existing types. For example, we can define a list of
rationals as follows.
|#

(defdata lor (listof rational))

#|
If we define a function that recurs on one of its arguments,
which is a list of rationals, we just use the list template and
can assume that if the list is non-empty then the first element
is a rational and the rest of the list is a list of rationals.

If we have a more complex data definition, say:
|#

(defdata UnaryOp '~)
(defdata BinOp (enum '(& + => ==)))
(defdata pvar (enum '(a b c d)))

(defdata PropEx (oneof boolean 
                       pvar
                       (list UnaryOp PropEx)
                       (list BinOp PropEx PropEx)))

;'(+ (& (~ a) b) (~ t)) 

:program
#|
(defdata Oper (oneof UnaryOp BinOp))
(defdata loo (listof Oper))
;; In Class Exercise
(defunc get-ops (px)
  :input-contract (PropExp px)
  :output-contract (loop (get-ops px))

 
 
 
 |#
  



  
(PropExp '(+ (& (~ a) b) (~ t)))
(count-ops '(+ (& (~ a) b) (~ t)))

:program
#| Pre canned solution
(defunc count-ops (px)
  :input-contract (PropExp px)
  :output-contract (natp (count-ops px))
  (cond ((booleanp px) 0)
        ((pvarp px) 0)
        ((UnaryOpp (first px)) (+ 1 (count-ops (second px))))
        (t  (+ 1 ( + (count-ops (first (rest px)))
                     (count-ops (first (rest (rest px)))))))))
|#

:logic
#|
Then the template we wind up with is exactly what you would
expect from the data definition.

(defunc foo (px ...)
  :input-contract (and (PropExp px) ...)
  :output-contract (... (foo px ...))
  (cond ((booleanp px) ...)
        ((pvarp px) ...)
        ((UnaryOpp (first px)) ... (foo (second px)) ...)
        (t ...(foo (second px)) ... (foo (third px)) ...)))

Notice that in the last case, there is no need to check 
(BinOpp (first px)), 

since it has to hold, hence the t. Also, for the recursive cases,
we get to assume that foo works correctly on the destructed
argument ((second px) and (third px)).

Let's look at one more example. Consider a filesystem.

A file is a pair consisting of a string (name) and a natural
number (inode).
|#

(defdata file (list string nat))

#|
A directory is a pair consisting of a string (the directory name)
and a list whose elements are either files or directories
(subdirectories). This is a mutually-recursive type definition.
|#

(defdata 
  (dir (list string dir-file-list))
  (dir-file-list (listof file-dir))
  (file-dir (oneof file dir)))

#|
For example, here is a directory that contains you cs2800 hwks
|#

(defconst *cs2800-dir*
  '("cs2800" (("hw2.lisp" 12) ("hw3.lisp" 34))))

#|
It might be a subdirectory of a classes directory

|#
(dirp `("classes" (,*cs2800-dir* ("cs2500" (("hw2.lisp" 92))))))

(dirp *cs2800-dir*)

`("classes" (,*cs2800-dir* ("cs2500" (("hw2.lisp" 92)))))

'("classes" (*cs2800-dir* ("cs2500" (("hw2.lisp" 92)))))


(thm (implies (and (booleanp x)(booleanp y))
              (iff (iff (iff (and x y) x) y)(or x y))))

(defunc find-file (f fd)
  :input-contract (and (filep f) (file-dirp fd))
  :output-contract (booleanp (find-file f fd))
  (cond ((filep fd) (equal f fd))
        (.......  Nastiness here....

#|
Notice the backquote, comma duo.

The data definition framework has more advanced features, e.g.,
it supports recursive record types, map types, custom types, and
so on. We will introduce such features as needed.
|#
