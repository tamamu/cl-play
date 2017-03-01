#|
  This file is a part of cl-play project.
  Copyright (c) 2017 Tamamu
|#

(in-package :cl-user)
(defpackage cl-play-test-asd
  (:use :cl :asdf))
(in-package :cl-play-test-asd)

(defsystem cl-play-test
  :author "Tamamu"
  :license "MIT"
  :depends-on (:cl-play
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "cl-play"))))
  :description "Test system for cl-play"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
