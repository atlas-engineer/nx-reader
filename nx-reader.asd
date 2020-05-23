(asdf:defsystem nx-reader
  :depends-on (:next
               :cl-markup
               :rss
               :dexador)
  :components ((:file "main")))
