;; -*- coding:utf-8 -*-
;;在gentoo上，好像有个bug，正常情况下，emacs 会有一个loaddefs.le的文件
;;里面的内容全部是(autoload) 这样的语句，而这些语句不是手动加入的而是通过
;; (update-directory-autoloads) (update-file-autoloads)
;;这样的函数自动将某个el文件里的可以autoload的函数加入到这个文件中
;;没有bug 的emacs ,source-directory=/usr/share/emacs/23.2.*/
;;在这个loaddefs.el 文件默认是在source-directory/lisp/loaddefs.el这样
;;的位置,因为gentoo上 编译的emacs 有bug,导致source-direcotry
;;指向/var/tmp/portage/目录下一个很深的目录，故而
;;设置source-directory指向另一个路径,而loaddefs.el文件名也
;;改成了joseph-loaddefs.el.以避免与系统的loaddefs.el冲突
;;如此，再运行;; (update-directory-autoloads) (update-file-autoloads)
;;就会将自动生成的autoload 语句加入到
;;joseph_site-lisp_install_path/lisp/joseph-loaddefs.el
;;文件中，我只需要在init.el文件中(require 'joseph-loaddefs)
;;即可autoload主些函数
;;另外想让一个函数可以在运行
;;(update-directory-autoloads) (update-file-autoloads)
;;时加入到loaddefs中，只需要在函数声明的上面加上一个
;;      `;;;###autoload'
;;
(eval-when-compile
    (add-to-list 'load-path  (expand-file-name "~/.emacs.d/site-lisp/submodules/joseph-file-util/"))
    (require 'joseph-file-util)
    (require 'autoload)
    )

(setq source-directory (expand-file-name "~/.emacs.d/site-lisp/"))
(setq generated-autoload-file "joseph-loaddefs.el")

;;;###autoload
(defun update-directory-autoloads-recursively()
  "update autoload cookies .scanning all directories under
~/.emacs.d/site-lisp/ recursively. to
` ~/.emacs.d/site-lisp/lisp/joseph-loaddefs.el'"
  (interactive)
  (remove-hook 'after-save-hook 'joseph_compile_current_el_without_output)
  (let ((el-files  (all-files-under-dir-recursively
                    (expand-file-name "~/.emacs.d/site-lisp")
                    "\\.el$" nil
                    (concat
                     "\\.git" "\\|\\.svn" "\\|RCS" "\\|rcs" "\\|CVS" "\\|cvs"
                     "\\|session\\.el$"         "\\|/emacs-jabber"
                     "\\|/nxhtml\\b"            "\\|/cedet-1.1/"
                     "\\|joseph-loaddefs.el$"   "\\|/org-mode\\b"
                     "\\|/helm/"                "\\|/auto-complete/"
                     "\\|/yasnippet/" "\\|/evil/" "\\|/expand-region.el/"
                     "\\|/ert\\b" "\\|magit\\b")
                    t)))
    (dolist (el el-files)
      (message el)
      (update-file-autoloads el t)
      )
    ;; (update-directory-autoloads "~/.emacs.d/site-lisp/icicles/")
    )
  (add-hook 'after-save-hook 'joseph_compile_current_el_without_output)
  )

;;(add-hook 'kill-emacs-hook 'update-directory-autoloads-recursively)
;;emacs退出时，自动update autoload
 (provide 'joseph-autoload)
