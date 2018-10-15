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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STACKS!!!!
; NEED:
; 1) IC/OC and function name
; 2) What goes on the stack
; 3) Properties about a stack being true

(defdata element all)
(defdata stack (listof element))

;; Define tser and last

(defunc tser (l)
  :input-contract (and (listp l)(not (endp l)))
  :output-contract (listp (tser l))
  (if (endp (rest l))
    nil
    (cons (first l)(tser (rest l)))))

(defunc last (l)
  :input-contract (and (listp l)(not (endp l)))
  :output-contract t
  (if (endp (rest l))
    (first l)
    (last (rest l))))

(defunc stack-push (e s)
  :input-contract (and (elementp e)(stackp s))
  :output-contract (stackp (stack-push e s))
  (cons e s))
  ;(app s (list e)))

(defunc stack-emptyp (s)
  :input-contract (stackp s)
  :output-contract (booleanp (stack-emptyp s))
  (endp s))

(defunc stack-pop (s)
  :input-contract (and (stackp s)(not (stack-emptyp s)))
  :output-contract (stackp (stack-pop s))
  (rest s)) ;; Notice we are using the sub-optimal way to represent stacks
  ;(tser s))

#|
 To break a single property
(defunc stack-pop (s)
  :input-contract (and (stackp s)(not (stack-emptyp s)))
  :output-contract (stackp (stack-pop s))
  s)
|#

(defunc stack-peek (s)
  :input-contract (and (stackp s)(not (stack-emptyp s)))
  :output-contract (elementp (stack-peek s))
  (first s))
  ;(last s))
#|
; Breaking pop-push property
(defunc stack-push (e s)
  :input-contract (and (elementp e)(stackp s))
  :output-contract (stackp (stack-push e s))
  (if (endp s) ;; STUDENT SOLUTION!
    (cons e nil)
    (cons e (rest s))))
|#

(defunc stack-new ()
  :input-contract t
  :output-contract (stackp (stack-new))
  nil)

(stack-peek (stack-push 4 (stack-push 3 (stack-new))))
(stack-pop (stack-push 4 (stack-push 3 (stack-new))))
(stack-push 4 (stack-push 3 (stack-new)))






 ;; TEMPORARILY REMOVED WHEN SUB-OPTIMAL STACK IMPLEMENTATION USED
(defthm peek-push
  (implies (and (elementp e)(stackp s))
           (equal (stack-peek (stack-push e s)) e)))

(defthm empty-stack-new-stack
  (implies (and (stackp s)(stack-emptyp s))
           (equal (stack-new) s)))

(defthm push-pop-peek
  (implies (and (stackp s)
                (not (stack-emptyp s)))
           (equal (stack-push (stack-peek s) (stack-pop s)) s)))


(defthm stack-notempty-stack-push
  (implies (and (stackp s)
                (elementp e))
           (not (stack-emptyp (stack-push e s)))))                

(defthm pop-push
  (implies (and (elementp e)(stackp s))
           (equal (stack-pop (stack-push e s)) s)))#|ACL2s-ToDo-Line|#


;; Independent


