;; -*- coding:utf-8 -*-
;;; joseph-program.el --- some functions for programing

;; Copyright (C) 2010 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords: java csharp code

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

;;; Commands:
;;
;; Below are complete command list:
;;
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:

(add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)
(eval-after-load 'csharp-mode '(add-csc-2-path-env))
(eval-after-load 'csharp-mode '(add-gacutil-2-path-env))

;; (add-hook 'lua-mode-hook 'flymake-lua-load)


(setq-default gdb-many-windows t)
(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)
;; (global-set-key [f6] 'gud-step)
;; (global-set-key [f7] 'gud-next)
;; (global-set-key [f8] 'gud-finish)

;; objc
(with-eval-after-load 'find-file
  ;; for ff-find-other-file
  (nconc (cadr (assoc "\\.h\\'" cc-other-file-alist)) '(".m" ".mm"))
  (when (equal system-type 'darwin)
    (add-to-list 'cc-search-directories "/System/Library/Frameworks")
    (add-to-list 'cc-search-directories "/Library/Frameworks")
    (add-to-list 'cc-search-directories "/usr/local/include/*")))

(with-eval-after-load 'cc-mode
  ;; 切换头文件与源文件
  (define-key c-mode-base-map (kbd "C-c ;") 'ff-find-other-file))



(defadvice ff-get-file-name (around ff-get-file-name-framework
                                    (search-dirs
                                     fname-stub
                                     &optional suffix-list))
  "Search for Mac framework headers as well as POSIX headers."
  (or
   (if (string-match "\\(.*?\\)/\\(.*\\)" fname-stub)
       (let* ((framework (match-string 1 fname-stub))
              (header (match-string 2 fname-stub))
              (fname-stub (concat framework ".framework/Headers/" header)))
         ad-do-it))
   ad-do-it))
(ad-enable-advice 'ff-get-file-name 'around 'ff-get-file-name-framework)
(ad-activate 'ff-get-file-name)



;;my config file
;;(require 'ajc-java-complete-config)
(autoload 'ajc-java-complete-mode "ajc-java-complete-config" "enable AutoJavaComplete." nil)
(autoload 'ajc-4-jsp-find-file-hook "ajc-java-complete-config" "enable AutoJavaComplete." nil)
(add-hook 'java-mode-hook 'ajc-java-complete-mode)
(add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)

;; # (-u flag for "update")
;; go get -u github.com/nsf/gocode
;; windows
;; go get -u -ldflags -H=windowsgui github.com/nsf/gocode

;; go get -u github.com/dougm/goflymake

;; go get -u -v github.com/9fans/go/...
;; mv $GOPATH/src/github.com/9fans $GOPATH/src/9fans.net
;; go get github.com/rogpeppe/godef



;; github.com/syohex/emacs-go-eldoc

;;on mac
;;  cat /etc/launchd.conf
;; setenv GOROOT /usr/local/go
;; setenv GOPATH /Users/jixiuf/repos/proj_golang
;; setenv PATH  /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/go/bin:/Users/jixiuf/Applications/adt-bundle-mac-x86_64-20130522/sdk/platform-tools:/Users/jixiuf/repos/proj_golang/bin
(with-eval-after-load 'go-mode
  (when (getenv "GOPATH") (setq exec-path (delete-dups  (cons (concat (getenv "GOPATH") "/bin") exec-path))))

(with-eval-after-load 'cc-mode
  (require 'joseph-objc))
  (require 'go-autocomplete)
  ;; (require 'flymake)
  ;; (require 'go-flycheck)
  ;; (require 'go-flymake)
  (when (executable-find "gofmt")
    (setq-default gofmt-command (executable-find "gofmt")))


;; if [ ! -d $GOPATH/src/golang.org/x/tools ]; then
;;     cd $GOPATH/src/golang.org/x;git clone  https://github.com/golang/tools.git;cd -
;; else
;;     cd $GOPATH/src/golang.org/x/tools;git pull;cd -
;; fi
;; go install golang.org/x/tools/cmd/goimports

(when (executable-find "goimports")
    (setq-default gofmt-command (executable-find "goimports")))

  ;; (setq gofmt-command "goimports")
  ;; (define-key go-mode-map ";" 'joseph-append-semicolon-at-eol)

  ;; git pre-commit for gofmt
  ;; http://tip.golang.org/misc/git/pre-commit
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; (add-hook 'after-save-hook 'go-auto-compile t)

  ;; (require 'go-eldoc) ;; Don't need to require, if you install by package.el
  (add-hook 'go-mode-hook 'go-eldoc-setup) ;autoloaded
  (add-hook 'go-mode-hook (lambda ()
                            (setq require-final-newline nil)
                            (modify-syntax-entry ?_  "_" (syntax-table)) ;还是让 "_" 作为symbol，还不是word
                            (flycheck-mode 1)
                            (local-set-key (kbd "C-c i") 'go-goto-imports)
                            (local-set-key (kbd "C-c g") 'golang-setter-getter)
                            (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))

  ;; (add-hook 'kill-buffer-hook 'go-clean-flymake-temp-file);; hide show mode 代码折叠
  )
;; (defun go-clean-flymake-temp-file()
;;   (when (eq major-mode 'go-mode)
;;     (flymake-simple-cleanup)))

;; (defun go-auto-compile()
;;   "go auto compile"
;;   (when (string-match "\\.go$" (buffer-name))
;;     (compile "go build")
;;       (shell-command "go install")
;;     ;; (call-interactively 'next-error)
;;     ;; (let ((msg  (shell-command-to-string "go build")))
;;     ;;   (unless (string-equal "" msg)
;;     ;;     (message "%s " msg)
;;     ;;     (call-interactively 'next-error)
;;     ;;     )
;;     ;;   )
;;     ;; (start-process "compile my go" "*compilation*" "go" "build" )
;;     ))

;; (define-key-lazy  java-mode-map ";" 'joseph-append-semicolon-at-eol)
;; (add-hook 'java-mode-hook 'hs-minor-mode);; hide show mode 代码折叠

;; (when (featurep 'w3m-load)  (require 'w3m-load))

;; M-x : w3m
;; (setq-default w3m-command "w3m")


(provide 'joseph-program)
;;; joseph-program.el ends here
