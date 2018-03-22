 ;   (if (and (or (equal? op '+)(equal? op '*)) (symbol? a) (integer? b))
  ;      (list '+ (list '- b) a);(list op b a)
  ;  )
  
  ;(6)(list '+ (list '- (list-ref str 1)) (list-ref str 2))
;(list '+ (list '- b) a)

       ; (if (eq? op -)  ;handle subtraction for symbols
        ;    (list '+ (list '- b) a)

        (if (equal? op '-)
                (display "Test")
            )
            
    (if (and (or (equal? op '+) (equal? op '*) (equal? op '/)) (symbol? a) (integer? b))
        (list op b a)
        (if (equal? op '-)
            (list '+ (list '- b) a)
            (list op a b)
        )
    )
                       (define op2 (list-ref b 0))
                       (define a2 (list-ref b 1))
                       (define b2 (list-ref b 2))
                       
                       (define (op x)
                            (if (list? x)
                                (car x)
                                ('3)
                            )
                        )
                        