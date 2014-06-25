(asdf:defsystem #:zdircmp
    :description "zdircmp: directory comparison tool"
    :version "0.1"
    :author "Alexey Veretennikov <EMAIL-REDACTED>"
    :licence "GPL"
    :depends-on (#:cl-ncurses #:cl-fad #:swank #:alexandria)
    :components ((:file "util")
                 (:file "export-util")
                 (:file "command-ui")
                 (:file "mixin-view")
                 (:file "mixin-message")
                 (:file "mixin-activity")
                 (:file "constants"
                        :depends-on ("export-util"))
                 (:file "utils-ui"
                        :depends-on ("export-util"))
                 (:file "base-view"
                        :depends-on ("utils-ui" "mixin-view" "wm-ui"))
                 (:file "wm-ui"
                        :depends-on ("utils-ui" "mixin-view" "constants"))
                 (:file "bordered-view"
                        :depends-on ("utils-ui" "base-view"))
                 (:file "message-view" :depends-on ("utils-ui"
                                                    "base-view"
                                                    "mixin-message"
                                                    "mixin-activity"))
                 (:file "status-view" :depends-on ("util" "utils-ui" "base-view"))
                 (:file "help-view" :depends-on ("util" "utils-ui" "base-view"))
                 (:file "model-node"
                        :depends-on ("util"
                                     "mixin-message"
                                     "mixin-activity"))
                 (:file "model-tree"
                        :depends-on ("util" "model-node"))
                 (:file "main-view"
                        :depends-on ("util"
                                     "base-view"
                                     "command-ui"
                                     "model-node"
                                     "model-tree"
                                     "constants"
                                     "utils-ui"
                                     "message-view"))
                 (:file "main"
                        :depends-on ("constants"
                                     "utils-ui"
                                     "base-view"
                                     "message-view"
                                     "status-view"
                                     "help-view"
                                     "main-view"
                                     "wm-ui"
                                     "model-node"))))
