;; (setq exec-path (delete-dups  (cons "/usr/local/bin" exec-path)))
;; (setenv "PATH" (concat  "/usr/local/bin:" (getenv "PATH") ))
(setq exec-path-from-shell-variables '("PATH" "MANPATH" "GOROOT" "GOPATH" "EDITOR" "PYTHONPATH"))
(setq exec-path-from-shell-check-startup-files nil)
(setq exec-path-from-shell-arguments '("-l" "-i")) ;remove -i read form .zshenv
(exec-path-from-shell-initialize)




;; (let ((path (shell-command-to-string ". ~/.zshrc; echo -n $PATH|tail -n 1")))
;;   (setenv "PATH" path)
;;   (setq exec-path
;;         (append
;;          (split-string-and-unquote path ":")
;;          exec-path)))

;; ;; 如果$PATH里有， 而exec-path里无的， 将其加入
;; (dolist ( path (split-string (getenv "PATH") ":" t "[ \t/]"))
;;   (add-to-list 'exec-path path))




(setenv "LANG" "zh_CN.UTF-8")

;; (setq-default server-auth-dir (expand-file-name "~/.emacs.d/cache/"))
;; (setq-default server-socket-dir (expand-file-name "~/.emacs.d/cache/"))
;; (setq-default server-name "emacs-server-file")
;; (require 'server)
;; (when (not (server-running-p)) (server-start))


;; (setq-default server-auth-dir (expand-file-name "~/.emacs.d/cache/"))
;; (setq-default server-socket-dir  (expand-file-name "~/.emacs.d/cache/"))
;; (setq-default server-name "emacs-server-file")
;; (require 'server)
;; (when (not (server-running-p)) (server-start))

;; 允许emacs 直接编辑 OSX下的 .plist文件
;; Allow editing of binary .plist files.
(add-to-list 'jka-compr-compression-info-list
             ["\\.plist$"
              "converting text XML to binary plist"
              "plutil"
              ("-convert" "binary1" "-o" "-" "-")
              "converting binary plist to text XML"
              "plutil"
              ("-convert" "xml1" "-o" "-" "-")
              nil nil "bplist"])

;; # mac 上 emacs 直接编辑二进制applescript
(add-to-list 'jka-compr-compression-info-list
             `["\\.scpt\\'"
               "converting text applescript to binary applescprit " ,(expand-file-name "applescript-helper.sh" "~/.emacs.d/bin/") nil
               "converting binary applescript to text applescprit " ,(expand-file-name "applescript-helper.sh" "~/.emacs.d/bin/") ("-d")
               nil t "FasdUAS"])


;;It is necessary to perform an update!
(jka-compr-update)
(global-set-key (kbd "s-m") 'toggle-frame-maximized) ;cmd-m
(global-set-key  (kbd "s-a") 'evil-mark-whole-buffer) ;mac Cmd+a
(global-set-key  (kbd "s-t") 'multi-term-toggle) ;mac Cmd+a

;; f11 (toggle-frame-fullscreen) default
(setq ns-pop-up-frames nil)


;; (defvar paste-to-osx-timer nil)
;; (defun paste-to-osx (&optional text push)
;;   (let ((process-connection-type nil)   ; ; use pipe
;;         (default-directory "~/"))
;;     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
;;       (process-send-string proc (or text (car kill-ring)))
;;       (process-send-eof proc)
;;       (setq paste-to-osx-timer nil))))

;; (defun copy-from-osx ()
;;   "Copies the current clipboard content using the `pbcopy` command"
;;   (let ((default-directory "~/"))
;;     (shell-command-to-string "pbpaste")))

;; (defun paste-to-osx-timer-hook (text &optional push)
;;   (unless paste-to-osx-timer
;;     (setq paste-to-osx-timer (run-with-idle-timer 0.9 nil 'paste-to-osx))))

;; ;; (setq interprogram-paste-function 'copy-from-osx)
;; ;; (setq interprogram-cut-function 'paste-to-osx)
;; (setq interprogram-cut-function 'paste-to-osx-timer-hook)
(defun term-enable-mouse-scroll(&optional f) ;
  (with-selected-frame f
    (when (and (equal system-type 'darwin) (not (display-graphic-p)))
      (require 'mouse) ;; needed for iterm2 compatibility
      (xterm-mouse-mode t)
      (global-set-key [mouse-4] '(lambda ()
                                   (interactive)
                                   (scroll-down 1)))
      (global-set-key [mouse-5] '(lambda ()
                                   (interactive)
                                   (scroll-up 1))))))

(add-hook 'after-make-frame-functions 'term-enable-mouse-scroll)




(provide 'joseph-mac)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-mac.el ends here
