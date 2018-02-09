;Josh Echols / J. Anthony Timberlake
;Assignment 1 - Scheme
;CS 401
;Spring 2018

;what is this element?
(define (constant? x) (number? x))

(define (bothconstant? arg1 arg2)
    (and (number? arg1) (number? arg2))
)       
    
;what is the operation?
(define (is-sum x)
    (and (pair? x) (equal? (car x) '+)))
    
(define (is-prod x)
    (and (pair? x) (equal? (car x) '*)))
    
(define (is-dif x)
    (and (pair? x) (equal? (car x) '-)))
    

;is it an operation?
(define (legal-op? x)
    (or (is-sum x) (is-prod x) (is-dif x)))
    
(define (is-plus x) (equal? x '+))
(define (is-times x) (equal? x '*))
(define (is-minus x) (equal? x '-))

(define (lhs x) (cadr x))
(define (rhs x)(caddr x))

;are we performing operation on two constants?
(define (base op arg1 arg2)
    (cond
        ((is-plus op) (+ arg1 arg2))
        ((is-minus op) (- arg1 arg2)) 
        ((is-times op)(* arg1 arg2))
    )
)

;term and constant
(define (constant&term? op arg1 arg2)
    (cond 
          ((is-plus op) (simplify (list '+ arg2 arg1)))
          ((is-times op) (simplify (list '* arg2 arg1 )))
    )
)

(define (subconstant&term? op arg1 arg2)
    (cond  
          ((is-minus op) (list '+ (list '- arg2) arg1))
    )
)
    
(define (apply-rules op arg1 arg2)
    (cond
    
        ;Rules 1,3,5
        ((bothconstant? arg1 arg2)
            (base op arg1 arg2)
        )
        
        ;Rule 6
        ((and (constant? arg2) (is-minus op))
            (subconstant&term? op arg1 arg2)
        )
        
        ;Rule 11, 13, 17
        ((and (is-times op) (is-sum arg1))
             (simplify (list '+ (list '* (lhs arg1) arg2) (list '* (rhs arg1) arg2)))
        )
        
        ;Rule 12, 14, 18
        ((and (is-times op) (is-sum arg2))
             (simplify (list '+ (list '* arg1 (lhs arg2)) (list '* arg1 (rhs arg2))))
        )
        
        ;Rule 15, 19
        ((and (is-times op) (is-dif arg1))
             (simplify (list '- (list '* (lhs arg1) arg2) (list '* (rhs arg1) arg2)))
        )
        
        ;Rule 16, 20
        ((and (is-times op) (is-dif arg2))
             (simplify (list '- (list '* arg1 (lhs arg2)) (list '* arg1 (rhs arg2))))
        )
        
        ;Rule 2,4
        ((constant? arg2)
            (constant&term? op arg1 arg2)
        )
        
        ;Rules 7,9
        ((and (is-plus op) (is-sum arg2))
            (simplify (list '+ (list '+ arg1 (lhs arg2)) (rhs arg2)))
        )
      
        ;Rules 8,10
        ((and (is-times op) (is-prod arg2))
            (simplify (list '* (list '* arg1 (lhs arg2)) (rhs arg2)))
        )
    
        (else(list op arg1 arg2))        
    )
)

(define (simplify expr)
    (cond 
        ((legal-op? expr)    
            (apply-rules (car expr) (simplify(cadr expr)) (simplify (caddr expr)))
        )
    (else expr)
    )
)