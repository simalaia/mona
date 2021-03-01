#! /usr/bin/env -S chibi-scheme -r -A ./ -I $modules/self/schemeR7RS

(import (chibi) (chibi match)
	(lib misc)
	(scheme cxr) (only (scheme base) symbol=?)
	)

;; Following: blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html
;; in a -> m b the variable m refers to a type for example:
;; for m = type Debuggable a = (a,String)
;; or  m = type Multivalued a = [a]
;; or  m = type Randomised a = (StdGen -> (a,StdGen))
;; bind is a function of type (a -> m b) -> (m a -> m b), ie it turns builds glue
;; unit is a kind of identity function: a -> m a
;; lift f = unit f
;; *    = bind f g
;; then in haskell:
;; x >>= f = bind f x
;; return = unit
;; and haskell has all sorts of fancy syntax to hide all of this as if it's ashamed...

(define (f x) `(,(* x 0.42) "hello"))
(define (g x) `(,(/ x 0.42) "fuck"))
(define (h x) (* x 0.42) )
(define (i x) (/ x 0.42) )

(define (bind f g)
	(lambda (x)
		(let* ( (r (g x)) (s (f (car r))) )
			`(,(car s) ,(string-append (cadr r) (cadr s))) ) ))

(define (unit f)
	(lambda (x)
		`(,(f x) "") ))

(define (lift f) (unit f) )

(define (main args)
	(dspl (f 42))
	(dspl (g 42))
	(dspl ((bind f g) 42))
	(dspl ((unit (lambda (x) (* x 0.42))) 42))
	(dspl ((bind (lift h) (lift i)) 42))
	(dsp ""))
	
