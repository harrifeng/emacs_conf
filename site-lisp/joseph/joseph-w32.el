;; -*- coding:utf-8 -*-
(eval-when-compile
  (require 'joseph_byte_compile_include)
  (require 'joseph-file-util)
  (require 'ls-lisp)
  )

(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'hyper)
(global-set-key (kbd "H-<Esc>") 'save-buffers-kill-emacs)
(global-set-key (quote [M-f4]) (quote save-buffers-kill-emacs))

(setenv "HOME" "d:/")
;;在windows 上设置打开文件时默认的目录为d:/,而非 几乎永远不会在这里放文件的C:\Documents and Settings\Administrator
(setq default-directory "d:/")
(setq visible-bell t)

;;now use bash as my shell ,
;; you can call (set-shell-cmdproxy )here to use cmdproxy as the shell.
;; (set-shell-bash)

;; ;;(setq exec-path (cons "C:/cygwin/bin" exec-path))
;; ;;(setq shell-file-name "C:/cygwin/bin/bash.exe") ; Subprocesses invoked via the shell.
;; ;;(setenv "SHELL" shell-file-name)
;; ;;(setenv "PATH" (concat (getenv "PATH") ";C:\\cygwin\\bin"))
;; ;;(setq explicit-shell-file-name shell-file-name) ; Interactive shell


;;; ;;dired 使用外部的ls 程序
(when (string-match "/msys\\b" (getenv "PATH"))
  (setq ls-lisp-use-insert-directory-program t)      ;; use external ls
  )
(setq insert-directory-program "ls") ;; ls program name

;;;dired 下,"Z" 无法使用gunzip 解压文件,原因是gunzip 是一个指向gzip的软链接,
(defadvice dired-check-process (around gunzip-msys-symlink activate)
  "on msys ,the gunzip is a symlink to gzip ,and dired can't
        fine gunzip.exe to uncompress,this advice ,replace gunzip
        with gzip -d"
  (when (string-equal program "gunzip")
    (setq program "gzip")
    (add-to-list 'arguments "-d"))
  ad-do-it
  )
;; (eval-after-load 'dired-aux
;;   '(progn
;;      ))


;; (global-set-key (kbd "C-x C-b") 'joseph-hide-frame)
;; (global-set-key (kbd "C-x C-z") 'joseph-hide-frame)
;; (create-fontset-from-fontset-spec
;;  (concat   "-outline-Courier New-normal-normal-normal-mono-15-*-*-*-c-*-fontset-gbk,"
;;            "chinese-gb2312:-outline-新宋体-normal-normal-normal-mono-15-*-*-*-c-*-gb2312.1980-0") t)

;; (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; ;; The next line is only needed for the MS-Windows clipboard
;; (set-clipboard-coding-system 'utf-16le-dos)
;; (set-frame-font "-outline-SimSun-normal-normal-normal-*-16-*-*-*-p-*-iso8859-1")
(setq exec-path (delete-dups  (cons (expand-file-name "~/.emacs.d/bin/sdcv/") exec-path)))
(setenv "PATH" (concat (get-system-file-path (expand-file-name  "~/.emacs.d/bin/sdcv/")) ";" (getenv "PATH") ))


(setq exec-path (delete-dups  (cons (expand-file-name "~/.emacs.d/bin/") exec-path)))
(setenv "PATH" (concat (get-system-file-path (expand-file-name  "~/.emacs.d/bin/")) ";" (getenv "PATH") ))

(setenv "PATH" (concat (get-system-file-path (expand-file-name "~/.emacs.d/bin/gnutls-2.10.1/bin")) ";" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.emacs.d/bin/gnutls-2.10.1/bin"))
(setenv "PATH" (concat (get-system-file-path (expand-file-name "~/.emacs.d/bin/socat-2.0.0-b3.1/")) ";" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.emacs.d/bin/socat-2.0.0-b3.1/"))
(setenv "PATH" (concat (get-system-file-path (expand-file-name "~/.emacs.d/bin/w3m/")) ";" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.emacs.d/bin/w3m/"))

;; mew 用到
(setenv "PATH" (concat (get-system-file-path (expand-file-name "~/.emacs.d/bin/stunnel")) ";" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.emacs.d/bin/stunnel"))
;; (setenv "PATH" (concat (get-system-file-path (expand-file-name "~/.emacs.d/bin/mew-6.4/bin")) ";" (getenv "PATH")))
;; (add-to-list 'exec-path (expand-file-name "~/.emacs.d/bin/mew-6.4/bin"))


(require 'server)
;;进行server认证的目录,
(setq server-auth-dir (expand-file-name "~/.emacs.d/cache/"))
(setq server-name "emacs-server-file")
;;上面两个值连起来即为emacsclient --server-file后面跟的参数
;;为方便计只需要设置EMACS_SERVER_FILE,值为emacs-server-file的绝对路径名称
;;如我的"d:\.emacs.d\cache\emacs-server-file"
;;注意在windows 上我把环境变量HOME设成了D:\,所以"~"就代表"D:\"了.
(when (not (server-running-p))
  (server-force-delete)
  (server-start))

;; ssh://user@server:path/to/file
;; /host:/filename
;; http://blog.donews.com/pluskid/archive/2006/05/06/858306.aspx
;; (require 'tramp)
(eval-after-load 'tramp
  '(progn
     (setq tramp-default-method "plink")
     ;; (add-to-list 'tramp-default-method-alist '("localhost" "root" "su"))
     (setq tramp-default-user "root")
     ;; 你也可以对于不同的 方法/主机 组合使用不同的用户名。例如，如果你总是想在域 10.10.10.211 上使用用户名 root ，你可以用如下方法指定：
     (add-to-list 'tramp-default-user-alist '("plink" "10.10.10.211" "root"))
     (add-to-list 'tramp-default-user-alist '("ssh" "jf.org" "jixiuf"))
     (setq tramp-default-host "10.10.10.211") ;那么 /ssh:: 将连接到 10.10.10.211 上
     (setq password-cache-expiry nil)         ;密码缓存永不过期
     ))

;;这台机器用是日文系统 ,所以一些配置,采用日文编码
;; (when (equal system-name "SB_QINGDAO")
;;   (setq buffer-file-coding-system 'utf-8) ;;写文件时使用什么编码
;;                                         ;  (setq file-name-coding-system 'shift_jis-dos) ;;文件名所用的编码,不过这样,中文文件名就有问题了
;;   (setq file-name-coding-system 'undecided-unix)
;;   (prefer-coding-system 'utf-8)
;;   )
(prefer-coding-system 'cp936) ;;默认使用cp936
(setq process-coding-system-alist (cons '("git" . (utf-8 . utf-8)) process-coding-system-alist));;对git 的输入输入的编辑使用utf-8
;; (setq process-coding-system-alist (cons '("grep" . (cp936 . cp936)) process-coding-system-alist));;对git 的输入输入的编辑使用utf-8
(setq process-coding-system-alist (cons '("bash" . (utf-8 . utf-8)) process-coding-system-alist));对bash 的输入输入的编辑使用cp936
(setq process-coding-system-alist (cons '("diff" . (cp936 . cp936)) process-coding-system-alist));对bash 的输入输入的编辑使用cp936
(set-file-name-coding-system 'cp936) ;;文件名的编辑 dired 中会用到
(setq-default buffer-file-coding-system 'utf-8) ;;buffer写文件时使用什么编码
;; 以下两个测试中。
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; (setq buffer-file-coding-system 'utf-8) ;;写文件时使用什么编码

;; ;;中文系统采用的编码
;; (unless (equal system-name "SB_QINGDAO")
;; ;;  (setq buffer-file-coding-system 'utf-8) ;;写文件时使用什么编码
;; ;;  (setq file-name-coding-system 'shift_jis-dos);;文件名所用的编码,不过这样,中文文件名就有问题了
;;   )
;; (prefer-coding-system (quote utf-8-auto-dos))
;; (set-file-name-coding-system 'shift_jis-dos)

;; (setq current-language-environment "UTF-8")
;; (setq locale-coding-system 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; (set-selection-coding-system 'utf-8)
;; (set-clipboard-coding-system 'utf-8)
;; (set-buffer-file-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (modify-coding-system-alist 'process "*" 'utf-8)
;; (setq default-process-coding-system '(utf-8 . utf-8))
;; (setq-default pathname-coding-system 'utf-8)
;; (prefer-coding-system 'gbk)
;; (prefer-coding-system (quote gbk-dos))
;; (prefer-coding-system 'utf-8)


(provide 'joseph-w32)
