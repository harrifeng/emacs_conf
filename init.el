;; -*-no-byte-compile: t; -*-
;;                                            ╭∩╮⎝▓▓⎠╭∩╮
;;                                           ▇█▓▒░◕~◕░▒▓█▇
;; ╔囧╗╔囧╝╚囧╝╚囧╗╔囧╗╔囧╝╚囧╝╚囧╗╔囧╗╔囧╝╚囧╝╚囧╗╔囧╗╔囧╝╚囧╝╚囧╗╔囧╗╔囧╝╚囧╝╚囧╗╔囧╗╔囧╝╚囧╝╚囧╗╔囧╗╔囧╝╚囧╝╚囧╗
;; ╭(╯3╰)╮
;;   ◕‿◕

(require 'package)

(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))





(defvar joseph-origin-load-path load-path)
(load (expand-file-name "~/.emacs.d/site-lisp/submodules/joseph-file-util/joseph-file-util"))
(defvar user-load-path  (all-subdir-under-dir-recursively
                        (expand-file-name "~/.emacs.d/site-lisp/") nil nil
                        "\\.git\\|\\.svn\\|RCS\\|rcs\\|CVS\\|cvs\\|syntax\\|templates\\|tests\\|/classes\\|icons\\|image\\|testing\\|etc\\|script$\\|/ert$\\|/dict$\\|snippets\\|yasnippet/yasmate\\|/test/\\|org-mode-git/contrib/scripts\\|/doc$\\|/docs$\\|nxhtml/html-chklnk/PerlLib\\|dotemacs_priv/\\|screenshot\\|expand-region.el/features\\|expand-region.el/util" t))
(dolist (path user-load-path) (add-to-list 'load-path path))

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/") t)

(setq custom-file (expand-file-name "~/.emacs.d/site-lisp/joseph/custom-file.el"))
(require 'custom-file)

(defun ensure-package-installed (packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     ;; (package-installed-p 'evil)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; 国内有人做了个melpa 的镜像，
;; (add-to-list 'package-archives '("popkit" . "http://elpa.popkit.org/packages/"))

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository
;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))


;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/")) ;stable
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(ensure-package-installed package-selected-packages)

;; 调试工具 , 打印出require 的调用轨迹
  ;; (defadvice require (around require-around)
  ;;   "Leave a trace of packages being loaded."
  ;;   (let* ((feature (ad-get-arg 0))
  ;;          (require-depth (or (and (boundp 'require-depth) require-depth)
  ;;                             0))
  ;;          (prefix (concat (make-string (* 2 require-depth) ? ) "+-> ")))
  ;;     (cond ((featurep feature)
  ;;            (message "(info) %sRequiring `%s'... already loaded"
  ;;                     prefix feature)
  ;;            (setq ad-return-value feature))
  ;;           (t
  ;;            (let ((lvn/time-start))
  ;;              (message "(info) %sRequiring `%s'..." prefix feature)
  ;;              (setq lvn/time-start (float-time))
  ;;              (let ((require-depth (1+ require-depth)))
  ;;                ad-do-it)
  ;;              (message "(info) %sRequiring `%s'... %s (loaded in %.2f s)"
  ;;                       prefix feature
  ;;                       (locate-library (symbol-name feature))
  ;;                       (- (float-time) lvn/time-start)))))))
  ;; (ad-activate 'require)


(require 'joseph-init)

(when (equal system-type 'windows-nt) (require 'joseph-tmp-w32 nil t))
(when (equal system-type 'darwin) (require 'joseph-tmp-mac nil t))
(when (equal system-type 'gnu/linux) (require 'joseph-tmp-linux nil t))

(require 'joseph-tmp nil t)

;; (require 'custom-mode-line)
