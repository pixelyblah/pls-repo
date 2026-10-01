(define (loop items)
  (if (null? items)
      0
      (begin
        (display "  ")
        (display (car items))
        (newline)
        (loop (cdr items)))))

(display "hello")
(newline)
(let ((args (script-arguments)))
  (if (null? args)
      (display "no arguments")
      (loop args)))
