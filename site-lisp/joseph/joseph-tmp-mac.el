;;; Code:
 ;; (setq tags-table-list '("/Users/jixiuf/repos/hello_c/opencv" "/usr/local/opt/opencv3/include"))

;; (setq helm-gtags-GTAGSLIBPATH-alist
;;       '(
;;         ("~/repos/emacs/"  "/usr/include/" "/usr/local/include")
;;         ("/Users/jixiuf/repos/hello_c/opencv" "/usr/local/Cellar/opencv3/3.0.0/include/" "/usr/local/include")
;;         ))

;; echo "" | g++ -v -x c++ -E -
(setq-default ac-clang-flags
              (mapcar (lambda (item)(concat "-I" item))
                      (split-string
                       "
 /usr/local/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/include
 /usr/local/opt/opencv3/include
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/7.3.0/include
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/System/Library/Frameworks
")))

;; (setq flymake-cc-additional-compilation-flags ;flymake for c++ c
;;       (mapcar (lambda (item)(concat "-I" item))
;;               (split-string

;;                "
;; /usr/local/Cellar/opencv/2.4.7.1/include/
;; /Users/jixiuf/repos/squirrel/librime/thirdparty/include
;; /Users/jixiuf/repos/squirrel/librime/include ./ ../ ../include/ ./include/")))

(provide 'joseph-tmp-mac)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-tmp-mac.el ends here
