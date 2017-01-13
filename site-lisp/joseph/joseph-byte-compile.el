;;; -*- coding:utf-8 -*-
;; (eval-when-compile '(require 'cedet-build))
;; (declare-function cedet-build-in-default-emacs "cedet-build")
(declare-function define-package "package")
;; (declare-function majmodpri-sort-lists "majmodpri")
;; (require 'package)
;;;###autoload
(defun joseph_compile_current_el_without_output()
  (when  (string-match "\\.el$" (buffer-file-name))
    (apply 'start-process ;;
           "compile my el"
           "*compilation*"
           "emacs"
           (apply 'list "-batch"
                  "-l" (expand-file-name "~/.emacs.d/site-lisp/joseph/joseph_byte_compile_include.el")
                  "-f" "batch-byte-compile"
                  (buffer-file-name)
                  nil)) ))


(defun byte-compile-all-my-el-files()
  "byte compile all by el files under ~/.emacs.d/site-lisp/"
  (let ((load-path (copy-alist load-path))
        (user-load-path (all-subdir-under-dir-recursively
                         (expand-file-name "~/.emacs.d/site-lisp/") nil nil
                         "\\.git\\|\\.svn\\|RCS\\|rcs\\|CVS\\|cvs\\|doc\\|syntax\\|templates\\|tests\\|icons\\|testing\\|etc\\|script$" t))
        (files  (all-files-under-dir-recursively (expand-file-name "~/.emacs.d/site-lisp/")  "\\.el$" nil
                                                 (concat
                                                  "\\.git" "\\|\\.svn" "\\|RCS" "\\|rcs" "\\|CVS" "\\|cvs"
                                                  "\\|joseph_init.el$"
                                                  "\\|malabar-1.5-SNAPSHOT\\b"
                                                  "\\|\\bcedet-1.1\\b"
                                                  "\\|\\borg-mode-git\\b"
                                                  "\\|\\bdistel\\b"
                                                  "\\|expand-region/util"
                                                  "\\|expand-region/features\\b"
                                                  "\\|emacs-jabber-0.8.90\\b"
                                                  "\\|auto-complete/tests\\b"
                                                  "\\|popup-test.el\\b"
                                                  "\\|evil\\b"
                                                  "\\|auto-complete/"
                                                  "\\|popwin-el/test/"
                                                  "\\|nxhtml/tests/"
                                                  "\\|/helm/"
                                                  "\\|/org-mode-git/"
                                                  "\\|/magit/"
                                                  "\\|/popwin-yatex.el"
                                                  "\\|nxhtml/related/csharp-mode.el"
                                                  "\\|evil-tests.el\\b")

                                                 t
                                                 ))
        )
    (dolist (path user-load-path) (add-to-list 'load-path path))
    ;; (setq files  (joseph-delete-matched-files files "/cedet-1.0/" t ));;不对cedet 进行编译
    ;;这两句话保证joseph_init.el最后编译,如果先编译了它,那么所有的el都会被load进来,
    ;;包括folding.el ,不知道什么原因byte-compile-file 与folding好像有冲突
    ;;如果一个el里fold了,那么隐藏的内容无法被编译
    ;; (setq files (joseph-delete-matched-files files "joseph_init.el$"))
    (add-to-list 'files   (expand-file-name "~/.emacs.d/site-lisp/joseph/custom-file.el") t)
    (add-to-list 'files   (expand-file-name "~/.emacs.d/site-lisp/joseph/joseph_init.el") t)
    (dolist (file files)
      (byte-compile-file file nil)
      )
    ;; (require 'cedet-build) (cedet-build-in-default-emacs) ;;compile cedet
    )
  )


(defun byte-compile-all-my-el-files-batch()
  (load (expand-file-name "~/.emacs.d/site-lisp/submodules/joseph-file-util/joseph-file-util"))
  (byte-compile-all-my-el-files)
  )

(provide 'joseph-byte-compile)