#|
OBSERVATIONAL EQUIVALENCE
If an error, then observe error and see nothing else.
Stack-emptyp: t or nil
stack-push: element
Stack-pop: observe nothing if successful.  Else error
stack-peek: head of the stack OR error
|#
(defdata operation (oneof 'empty? (list 'push element) 'pop 'head))
(defdata observation (oneof (list boolean) (list element) nil 'error))

(defunc external-observation (s o)
  :input-contract (and (stackp s) (operationp o))
  :output-contract (observationp (external-observation s o))
  (cond ((equal o 'empty?) (list (stack-emptyp s)))
        ((consp o) (list (second o)))
        ((equal o 'pop)(if (stack-emptyp s) 'error nil))
        (t (if (stack-emptyp s) 'error (list (stack-peek s))))))

(check= (external-observation '(1 2) 'pop) '())
(check= (external-observation '() 'pop) 'error)
;(check= (external-observation '(1 2) 'head) '(1))
(check= (external-observation '(1 2) (list 'push 3)) '(3))
(test? (implies (stackp s) (equal (external-observation s (list 'push e))
                                  (list e))))
(test? (implies (and (stackp s)(not (stack-emptyp s))) 
                (equal (external-observation s 'pop) nil)))

(defdata lop (listof operation))
(defdata lob (listof observation))
; TEMPORARY
;:program

(defunc update-stack (s op)
  :input-contract (and (stackp s)(operationp op))
  :output-contract (stackp (update-stack s op))
  (cond ((or (equal op 'empty?) (equal op 'head)) s)
        ((equal op 'pop) (if (stack-emptyp s) s (stack-pop s)))
        (t (stack-push (second op) s))))

(defunc external-observations (s l)
  :input-contract (and (stackp s) (lopp l))
  :output-contract (lobp (external-observations s l))
  (if (endp l)
    nil
    (let* ((op (first l))
           (ob (external-observation s op)))
      (if (equal ob 'error)
        '(error)
        (cons ob (external-observations
                  (update-stack s op)(rest l)))))))

(check= (external-observations (stack-new) '(head)) '(error))
(check= (external-observations (stack-new) '((push 4))) '((4)))
(check= (external-observations (stack-new) '((push 4) pop)) '((4) nil))
(check= (external-observations (stack-new) '((push 4) pop pop)) '((4) nil error))
(check= (external-observations (stack-new) '((push 4) pop pop (push 4))) '((4) nil error))
(check= (external-observations (stack-new) '((push 4) (push 3) pop head)) '((4) (3) nil (4)))


;;=============================
;; SETS
;; - spec
;; - Properties
;; - What do we worry about?
;;=============================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prove unions and intersections are symmetric:
; x union y == y union x
; x intersect y == y intersect x

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Unions and intersections distribute over each other:
; x union (y intersect z) == (x union y) intersect (x union z)
; x intersect (y union z) == (x intersect y) union (x intersect z)

(defunc setp (x)
  :input-contract t
  :output-contract (booleanp (setp x))
  (listp x))

(defunc <<= (x y)
  :input-contract (and (setp x) (setp y))
  :output-contract (booleanp (<<= x y))
  (if (endp x)
    t
    (and (in (first x) y)
         (<<= (rest x) y))))

(defunc == (x y)
  :input-contract (and (setp x) (setp y))
  :output-contract (booleanp (== x y))
  (and (<<= x y)
       (<<= y x)))

(test? (implies (setp a) (<<= a a)))



(defthm <<=-lemma
  (implies (and (setp x)(setp y) (<<= x y))
           (<<= x (cons a y))))

(defthm <<=-reflexive
  (implies (setp x) (<<= x x)))

(defthm ==-reflexive
  (implies (setp x) (== x x)))

(defthm ==-symetric
  (implies (and (setp x) (setp y))
           (implies (== x y)
                    (== y x))))

(defthm <<=-in-lemma
  (IMPLIES (AND (setp Y)
              (setp Z)
              (setp X1)
              (NOT (IN X1 Z))
              (IN X1 Y))
         (NOT (<<= Y Z))))
(defthm <<-transitive
  (implies (and (setp x)
                (setp y)
                (setp z)
                (<<= x y)
                (<<= y z))
           (<<= x z)))

#|
(defthm ==-transitive
  (implies (and (setp x)
                (setp y)
                (setp z)
                (== x y)
                (== y z))
           (== x z)))
|#












; Union and Intersect: how do we want to handle this?
(defunc set-union (x y)
  :input-contract (and (setp x) (setp y))
  :output-contract (setp (set-union x y))
  (app x y))

;; Other approach
;; Write(no-dupesp x)
;; Write (rem-dupes x)
;; (defunc set2p (x)
;  :input-contract t
;  :output-contract (booleanp (set2p x))
;  (and (setp x)(no-dupesp x))

;; What is the slow version of union??
;(defunc set-union2 (x y)
;  :input-contract (and (setp x) (setp y))
;  :output-contract (setp (set-union2 x y))
;  (cond ((endp x) y)
;        ((in (first x) y) (set-union2 (rest x) y))
;        (t              (cons (first x)(set-union2 (rest x) y)))))

(defunc set-intersection (x y)
  :input-contract (and (setp x) (setp y))
  :output-contract (setp (set-intersection x y))
  (cond ((endp x) ())
        ((in (first x) y)
         (cons (first x) (set-intersection (rest x) y)))
        (t  (set-intersection (rest x) y))))


(defthm set-union-inx (implies (and (setp x) (setp y) (in a x) 
                                   (not (in a y)))
                              (in a (set-union x y))))  

(defthm set-union-iny (implies (and (setp x) (setp y) 
                                    (not (in a x))(in a y))
                               (in a (set-union x y))))

(defthm set-union-or (implies (and (setp x) (setp y) 
                                   (in a (set-union x y)))
                              (or (in a x) (in a y))))

(defthm app-in-or (implies (and (listp x)(listp y))
                           (equal (in a (app x y))
                                  (or (in a x)(in a y)))))

#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prove unions and intersects are idempotent:
; x union x == x
; x intersect x == x
(defthm set-union-idempotent 
  (implies (setp x)
           (== (set-union x x) x)))

(defthm set-int-idempotent
  (implies (setp x)
           (== (set-intersection x x) x)))
|#



;;Comment block started here
(defthm set-union-idempotent-lemma-1
  (implies (and (setp x)(setp y))
           (<<= x (acl2::append x y))))

;(defthm set-union-idempotent-lemma-2
;  (implies (and (setp x)(setp y) (in a x))
;           (in a (ACL2::append x y))))

(acl2::in-theory (acl2::enable 
                  (:induction acl2::true-listp)))


(defthm set-union-idempotent-lemma-3
  (implies (and (setp x)(setp y) (in a y))
           (in a (ACL2::append x y))))

(defthm set-union-idempotent-lemma-4
  (implies (and (setp x)
                (setp y))
           (<<= y (acl2::append x y))))

(defthm set-union-idempotent-lemma-5
  (implies (and (setp x)
                (setp y)
                (setp z))
           (equal (<<= (acl2::append x y) z)
                  (and (<<= x z)
                       (<<= y z)))))
;; Comment block ended here


(defthm set-union-idempotent 
  (implies (setp x)
           (== (set-union x x) x)))

#|
(defthm set-int-inx (implies (and (setp x) (setp y) (not (in a x))) 
                             (not (in a (set-intersection x y)))))
(defthm set-int-inx (implies (and (setp x) (setp y) (not (in a y))) 
                             (not (in a (set-intersection x y))))) 

(defthm set-int-iny (implies (and (setp x) (setp y) 
                                    (not (in a x))(in a y))
                               (in a (set-intersection x y))))

(defthm set-int-and (implies (and (setp x) (setp y) 
                                   (in a (set-intersection x y)))
                              (or (in a x) (in a y))))
;; comment block started here
(defthm set-int-idempotent-lemma-2
  (implies (and (setp x)(setp y))
           (<<= (set-intersection x y) y)))
(defthm set-int-idempotent-lemma-1
  (implies (and (setp x)(setp y))
           (<<= (set-intersection x y) x)))

(defthm set-int-idempotent-lemma-3
  (implies (and (setp x)(setp y)(not (in a y)))
           (not (in a (set-intersection x y)))))

(defthm set-int-idempotent-lemma-4
  (implies (and (setp x)(setp y)(not (in a x)))
           (not (in a (set-intersection x y)))))

(defthm set-int-idempotent-lemma-5
  (implies (and (setp x)(setp y)(in a x)(in a y))
           (in a (set-intersection x y))))

(defthm set-int-idempotent-lemma6
  (implies (and (setp x)
                (setp y)
                (setp z))
           (equal (<<= z (set-intersection x y))
                  (and (<<= z x)
                       (<<= z y)))))
 ;; comment ended here          

(defthm set-int-idempotent
  (implies (setp x)
           (== (set-intersection x x) x)))

(defthm set-intersection-symmetric
  (implies (and (setp x)
                (setp y))
           (== (set-intersection x y)
               (set-intersection y x))))

(defthm set-union-symmetric
  (implies (and (setp x)
                (setp y))
           (== (set-union x y)
               (set-union y x))))
|#


; Queue
(defdata queue (listof element))

(defunc enqueue (e q)
  :input-contract (and (elementp e)(queuep q))
  :output-contract (queuep (enqueue e q))
  (app q (list e)))
  ;(cons e q))

(defunc q-emptyp (q)
  :input-contract (queuep q)
  :output-contract (booleanp (q-emptyp q))
  (endp q))

(defunc dequeue (q)
  :input-contract (and (queuep q)(not (q-emptyp q)))
  :output-contract (queuep (dequeue q))
  (rest q))
  ;(tser q))

(defunc q-head (q)
  :input-contract (and (queuep q)(not (q-emptyp q)))
  :output-contract (elementp (q-head q))
  ;(last q))
  (first q))

(defunc q-new ()
  :input-contract t
  :output-contract (queuep (q-new))
  nil)

(defthm q-add-nonempty (implies (and (elementp e)(queuep q))
                                (not (q-emptyp (enqueue e q)))))


(defthm q-head-enqueue-nempty 
  (implies (and (elementp e)(queuep q)(not (q-emptyp q)))
           (equal (q-head q)(q-head (enqueue e q)))))

(defthm q-new-empty (q-emptyp (q-new)))

(defthm q-head-enqueue-empty 
  (implies (and (elementp e)(queuep q)(q-emptyp q))
           (equal (q-head (enqueue e q)) e)))

(defthm q-two-dequeue-enqueue
  (implies (and (elementp e)(elementp f)(queuep q2)(q-emptyp q2)
                (equal q (enqueue f (enqueue e q2))))
           (equal (list (q-head q)(q-head (dequeue q))) 
                  (list e f))))

(defdata loe (listof element))
;; ALTERNATE
(defunc q-batchEnqueue (l q)
  :input-contract (and (loep l)(queuep q))
  :output-contract (queuep (q-batchEnqueue l q))
  (if (endp l)
    q
    (q-batchEnqueue (rest l)(enqueue (first l) q))))

(defunc q-batchDequeue (q)
  :input-contract (queuep q)
  :output-contract (loep (q-batchDequeue q))
  (if (q-emptyp q)
    nil
    (cons (q-head q)(q-batchDequeue (dequeue q)))))

(test? (implies (and (loep l)(queuep q)(q-emptyp q))
                          (equal (q-batchDequeue (q-batchEnqueue l q)) l)))

(defdata qoperation (oneof 'empty? (list 'enq element) 'deq 'head))
(defdata qobservation (oneof (list boolean) (list element) nil 'error))

(defunc qexternal-observation (q o)
  :input-contract (and (queuep q) (qoperationp o))
  :output-contract (observationp (qexternal-observation q o))
  (cond ((equal o 'empty?) (list (q-emptyp q)))
        ((consp o) (list (second o)))
        ((equal o 'deq)(if (q-emptyp q) 'error nil))
        (t (if (q-emptyp q) 'error (list (q-head q))))))

(check= (qexternal-observation '(1 2) 'deq) '())
(check= (qexternal-observation '() 'deq) 'error)
(check= (qexternal-observation '(1 2) (list 'enq 3)) '(3))
(test? (implies (queuep q) (equal (qexternal-observation q (list 'enq e))
                                  (list e))))
(test? (implies (and (queuep q)(not (q-emptyp q))) 
                (equal (qexternal-observation q 'deq) nil)))

(defdata loqp (listof qoperation))
(defdata loqb (listof qobservation))
; TEMPORARY
;:program

(defunc update-queue (q op)
  :input-contract (and (queuep q)(qoperationp op))
  :output-contract (queuep (update-queue q op))
  (cond ((or (equal op 'empty?) (equal op 'head)) q)
        ((equal op 'deq) (if (q-emptyp q) q (dequeue q)))
        (t (enqueue (second op) q))))
:program
(defunc qexternal-observations (q l)
  :input-contract (and (queuep q) (loqpp l))
  :output-contract (loqbp (qexternal-observations q l))
  (if (endp l)
    nil
    (let* ((op (first l))
           (ob (qexternal-observation q op)))
      (if (equal ob 'error)
        '(error)
        (cons ob (qexternal-observations
                  (update-queue q op)(rest l)))))))

(check= (qexternal-observations (q-new) '(head)) '(error))
(check= (qexternal-observations (q-new) '((enq 4))) '((4)))
(check= (qexternal-observations (q-new) '((enq 4) deq)) '((4) nil))
(check= (qexternal-observations (q-new) '((enq 4) deq deq)) '((4) nil error))
(check= (qexternal-observations (q-new) '((enq 4) deq deq (enq 4))) '((4) nil error))
(check= (qexternal-observations (q-new) '((enq 4) (enq 3) deq head)) '((4) (3) nil (3)))
(check= (qexternal-observations (q-new) 
                                '((enq 4) (enq 3) (enq 2) head deq head deq head)) 
        '((4) (3) (2) (4) nil (3) nil (2)))
