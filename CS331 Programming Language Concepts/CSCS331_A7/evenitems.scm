#lang scheme
; evenitems.scm
; Name : Hanting Yang
; CSCE331 Assignment 7 part C
; 4/29/2019

; This takes one parameter, a list. 
; It returns a list consisting of all items in the given list with even index, 
; where indices start with zero.
; Sample input & output: 
; > (evenitems '(8 3 1 9))
; (8 1)
; > (evenitems '(8 3 1 9 6))
; (8 1 6)
; > (evenitems '())
; ()
; > (evenitems '(3))
; (3)
; > (evenitems '("dog" 3.2 #f))
; ("dog" #f)
; > (evenitems '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
; (1 3 5 7 9 11 13 15)
(define (evenitems xs)
  (if (null? xs) '()
      (if (not(null? (cdr xs)))
                (cons (car xs) (evenitems (cddr xs))) 
      xs)    
  )
)