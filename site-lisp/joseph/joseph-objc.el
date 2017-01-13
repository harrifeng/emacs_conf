;;; joseph-objc.el --- Description

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords:
;; URL:

;; Copyright (C) 2016, 纪秀峰, all rights reserved.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
;;;###autoload
(defun objc-mode-callback()
  (company-mode 1)
  (local-set-key "]" 'objc-surround)
  (setq-local company-backends
              '( company-clang company-xcode company-semantic  company-files  company-keywords company-dabbrev))
  (when (equal system-type 'darwin)
    ;; Forgot what this was for..think some os x issues.
    (setenv "LC_CTYPE" "UTF-8"))

  (setq-local
   ;; flycheck-make-executable "/usr/local/bin/make"
   company-clang-executable
   "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
   )

  ;; (setq    flycheck-c/c++-clang-executable
  ;;          (concat "/Applications/Xcode.app/Contents/Developer/"
  ;;                  "Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"))

  (setq-local  company-clang-arguments
               '(
                 ;; "-std=c++11"

                 ;; If coding for OS X
                 "-isysroot"
                 "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk"

                 ;; If coding for iOS
                 ;; "-isysroot"
                 ;; "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
                 ))

  (let ((xcode-proj-root (find-xcode-proj-root))
        project-name)
    (when xcode-proj-root
      (require 'helm-gtags)
      (setq project-name
            (file-relative-name
             (directory-file-name xcode-proj-root)
             (file-name-directory(directory-file-name xcode-proj-root))))
      (helm-gtags-set-GTAGSLIBPATH-alist (concat xcode-proj-root project-name)
                                         `(
                                           ;; ,(concat xcode-proj-root project-name)
                                           "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk"
                                           "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"))
      )
    )
  )
(defun find-xcode-proj-root()
  (locate-dominating-file
   default-directory
   (lambda(dir) (directory-files dir t "\.xcodeproj$" t))))
(defun objc-surround()
  (interactive)
      (unless (looking-back "\]") (forward-char 1))
    (backward-sexp)
    (insert "[")
    (forward-sexp)
    (insert "]")
    (backward-char 1)
  )






(provide 'joseph-objc)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-objc.el ends here
