(asdf:defsystem nx-reader
  :depends-on (:nyxt
               :cl-markup
               :rss
               :dexador)
  :components ((:file "main")))
