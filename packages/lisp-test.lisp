(define (loop-args items)
  (if (null? items)
      0
      (begin
        (display "  ")
        (display (car items))
        (newline)
        (loop-args (cdr items)))))

(display "hello from a pls package")
(newline)

(display "you just installed this with pls add")
(newline)

(let ((args (script-arguments)))
  (if (null? args)
      (display "no arguments were passed")
      (begin
        (display "arguments:")
        (newline)
        (loop-args args))))