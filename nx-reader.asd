(asdf:defsystem nx-reader
  :depends-on (:next
               :rss
               :dexador)
  :components ((:file "main")))
