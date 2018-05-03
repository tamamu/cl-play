(in-package :cl-user)
(defpackage cl-play-test
  (:use :cl
        :cl-play
        :prove))
(in-package :cl-play-test)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-play)' in your Lisp.

(plan nil)

;; blah blah blah.

(with-init
  (let ((app (make-app "Test")))
    (print app)
    (play app
      (format t "foo~%"))))

(finalize)
