;;; joseph-erlang.el --- erlang mode config   -*- coding:utf-8 -*-

;; Description: erlang mode config
;; Created: 2011-11-07 10:35
;; Last Updated: 纪秀峰 2013-12-11 13:47:46 
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords: erlang
;; URL: http://www.emacswiki.org/emacs/joseph-erlang.el

;; Copyright (C) 2011, 纪秀峰, all rights reserved.

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
;;  `distel-load-shell'
;;    Load/reload the erlang shell connection to a distel node
;;  `my-erlang-insert-edoc'
;;    Insert edoc.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:

;; 在gentoo 操作系统上erlang 的doc 目录在   /usr/share/doc/erlang-15.2/html/doc/
;; 需要做了软链接 /usr/lib/erlang/doc -->  /usr/share/doc/erlang-15.2/html/doc/
;; add Erlang functions to an imenu menu
;; (imenu-add-to-menubar "Imenu"); 在菜单栏上添加 Imenu ,我不用它，用helm-imenu 代替。 C-wi
;; M-h mark子句, C-M-h mark-function
;; C-cC-q indent-function .不过可用C-M-h 与C-M-\ 结合来完成相同的操作
;; (erlang-generate-new-clause) C-cC-j  生成一个clause 类似于输入分号 ;
;; (erlang-clone-arguments)C-cC-y clone 前一个子句的参数到当前子句,此时光标要位于当前子句的参数位置
;; M-q 可用于格式化注释
;; C-cC-k erlang-compile ,C-zs compile-dwim 我做了集成。
;; C-cC-l compile有错，时，显示错误
;; C-cC-z switch to erlang-shell buffer
;;;; (erlang-align-arrows ) C-cC-a
;; sum(L) -> sum(L, 0).
;; sum([H|T], Sum) -> sum(T, Sum + H);
;; sum([], Sum) -> Sum.

;; becomes:

;; sum(L)          -> sum(L, 0).
;; sum([H|T], Sum) -> sum(T, Sum + H);
;; sum([], Sum)    -> Sum.
;;;; other

;; (defun flymake-erlang-init ()
;;   "need ~/.emacs.d/bin/eflymake.c ~/.emacs.d/bin/eflymake.exe ~/.emacs.d/bin/eflymake.erl."
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "eflymake" (list (expand-file-name "~/.emacs.d/bin/eflymake.erl") local-file))))
;; (add-to-list 'flymake-allowed-file-name-masks '("\\.erl\\'" flymake-erlang-init))

