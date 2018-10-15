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
(defunc sum (n)
  :input-contract (natp n)
  :output-contract (natp (sum n))
  (if (equal n 0)
    0
    (+ n (sum (- n 1)))))

(acl2::time$ (sum 1000))
(acl2::time$ (sum 10000))
;(acl2::time$ (sum 100000))
;(acl2::time$ (sum 10000000))

(defunc asum (n acc)
  :input-contract (and (natp n) (natp acc))
  :output-contract (natp (asum n acc))
  (if (equal n 0)
    acc
    (asum (- n 1) (+ n acc))))

(acl2::time$ (asum 1000 0))
(acl2::time$ (asum 1000000 0))
(acl2::time$ (asum 10000000 0))

(acl2::time$ (asum 100000000 0))
(acl2::time$ (asum 1000000000 0))

(defunc fsum (n)
  :input-contract (natp n)
  :output-contract (rationalp n)
  (/ (* n (+ n 1)) 2))

(thm (implies (natp n) (equal (fsum n)
                              (sum n))))

(acl2::time$ (fsum 10000000000))

;; This would take asum 2 hours
(acl2::time$ (fsum 1000000000000))

;; This would take asum 200 YEARS
(acl2::time$ (fsum 10000000000000000000))#|ACL2s-ToDo-Line|#


  