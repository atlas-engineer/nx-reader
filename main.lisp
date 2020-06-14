(in-package :cl-user)

(defpackage :nx-reader
  (:use :common-lisp :nyxt)
  (:export
   #:rss-site
   #:rss-generate-html
   #:rss-urls
   #:rss-feeds-generate-html))

(in-package :nx-reader)

(defparameter rss-urls (list))

(defun rss-site (url)
  "Retrieve the RSS from a specific feed and parse it into an RSS object."
  (rss:parse-rss-stream (dex:get url :want-stream t)))

(defun rss-generate-html (rss-object)
  "Generate the HTML representing a particular RSS feed."
  (markup:markup
   (:details 
    :open "open"
    (:summary (:h1 :style "display:inline" (rss:title rss-object)))
    (:p (:a :href (rss:link rss-object) (rss:link rss-object)))
    (:p (rss:description rss-object))
    (:ul (loop for item in (rss:items rss-object)
               collect
               (markup:markup (:li (:p (:b (rss:title item)))
                                   (:p (:a :href (rss:link item) (rss:link item)))
                                   (:p (markup:raw (rss:description item))))))))))

(defun rss-feeds-generate-html (&optional (rss-urls rss-urls))
  "Generate the HTML representing a list of RSS feeds."
  (markup:markup
   (:span (loop for rss-url in rss-urls collect
                (rss-generate-html (rss-site rss-url))))))

;; Commands must be defined in the Nyxt package
(in-package :nyxt)
(define-command show-rss-feeds ()
  "Show RSS Feeds. To set your RSS feeds, set RSS-URLS in the
NX-READER package."
  (let* ((rss-buffer (make-buffer :title "*RSS Feed*"))
         (rss-buffer-contents (nx-reader:rss-feeds-generate-html nx-reader:rss-urls))
         (insert-contents (ps:ps (setf (ps:@ document Body |innerHTML|)
                                       (ps:lisp rss-buffer-contents)))))
    (ffi-buffer-evaluate-javascript rss-buffer insert-contents)
    (set-current-buffer rss-buffer)
    rss-buffer))
