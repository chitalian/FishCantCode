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
;; Write even-natp: Nat -> Boolean
;; Return true if a natural number is even
(defunc even-natp (n)
  :input-contract (natp n)
  :output-contract (booleanp (even-natp n))
  (integerp (/ n 2)))

(defunc even-natp2 (n)
  :input-contract (natp n)
  :output-contract (booleanp (even-natp2 n))
  (if (equal n 0)
    t
    (if (equal n 1)
      nil 
      (even-natp2 (- n 2)))))

(defunc even-natp3 (n)
  :input-contract (natp n)
  :output-contract (booleanp (even-natp3 n))
  (if (equal n 0)
    t
    (not (even-natp3 (- n 1)))))


(defunc even-integerp (i)
  :input-contract (integerp i)
  :output-contract (booleanp (even-integerp i))
  (cond ((equal i 0) t)
        ((> i 0)     (not (even-integerp (- i 1))))
        ((< i 0)     (not (even-integerp (+ i 1))))))
(defunc foo (i)
  :input-contract (integerp i)
  :output-contract (booleanp (foo i))
  (even-integerp i))#|ACL2s-ToDo-Line|#



#| FALL 2018 test? for DFS 



|#

(test? (implies (and (listp l)(natp n)(>= n (len l)))
                (equal l (sublist-start l n))))
(test? (implies (and (listp l)(listp m))
                (equal l (sublist-start (app l m) (len l)))))

(test? (implies (and (listp l)(equal (len l) 1))
                (equal 1 (max-ident-sublist l))))

(test? (implies (listp l)
                (>= (len l) (max-ident-sublist l))))

(test? (implies (and (listp l)(all-identp l))
                (equal (len l) (max-ident-sublist l))))














(test? (implies (and (listp l)(natp size)) 
                (<= (len (sublist-start l size)) (len l))))

(test? (implies (and (listp l)(natp size)) 
                (<= (len (sublist-start l size)) size)))

(test? (implies (and (listp l)(listp m))
                (equal (sublist-start (app l m) (len l)) l)))

(test? (implies (atom p)(equal (has-element nil p) nil)))

(test? (implies (and (listp m) (listp n))
                (has-element (app m (cons p n)) p)))

:program

                
