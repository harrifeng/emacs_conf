;;; -*- coding:utf-8 -*-
;; FileNameCache(Emacs 自带的功能,可接合helm使用)
;;; 不再需要 ，似乎当cache的文件很多时，速度有点慢，使用joseph-helm-filelist 代替之
;; ;;; 注释
;; ;; C-x C-f 时寻找文件可以不用输入完整路径,不过要事先将目录加到它入它和管理当中
;; ;;不必使用书签可以快速打开常用的文件,可以将一个项目的源码目录加进来,
;; ;;几种加入方式
;; ;;不过如果递归加入的目录很深,启动速度会减慢
;; ;; (file-cache-add-directory )
;; ;;(file-cache-add-directory-using-find )
;; ;;(file-cache-add-directory-using-locate )
;; ;;(file-cache-add-directory-list) <RET> VARIABLE <RET>' like:load-path
;; ;;(file-cache-add-directory-recursively "~/emacsd/")
;; ;;在minibuffer 中输入部分文件名,然后C-Tab 补全
;; ;;但是用C-Tab补全还是有点别扭,又不好覆盖Tab的补全功能
;; ;;不过可以结合helm 使用,helm提供的使用FileNameCache的source
;; ;;helm-c-source-file-cache,在helm中已将其加到helm-sources
;; ;;C-x C-f C-TAB C-g
;; ;;; config
;; (require 'filecache)
;; ;;将 .git 目录排除在外
;; (add-to-list 'file-cache-filter-regexps "\\.git\\>")
;; (add-to-list 'file-cache-filter-regexps "\\.svn\\>")
;; (add-to-list 'file-cache-filter-regexps "Debug\\>")
;; (add-to-list 'file-cache-filter-regexps "bin\\>")
;; (add-to-list 'file-cache-filter-regexps "Debug\\>")
;; (add-to-list 'file-cache-filter-regexps "\\.tmp$")
;; (add-to-list 'file-cache-filter-regexps "\\.dll$")
;; (eval-after-load 'savehist
;;   '(progn
;;      (add-to-list 'savehist-additional-variables 'file-cache-alist)
;;     ))

;; (unless file-cache-alist
;;   ;;   (file-cache-add-directory-using-find "~/project")
;;   ;;   (file-cache-add-directory-recursively "/")
;;   ;;   (file-cache-add-directory-list load-path)
;;   ;;   (file-cache-add-directory "/java/java/Emacs/wiki/elisp/")
;;   (file-cache-add-directory (expand-file-name "~/.emacs.d/site-lisp/joseph/"))
;;   ;; (file-cache-add-directory-using-find joseph_joseph_install_path)
;;   (when (equal system-type 'gnu/linux)
;; ;    (file-cache-add-directory-using-find "/etc")
;;     (file-cache-add-directory "~/"))
;;   ;;  (file-cache-add-file-list (list "~/foo/bar" "~/baz/bar"))
;;   )
;; ;;; file-cache-save-cache-to-file file-cache-read-cache-from-file 函数定义
;; ;;官方提供的几个file-cache-add-directory-*的方法每次需要扫描目录
;; ;;启动速度会很慢wiki 上提供的两个function
;; ;;file-cache-save-cache-to-file
;; ;;file-cache-read-cache-from-file
;; ;;可以将扫描的结果记入一个cache文件,以后启动时只需加载这个文件,不必每次都扫描
;; ;;以后要添加新目录的时候只需要用官方的方法add 后,然后
;; ;;file-cache-save-cache-to-file 一下就可以了
;; ;; (defun file-cache-save-cache-to-file (file)
;; ;;   "Save contents of `file-cache-alist' to FILE.
;; ;; For later retrieval using `file-cache-read-cache-from-file'"
;; ;;   (interactive "FFile: ")
;; ;;   (with-temp-file (expand-file-name file)
;; ;;     (prin1 file-cache-alist (current-buffer))))

;; ;; (defun file-cache-read-cache-from-file (file)
;; ;;   "Clear `file-cache-alist' and read cache from FILE.
;; ;;   The file cache can be saved to a file using
;; ;;   `file-cache-save-cache-to-file'."
;; ;;   (interactive "fFile: ")
;; ;;   (file-cache-clear-cache)
;; ;;   (save-excursion
;; ;;     (with-current-buffer (find-file-noselect file)
;; ;;       (goto-char (point-min))
;; ;;       (setq file-cache-alist (read (current-buffer)))
;; ;;       (kill-buffer))))


;; ;;; kill-emacs-hook,关闭emacs 时将变化后的file-name-cache写入到缓存文件中
;; ;; (defvar file-name-cache-file-name
;; ;;   (concat joseph_root_install_path "cache/file-name-cache"))
;; ;; (defun file-cache-save-cache-to-default-file()
;; ;;   "在保存在cache文件前,做一遍检查,排除掉不存在的文件."
;; ;;   (dolist (file-dir-cons file-cache-alist)
;; ;;     (unless (file-exists-p  (expand-file-name (car file-dir-cons) (nth 1 file-dir-cons)))
;; ;;       (setq file-cache-alist (delete file-dir-cons file-cache-alist))
;; ;;       ))
;; ;;   (file-cache-save-cache-to-file file-name-cache-file-name))
;; ;; (add-hook 'kill-emacs-hook 'file-cache-save-cache-to-default-file)






;; ;; (progn
;; ;;   (message "Loading file cache...")
;; ;;   (if (file-exists-p file-name-cache-file-name)
;; ;;       ;; 如果cache文件存在直接读取里面的内容,
;; ;;       (file-cache-read-cache-from-file file-name-cache-file-name)
;; ;;     ;;如果cache文件不存在则用官方提供的几人函数添加到file-cache-alist中,然后
;; ;;     ;;save 到cache文件中,需要注意如果有新路径加入,需要手动
;; ;;     ;;(file-cache-save-cache-to-file file-name-cache-file-name)
;; ;;     (progn
;; ;;       ;;   (file-cache-add-directory-using-find "~/project")
;; ;;       ;;   (file-cache-add-directory-recursively "/")
;; ;;       ;;   (file-cache-add-directory-list load-path)
;; ;;       ;;   (file-cache-add-directory "/java/java/Emacs/wiki/elisp/")
;; ;;       (file-cache-add-directory-using-find joseph_site-lisp_install_path)
;; ;;            (when (equal system-type 'gnu/linux)
;; ;;              (file-cache-add-directory-using-find "/etc")
;; ;;              (file-cache-add-directory "~/"))
;; ;;            ;;  (file-cache-add-file-list (list "~/foo/bar" "~/baz/bar"))
;; ;;            (file-cache-save-cache-to-default-file)))
;; ;;   (message "finished loading file cache")
;; ;;   )

(provide 'joseph-file-name-cache)
