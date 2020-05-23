(in-package :cl-user)

(defpackage :nx-reader
  (:use :common-lisp :next)
  (:export
   #:document-keywords))

(defun rss-site (url)
  (rss:parse-rss-stream (dex:get url :want-stream t)))
