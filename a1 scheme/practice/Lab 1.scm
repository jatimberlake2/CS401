(define fact (lambda (a)
        (cond ((= a 0) 1)
        (else (* a (fact (- a 1)))))))

(define sum (lambda (a)
        (cond ((= a 0) 0)
        (else (+ a (sum (- a 1)))))))
		
(cons 'a (cons (cons 'b (cons 'b (cons 'c '())) (cons 'd '()))))

(define test3 (lambda (x)
	(cond ((= x 3)(display "Yes!"))
	(else (display "You suck!")))))
	
(define testl3 (lambda (x)
	(cond ((> (length x) 2) (display "Affirmative!"))
	((< (length x) 2) (display "fasdhfasdl"))
	(else (display "You hecking suck!")))))
