; -*- mode: common-lisp -*-

(in-package "CL-USER")

(hunchentoot:define-easy-handler  (home-page :uri "/") ()
  "<html><body>
     <b>This is a web page!</b><br/>
     <img src='lisp-logo120x80.png'/>
   </body></html>")

(defun initialize-application (&key port)
  (setf hunchentoot:*dispatch-table*
        `(,@hunchentoot:*dispatch-table*
          ,(hunchentoot:create-folder-dispatcher-and-handler
            "/" #p"/app/static/")))
  (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port)))

