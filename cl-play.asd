#|
  This file is a part of cl-play project.
  Copyright (c) 2017 Tamamu
|#

#|
  Author: Tamamu
|#

(in-package :cl-user)
(defpackage cl-play-asd
  (:use :cl :asdf))
(in-package :cl-play-asd)

(defsystem cl-play
  :version "0.1"
  :author "Tamamu"
  :license "MIT"
  :depends-on (:cl-opengl
               :cl-glfw3)
  :components ((:module "src"
                :components
                ((:file "cl-play"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op cl-play-test))))
