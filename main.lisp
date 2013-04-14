; -*- mode: common-lisp -*-

(in-package "CL-USER")


;;; This is a bit odd.  cl-user::*root* is usually by the buildapp.  But,
;;; if we are developing we need to set it ourselves.  The following
;;; presumes that the root is the directory where the system resides.
 
(defvar cl-user::*root*
  (namestring 
   (asdf:COMPONENT-RELATIVE-PATHNAME (asdf:find-system "superman"))))



;;; The home page of our tiny website.
(hunchentoot:define-easy-handler  (home-page :uri "/") ()
  "<html><body>
     <b>This is a web page!</b><br/>
     <img src='lisp-logo120x80.png'/>
   </body></html>")

(defvar *my-acceptor* nil)

;;; Initialize-application 
(defun initialize-application (&key port)

  ;; Set the dispatch table so easy-handler pages are served, 
  ;; and the files in <root>/static.
  (setf hunchentoot:*dispatch-table*
        `(hunchentoot:dispatch-easy-handlers
          ,(hunchentoot:create-folder-dispatcher-and-handler 
            "/" (concatenate 'string cl-user::*root* "static/"))))

  ;; If we are restarting, say for example when we are developing,
  ;; then we need to stop any existing web server.
  (when *my-acceptor*
    (hunchentoot:stop *my-acceptor*))

  ;; Start the web server.
  (setf *my-acceptor*
        (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port))))