;; (defun read-home-erlang-cookie()
;;   "read cookie from `~/.erlang.cookie' if not set a default cookie for it."
;;   (let ((cookie-file (expand-file-name "~/.erlang.cookie"))
;;         cookie)
;;     (when (equal system-type 'windows-nt)
;;       (setq cookie-file (expand-file-name  ".erlang.cookie" (concat (getenv "HOMEDRIVE") (getenv "HOMEPATH")))))
;;     (unless (file-exists-p cookie-file)
;;       (with-current-buffer (find-file-noselect cookie-file)
;;         (insert "mycookie")(save-buffer) (kill-buffer)))
;;     (setq cookie  (read-file-as-var cookie-file))
;;     ))

;; (eval-after-load 'derl '(progn (fset 'erl-cookie 'read-home-erlang-cookie)))
(eval-when-compile
    (require 'compile)
    (require 'erlang)
    (require 'distel))

(eval-after-load 'erlang
  '(progn

     ;; (setq inferior-erlang-machine-options `("-name" ,(concat "emacs@" system-name "") "-setcookie" ,(read-home-erlang-cookie) "+P" "102400")       )
     (setq inferior-erlang-machine-options `("-name" ,(concat "emacs@" system-name "")  "+P" "102400")       )
     ;; erl -name emacs
     ;; (setq inferior-erlang-machine-options '("-sname" "emacs@localhost")) ;; erl -name emacs
     (setq erlang-compile-extra-opts '(debug_info))
     (setq erlang-root-dir "/usr/lib/erlang/")
     (when (equal system-type 'darwin)
       (setq erlang-root-dir "/usr/local/Cellar/erlang/R15B03-1/"))
     (when (equal system-type 'windows-nt)
       (setq erlang-root-dir "d:/usr/erl5.8.5/")
       (setq exec-path (cons "d:/usr/erl5.8.5/bin" exec-path))

       ;; (setq inferior-erlang-machine-options '("-sname" "emacs@localhost")) ;; erl -sname emacs  ; -sname means short name
       (setenv "PATH" (concat (getenv "PATH") ";" (get-system-file-path  "d:/usr/erl5.8.5/bin")))
       )
     (require 'erlang-flymake) ;erlang 自带的flymake .

     (defun erlang-flymake-get-app-dir() ;重新定义erlang-flymake中的此函数,find out app-root dir
       ;; 有时,代码会放在 src/deep/dir/of/source/这样比较深的目录,erlang-flymake自带的此函数
       ;; 无法处理这种情况
       (let ((erlang-root (locate-dominating-file default-directory "Emakefile")))
         (if erlang-root
             (expand-file-name erlang-root)
           (setq erlang-root (locate-dominating-file default-directory "rebar"))
           (if erlang-root
               (expand-file-name erlang-root)
             (file-name-directory (directory-file-name
                                   (file-name-directory (buffer-file-name)))))
           )))
     (defun my-erlang-flymake-get-include-dirs-function()
       (let* ((app-root (erlang-flymake-get-app-dir))
              (dir (list (concat app-root "include") ;不支持通配符,
                         (concat  app-root "src/include")
                         (concat  app-root "deps")))
              (deps (concat  app-root "deps")))
         (when (file-directory-p deps)
           (dolist (subdir (directory-files deps))
                   (when (and (file-directory-p (expand-file-name subdir deps))
                              (not (string= "." subdir))
                              (not (string= ".." subdir)))
                     (add-to-list 'dir (expand-file-name (concat subdir "/include" ) deps))
                     )))
         dir))
     (setq erlang-flymake-get-include-dirs-function 'my-erlang-flymake-get-include-dirs-function)
     (require 'distel)
     (distel-setup)

;;;; erlang-dired-mode
     (require 'erlang-dired-mode)
     (eval-after-load 'erlang-dired-mode
       '(progn
          ;; (define-key erlang-dired-mode-map (kbd "C-z s") 'erlang-compile-dwim) ;compile
          ;; (define-key erlang-dired-mode-map (kbd "C-z C-s") 'erlang-compile-dwim) ;compile
          )
       )
     ))

(defun my-erlang-mode-hook ()
  (set (make-local-variable 'compilation-auto-jump-to-first-error) nil) ;编译完成后不自动跳到第一个error处
  (local-set-key [remap mark-paragraph] 'erlang-mark-clause) ;M-h mark子句 C-M-h mark-function
  (local-set-key [remap forward-sentence] 'erlang-end-of-clause) ;M-e 子句尾 (C-M-e function尾)
  (local-set-key [remap backward-sentence] 'erlang-beginning-of-clause) ;子句首M-a , (C-M-a function首)
  (local-set-key  [(control return)]  'erl-complete) ;;tab ,补全时，需要先启动一个node C-cC-z 可做到。然后连接到此节点。即可进行补全。
  (define-key erlang-mode-map (kbd "C-c C-e") 'erlang-export-current-function) ;C-cC-e
  (define-key erlang-mode-map (kbd "C-c e") 'my-erlang-insert-edoc)
  (define-key erlang-mode-map (kbd "C-c C-p") 'erlang-create-project) ;defined in erlang-dired-mode C-cC-p
  ;; (define-key erlang-mode-map (kbd "C-z s") 'erlang-compile-dwim) ;compile
  ;; (define-key erlang-mode-map (kbd "C-z C-s") 'erlang-compile-dwim) ;compile
  (local-set-key "\M-."  'erl-find-source-under-point )
  (local-set-key "\M-,"  'erl-find-source-unwind)
  (local-set-key "\M-*"  'erl-find-source-unwind )
  (local-set-key (kbd "M-C-/") 'insert-sth ) ;insert "->"
  ;; (when (not buffer-read-only)(flymake-mode 1))
  (eval-after-load 'auto-complete '(setq ac-sources (append '(ac-source-yasnippet) ac-sources)))
  )

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
(add-hook 'erlang-shell-mode-hook 'my-erlang-mode-hook)

(defun my-erlang-shell-mode-hook ()
  (local-set-key "\C-g"  'keyboard-quit-or-bury-buffer-and-window)
  (local-set-key (kbd"C-c C-z")  'bury-buffer-and-window)
  (define-key erlang-shell-mode-map (kbd "C-c C-k") 'erlang-compile-dwim)
  )
(add-hook 'erlang-shell-mode-hook 'my-erlang-shell-mode-hook)


(require 'erlang-start)

(defun insert-sth()
  (interactive)
  (insert "->")
  )

;;;; 当打开erl  文件时，自动启动一个shell 以便distel进行补全
(add-hook 'erlang-mode-hook '(lambda () (unless erl-nodename-cache (distel-load-shell))))
(defun distel-load-shell ()
  "Load/reload the erlang shell connection to a distel node"
  (interactive)
  ;; Set default distel node name
  (setq erl-nodename-cache (intern (concat "emacs@" system-name "")))
  ;; (setq derl-cookie (read-home-erlang-cookie)) ;;new added can work
  (setq distel-modeline-node "distel")
  (force-mode-line-update)
  ;; Start up an inferior erlang with node name `distel'
  (let ((file-buffer (current-buffer))
        (file-window (selected-window)))
    ;; (setq inferior-erlang-machine-options '("-sname" "emacs@localhost" "-setcookie" "cookie_for_distel"))
    (setq inferior-erlang-machine-options `("-name" ,(concat "emacs@" system-name "") )) ;; erl -name emacs
    (switch-to-buffer-other-window file-buffer)
    (inferior-erlang)
    (select-window file-window)
    (switch-to-buffer file-buffer)))
;;
;; http://www.erlang.org/doc/apps/edoc/chapter.html
;; 单个文件 生成文档
;; edoc:files([a.erl]).
;; edoc:application(Application::atom(), Options::proplist())

;; 限制:-spec ()里的写法只能是 integer() 不能是A::integer() .
;; 根据-spec语法 ，自动生成 相应的doc文档,比如根据

;; %%--------------------------------------------------------------------
;; %% @doc
;; %% Your description goes here
;; %% @spec foo(_Integer::integer(), _String::string()) ->
;; %%%      boolean()
;; %% @end
;; %%--------------------------------------------------------------------
;; -spec foo(integer(), string()) ->
;;       boolean().
;; foo(_Integer, _String) ->
;;       true.
;; 目前未绑定,留为后用
;;;###autoload
(defun my-erlang-insert-edoc ()
  "Insert edoc."
  (interactive)
  (save-excursion
    (when (re-search-forward "^\\s *-spec\\s +\\([a-zA-Z0-9_]+\\)\\s *(\\(\\(.\\|\n\\)*?\\))\\s *->[ \t\n]*\\(.+?\\)\\." nil t)
      (let* ((beg (match-beginning 0))
             (funcname (match-string-no-properties 1))
             (arg-string (match-string-no-properties 2))
             (retval (match-string-no-properties 4))
             (args (split-string arg-string "[ \t\n,]" t)))
        (when (re-search-forward (concat "^\\s *" funcname "\\s *(\\(\\(.\\|\n\\)*?\\))\\s *->") nil t)
          (let ((arg-types (split-string (match-string-no-properties 1) "[ \t\n,]" t)))
            (goto-char beg)
            (insert "%%-----------------------------------------------------------------------------\n")
            (insert "%% @doc\n")
            (insert "%% Your description goes here\n")
            (insert "%% @spec " funcname "(")
            (dolist (arg args)
              (if (string-match "::" arg) (insert arg) (insert (car arg-types) "::" arg))
              (setq arg-types (cdr arg-types))
              (when arg-types
                (insert ", ")))
            (insert ") ->\n")
            (insert "%%       " retval "\n")
            (insert "%% @end\n")
            (insert "%%-----------------------------------------------------------------------------\n")))))))

(provide 'joseph-erlang)
;;; joseph-erlang.el ends here
