(in-package :cl-user)
(defpackage cl-play
  (:nicknames :play)
  (:use :cl)
  (:export :gl-app
           :ref-window
           :ref-program
           :ref-mouse-x
           :ref-mouse-y
           :with-init
           :make-app
           :play))
(in-package :cl-play)

;; blah blah blah.

(defclass gl-app ()
  ((window :accessor ref-window
           :initform (glfw:create-window :width 640
                                         :height 480
                                         :title "CL Play"
                                         :resizable nil)
           :initarg :window)
   (program :accessor ref-program
            :initform nil
            :initarg :program)
   (mouse-x :accessor ref-mouse-x
            :initform 0)
   (mouse-y :accessor ref-mouse-y
            :initform 0)))

(defmacro with-init (&body body)
  `(progn
     (glfw:initialize)
     (unwind-protect (progn ,@body)
       (%glfw:terminate))))

(defun make-app (title
                 &key
                 (width 640)
                 (height 480)
                 (api :opengl-api)
                 (profile :opengl-any-profile)
                 (major 1)
                 (minor 0))
  (let ((window (glfw:create-window :title title
                                    :width width
                                    :height height
                                    :resizable nil
                                    :client-api api
                                    :opengl-profile profile
                                    :context-version-major major
                                    :context-version-minor minor)))
    (print window)
    (make-instance 'gl-app
                   :window window
                   :program nil)))

(defmethod closep ((app gl-app))
  (let ((window (ref-window app)))
    (if (null window)
        nil
        (or (glfw:window-should-close-p window)
            (glfw:get-key :esc window)))))

(defmacro play (app &body body)
 `(let ((app ,app))
    (unwind-protect
      (setf %gl:*gl-get-proc-address* #'glfw:get-proc-address)
      (format t "~A~%" app)
      (loop while (not (closep app))
            do (progn
                 (gl:clear :color-buffer-bit)
                 (multiple-value-bind (x y)
                     (glfw:get-cursor-position (ref-window app))
                   (setf (ref-mouse-x app) x
                         (ref-mouse-y app) y))
                 ,@body)
            (glfw:swap-buffers (ref-window app))
            (glfw:poll-events))
      (format t "end~%"))
      
    (glfw:destroy-window (ref-window app))))

(defun create-program (vsource fsource)
  (let ((program (gl:create-program))
        (vs (gl:create-shader :vertex-shader))
        (fs (gl:create-shader :fragment-shader)))
    (gl:shader-source vs vsource)
    (gl:compile-shader vs)
    (gl:shader-source fs fsource)
    (gl:compile-shader fs)
    (let ((vs-log (gl:get-shader-info-log vs))
          (fs-log (gl:get-shader-info-log fs)))
      (when (> (length vs-log) 0)
        (format t "Vertex shader: ~A~%" vs-log))
      (when (> (length fs-log) 0)
        (format t "Fragment shader: ~A~%" fs-log)))
    (gl:attach-shader program vs)
    (gl:attach-shader program fs)
    (gl:link-program program)
    (let ((program-log (gl:get-program-info-log program)))
      (when (> (length program-log) 0)
        (format t "Program log: ~A~%" program-log)))
    program))
