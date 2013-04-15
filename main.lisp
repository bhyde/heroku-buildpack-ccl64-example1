; -*- mode: common-lisp -*-

(in-package "CL-USER")


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
            "/" "/app/static/")))

  ;; If we are restarting, say for example when we are developing,
  ;; then we need to stop any existing web server.
  (when *my-acceptor*
    (hunchentoot:stop *my-acceptor*))

  ;; Start the web server.
  (setf *my-acceptor*
        (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port))))

