;;; -*- coding:utf-8-unix -*-
(defvar  dropbox-dir (expand-file-name "~/Documents/dropbox"))
(when (equal system-type 'darwin)
  (when (or (not (file-exists-p dropbox-dir))
            (not (file-symlink-p dropbox-dir)))
    (start-process "lndropbox" "*Messages*" "ln"  "-f" "-s" (expand-file-name "~/Library/Mobile Documents/com~apple~CloudDocs/") dropbox-dir)))

(when (not (file-exists-p dropbox-dir)) (make-directory dropbox-dir t))

(setq-default
 user-full-name "纪秀峰"                ;记得改成你的名字
 user-login-name "jixiufeng"
 user-mail-address "jixiuf@gmail.com")

(setq-default
 ;; inhibit-startup-screen t;隐藏启动显示画面
 initial-scratch-message nil;关闭scratch消息提示
 initial-major-mode 'fundamental-mode ;scratch init mode
 use-dialog-box nil		      ;不使用对话框进行（是，否 取消） 的选择，而是用minibuffer
 frame-title-format "%b  [%I] %f  GNU/Emacs" ;标题显示文件名，而不是默认的username@localhost

 calendar-date-style 'iso
 calendar-day-abbrev-array ["七" "一" "二" "三" "四" "五" "六"]
 calendar-day-name-array ["七" "一" "二" "三" "四" "五" "六"]
 calendar-month-name-array ["一月" "二月" "三月" "四月" "五月" "六月" "七月" "八月" "九月" "十月" "十一月" "十二月"]
 calendar-week-start-day 1

 org-agenda-deadline-leaders (quote ("最后期限:  " "%3d 天后到期: " "%2d 天前: "))
 ;; (setq-default org-agenda-format-date (quote my-org-agenda-format-date-aligned))
 org-agenda-inhibit-startup t
 org-agenda-scheduled-leaders (quote ("计划任务:" "计划任务(第%2d次激活): "))
 org-agenda-window-setup (quote current-window)
 org-clock-string "计时:"
 org-closed-string "已关闭:"
 org-deadline-string "最后期限:"
 org-scheduled-string "计划任务:"
 org-time-stamp-formats  '("<%Y-%m-%d 周%u>" . "<%Y-%m-%d 周%u %H:%M>")
 org-agenda-files  (list (expand-file-name "todo.txt" dropbox-dir))
 org-deadline-warning-days 5;;最后期限到达前5天即给出警告
 org-agenda-show-all-dates t
 org-agenda-skip-deadline-if-done t
 org-agenda-skip-scheduled-if-done t
 org-reverse-note-order t ;;org.el
 org-log-done 'time
 ;; code执行免应答（Eval code without confirm）
 org-confirm-babel-evaluate nil
 org-default-notes-file (expand-file-name "notes.txt" dropbox-dir)
 org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)")
                     (sequence "Info(i)")
                     (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
                     (sequence "|" "CANCELED(c)"))
 org-capture-templates `(("t" "Todo" entry (file+headline ,(expand-file-name "todo.txt" dropbox-dir) "Tasks")
                          "* TODO %? 创建于:%T\n  %i\n")
                         ("i" "Info" entry (file+headline ,(expand-file-name "todo.txt" dropbox-dir) "Info")
                          "* Info %? 创建于:%T\n  %i\n")
                         ("n" "Note" item (file ,org-default-notes-file)
                          " %? "))
 org-agenda-custom-commands '(("n"  "[Note] Go to  Target(Note )" ( (find-file org-default-notes-file)))
                              ;; ("b" . "show item of tags prefix") ; describe prefix "h"
                              ;; ("be" tags "+Emacs")
                              ;; ("bj" tags "+Java")
                              ;; ("ba" tags "+AutoHotKey")
                              ;; ("bl" tags "+Linux")
                              ;; ("bd" tags "+Daily")
                              ;; ("bw" tags "+Windows")
                              ("i" todo "Info" nil)
                              ("c" todo "DONE|DEFERRED|CANCELLED" nil)
                              ("W" todo "WAITING" nil)
                              ("w" agenda "" ((org-agenda-start-on-weekday 1) ;start form Monday
                                              (org-agenda-ndays 14)))
                              ("A" agenda ""
                               ((org-agenda-skip-function
                                 (lambda nil
                                   (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]")))
                                (org-agenda-ndays 1)
                                (org-agenda-overriding-header "Today's Priority #A tasks: ")))
                              ("u" alltodo ""
                               ((org-agenda-skip-function
                                 (lambda nil
                                   (org-agenda-skip-entry-if (quote scheduled) (quote deadline)
                                                             (quote regexp) "\n]+>")))
                                (org-agenda-overriding-header "Unscheduled TODO entries: ")))
                              )


 ;;  mode-line 上显示当前文件是什么系统的文件(windows 的换行符是\n\r)
 eol-mnemonic-dos "\\nr"
 eol-mnemonic-unix "\\n"
 eol-mnemonic-mac "\\r"
 eol-mnemonic-undecided "[?]"
 indent-tabs-mode nil                   ;用空格代替tab
 tab-width 4
 indicate-empty-lines t
 ;; x-stretch-cursor nil                  ;如果设置为t，光标在TAB字符上会显示为一个大方块
                                        ;(setq track-eol t) ;; 当光标在行尾上下移动的时候，始终保持在行尾。
 ;; (setq-default cursor-type 'bar);;光标显示为一竖线

 ;;中键点击时的功能
 ;;不要在鼠标中键点击的那个地方插入剪贴板内容。
 ;;而是光标在什么地方,就在哪插入(这个时候光标点击的地方不一定是光标的所在位置)

 mouse-yank-at-point t
 kill-whole-line t                     ;在行首 C-k 时，同时删除末尾换行符
 kill-read-only-ok t                  ;kill read-only buffer内容时,copy之而不用警告
 kill-do-not-save-duplicates t       ;不向kill-ring中加入重复内容
 save-interprogram-paste-before-kill t
 sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
 sentence-end-double-space nil         ;;设置 sentence-end 可以识别中文标点。不用在 fill 时在句号后插入两个空格。


 ;;(require 'tramp)
 tramp-persistency-file-name  (expand-file-name "cache/tramp" user-emacs-directory)
 tramp-adb-prompt "^\\(?:[[:digit:]]*|?\\)?\\(?:[[:alnum:]-]*@[[:alnum:]]*[^#\\$]*\\)?[#\\$][[:space:]]" ;加了一个  "-"
 remote-file-name-inhibit-cache 60 ;60s default 10s
 backup-by-copying t    ;自动备份
 delete-old-versions t ; 自动删除旧的备份文件
 kept-new-versions 10   ; 保留最近的6个备份文件
 kept-old-versions 2   ; 保留最早的2个备份文件
 version-control t    ; 多次备份
 backup-directory-alist `((".*" . ,(expand-file-name "cache/backup_files/" user-emacs-directory)))
 auto-save-file-name-transforms `((".*" ,(expand-file-name "cache/backup_files/" user-emacs-directory) t))
 auto-save-list-file-prefix   (expand-file-name "cache/backup_files/saves-" user-emacs-directory)
 pulse-iterations 3


 ;;打开只读文件时,默认也进入view-mode.
 ;; (setq-default view-read-only t)
 large-file-warning-threshold nil       ;打开大文件时不必警告
 mode-require-final-newline nil

 ;;用 (require 'ethan-wspace)所以，取消require-final-newline的 customize
 ;; (setq-default require-final-newline t);; 文档末尾插入空行
 ;; (setq find-file-visit-truename t)
 ;; (setq-default require-final-newline nil)

 send-mail-function 'sendmail-send-it
 mail-addrbook-file (expand-file-name "mail_address" dropbox-dir)

 ;; after this shell-command can use zsh alias
 shell-file-name "zsh"
 shell-command-switch "-ic"

 ;;注意这两个变量是与recentf相关的,把它放在这里,是因为
 ;;觉得recentf与filecache作用有相通之处,
 recentf-save-file (expand-file-name "recentf" user-emacs-directory)
 ;;匹配这些表达示的文件，不会被加入到最近打开的文件中
 recentf-exclude  `("\\.elc$" ,(regexp-quote (expand-file-name "cache/" user-emacs-directory))   "/TAGS$" "java_base.tag" ".erlang.cookie" "xhtml-loader.rnc" "COMMIT_EDITMSG")
 recentf-max-saved-items 200
 ring-bell-function 'ignore
 kill-ring-max 60

 initial-buffer-choice t
 ;; initial-buffer-choice 'show-todo-list-after-init
 savehist-additional-variables '(helm-dired-history-variable magit-repository-directories mew-passwd-alist kill-ring sqlserver-connection-info mysql-connection-4-complete sql-server sql-database sql-user)
 savehist-file (expand-file-name "cache/history" user-emacs-directory)
 ;;when meet long line ,whether to wrap it
 truncate-lines t
 save-place t
 )

(setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
                              "xelatex -interaction nonstopmode %f"))
;; (with-eval-after-load 'org
;;   ;; #+LATEX_HEADER: \usepackage{fontspec}
;;   ;; #+LATEX_HEADER: \setmainfont{Songti SC}
;;   ;; (add-to-list 'org-latex-default-packages-alist '(""     "fontspec" nil))
;;   ;; (setq org-format-latex-header (concat org-format-latex-header "\n\\setmainfont{Songti SC}"))

;;   )

(savehist-mode 1)

;; (defun pretty-chinese-char()
;;   (push '("“" . "「") prettify-symbols-alist)
;;   (push '("”" . "」") prettify-symbols-alist)
;;   (prettify-symbols-mode 1)
;;   )
;; ;; (add-hook 'org-mode-hook 'pretty-chinese-char)
;; (add-hook 'text-mode-hook 'pretty-chinese-char)

;; org mode 段落开头加4个空格
;; (defadvice org-fill-paragraph(around novel-first-line-4-space activate)
;;   (let ((element (save-excursion
;;                    (end-of-line)
;;                    (or (ignore-errors (org-element-at-point))
;;                        (user-error "An element cannot be parsed line %d"
;;                                    (line-number-at-pos (point)))))))
;; 	;; First check if point is in a blank line at the beginning of
;; 	;; the buffer.  In that case, ignore filling.
;; 	(case (org-element-type element)
;; 	  ;; Use major mode filling function is src blocks.
;; 	  (paragraph
;; 	   ;; Paragraphs may contain `line-break' type objects.
;;        (save-excursion
;;          (back-to-indentation)
;;          (mark-paragraph)
;;          (goto-char (region-beginning))
;;          (deactivate-mark)
;;          (delete-horizontal-space)
;;          (call-interactively 'org-cycle)
;;          (skip-chars-forward "[ \t]*")
;;          ))
;; 	  ))
;;   ad-do-it)

;; (setq-default fill-paragraph-function 'fill-paragraph-function-org-mode-hook)


;;;###autoload
(define-derived-mode novel-mode org-mode "Novel"
  "novel mode")

(defun txt-mode-hook()
  (modify-syntax-entry ?， "." ) ;; 识别中文标点
  (modify-syntax-entry ?。 "." ) ;; 识别中文标点
  (modify-syntax-entry ?！ "." ) ;; 识别中文标点
  (modify-syntax-entry ?？ "." ) ;; 识别中文标点
  (modify-syntax-entry ?、 "." ) ;; 识别中文标点
  (modify-syntax-entry ?； "." ) ;; 识别中文标点
  (iimage-mode 1)
  ;; (auto-fill-mode 1)
  ;; (paragraph-indent-minor-mode 1)
  ;; (org-set-local 'fill-paragraph-function 'fill-paragraph-function-org-mode-hook)

  )
(add-hook 'text-mode-hook 'txt-mode-hook)
(add-hook 'org-mode-hook 'txt-mode-hook)
(add-hook 'novel-mode-hook 'txt-mode-hook)


(defun show-todo-list-after-init(&optional frame)
  (require 'org-agenda)
  (dolist (f org-agenda-files)
    (unless (file-exists-p f)
      (setq org-agenda-files (delete f org-agenda-files))))
  ;; (require 'joseph-org)
  ;; (require 'joseph-org-config)
  (when org-agenda-files
    (call-interactively 'org-todo-list)
    (switch-to-buffer "*Org Agenda*")))

(run-with-idle-timer 300 t 'show-todo-list-after-init) ;idle 300=5*60s,show todo list

;; (unless (daemonp)
;;   (add-hook 'after-init-hook 'show-todo-list-after-init t))


(fset 'yes-or-no-p 'y-or-n-p) ;; 把Yes用y代替
;(setq next-line-add-newlines t);到达最后一行后继续C-n将添加空行
;;(setq-default line-spacing 1);;设置行距

(autoload 'thrift-mode "thrift-mode" "Major mode for editing thrift code." t)

(defconst my-protobuf-style
  '((c-basic-offset . 4)
    (indent-tabs-mode . nil)))

(add-hook 'objc-mode-hook 'objc-mode-callback)


(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)
            (local-set-key (kbd "C-M-h") 'mark-defun)
            (local-set-key (kbd "M-h") 'mark-paragraph)
            (setq indent-region-function 'protobuf-indent-align)))


;;; 关于没有选中区域,则默认为选中整行的advice
;;;;默认情况下M-w复制一个区域，但是如果没有区域被选中，则复制当前行
(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (message "已选中当前行!")
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;;(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'erase-buffer 'disabled nil)

;; 因为经常按出c-x c-u，总是出upcase region的警告，
;; (put 'upcase-region 'disabled nil)
;; (put 'downcase-region 'disabled nil)
;; (add-to-list 'byte-compile-not-obsolete-vars 'font-lock-beginning-of-syntax-function)
;; (add-to-list 'byte-compile-not-obsolete-vars 'font-lock-syntactic-keywords)
(with-eval-after-load 'org (define-key org-mode-map (kbd "C-c e") 'org-edit-special))
(with-eval-after-load 'org-src
  (define-key org-src-mode-map "\C-c\C-c" 'org-edit-src-exit)
  (define-key org-src-mode-map "\C-x\C-s" 'org-edit-src-exit))



;; after-init-hook 所有配置文件都加载完之后才会运行此hook
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(setq-default auto-mode-alist
      (append
       '(("\\.pyx" . python-mode)
         ("SConstruct" . python-mode)
         ("\\.yml$" . yaml-mode)
         ("\\.yaml$" . yaml-mode)
         ("\\.lua$" . lua-mode)
         ("\\.scpt\\'" . applescript-mode)
         ("\\.applescript$" . applescript-mode)
         ("/\\.?gitconfig\\'" . gitconfig-mode)
         ("/\\.git/config\\'" . gitconfig-mode)
         ("crontab\\'" . crontab-mode)
         ("\\.cron\\(tab\\)?\\'" . crontab-mode)
         ("cron\\(tab\\)?\\."    . crontab-mode)
         ("\\.mxml" . nxml-mode)
         ("\\.as" . actionscript-mode)
         ("\\.proto\\'" . protobuf-mode)
         ("\\.thrift" . thrift-mode)
         ("\\.md" . markdown-mode)
         ("\\.\\(frm\\|bas\\|cls\\|vba\\|vbs\\)$" . visual-basic-mode)

         ("\\.yaws$" . nxml-mode)
         ("\\.html$"  . web-mode)
         ("\\.htm$"   . web-mode)
         ("\\.phtml$" . web-mode)
         ("\\.php3$"  . web-mode)
         ("\\.jsp$" . web-mode)

         ("\\.hrl$" . erlang-mode)
         ("\\.erl$" . erlang-mode)
         ("\\.rel$" . erlang-mode)
         ("\\.app$" . erlang-mode)
         ("\\.app.src$" . erlang-mode)
         ("\\.ahk$\\|\\.AHK$" . xahk-mode)
         ("\\.bat$"   . batch-mode)
         ("\\.cmd$"   . batch-mode)
         ("\\.pl$"   . cperl-mode)
         ("\\.pm$"   . cperl-mode)
         ("\\.perl$" . cperl-mode)
         ("\\.sqlo$"  . oracle-mode)
         ("\\.sqlm$"  . mysql-mode)
         ("\\.sqlms$"  . sqlserver-mode)
         ("\\.js$"  . js-mode)
         ("\\.pac$" . js-mode)
         ;; ("\\.js$"  . js3-mode)
         ("\\.txt$" . novel-mode)
         ("\\.mm$" . objc-mode)
         )
       auto-mode-alist))
(add-to-list 'magic-mode-alist
             `(,(lambda ()
                  (and buffer-file-name
                       (string= (file-name-extension buffer-file-name) "h")
                       (or (re-search-forward "@\\<interface\\>"
                                              magic-mode-regexp-match-limit t)
                           (re-search-forward "@\\<protocol\\>"
                                          magic-mode-regexp-match-limit t))))
               . objc-mode))

;; https://github.com/glasserc/ethan-wspace
;; ethan-wspace是用来处理 空格及TAB 相应的问题的
;; 它的 特点是 "无害" "do not harm"
;;有些脚本 提供了自动trim 掉行尾的空格有功能 ，但是在进行diff操作时，会多出不必要的diff
;; ethan-wspace
;;当你打开一个已存在的文件时
;;1. 如果文件中的whitespace 已经都clean 掉了，则它会 在每次保存前进行一个clean ,确保无whitespace
;;2. 如果没有，ethan-wspace 高度显示 errors，它不会自动改动这些errors ,但是它会阻止添加新的errors

;; ethan-wspace 把以下几种情况定义为errors:
;; 1: 行尾空格, trailing whitespace at end of line (eol).
;; 2: 文末没有一个空行 no trailing newline (no-nl-eof).
;; 3:文末有多个空行 more than one trailing newline (many-nls-eof).
;; 4: TAB
;;如果你不想让TAB成为一种error 可以 (set-default 'ethan-wspace-errors (remove 'tabs ethan-wspace-errors))
;;
;; You should also remove any customizations you have made to turn on either
;; show-trailing-whitespace or require-final-newline; we handle those for you.
;; 如果需要 手动删除之 M-x:delete-trailing-whitespace
;; (global-ethan-wspace-mode 1)
(setq-default
  ethan-wspace-face-customized t        ;使用自定义的face ，不必自动计算 ，在daemon模式下怀疑有bug
  ethan-wspace-mode-line-element nil    ;不在modeline 显示 是否启用ethan-wspace
  ethan-wspace-errors '(no-nl-eof eol) ;many-nls-eof tabs
 )
;; 只对特定的major mode 启用ethan-wspace-mode,因为在makefile 中启用会有bug
(dolist (hook '(java-mode-hook c++-mode-hook python-mode-hook c-mode-hook org-mode-hook perl-mode-hook
                               ojbc-mode-hook
                               makefile-mode-hook makefile-bsdmake-mode-hook web-mode-hook
                               protobuf-mode-hook objc-mode-hook lua-mode-hook nxml-mode-hook  python-mode-hook
                               gitconfig-mode-hook go-mode-hook js-mode-hook js3-mode-hook
                               cperl-mode-hook emacs-lisp-mode-hook erlang-mode-hook))
  (add-hook hook 'ethan-wspace-mode))

(setq-default ace-jump-mode-case-fold nil
              ace-jump-mode-scope 'window
              ;; 59==; ,97=a
              ace-jump-mode-move-keys '(97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 59))

;;wgrep
;; (add-hook 'grep-setup-hook 'grep-mode-fun)
(setq-default wgrep-auto-save-buffer t
              wgrep-enable-key "i"
              wgrep-change-readonly-file t)
(defun enable-wgrep-when-entry-insert()
  (when (equal major-mode 'helm-grep-mode)
    (wgrep-change-to-wgrep-mode)))

(defun disable-wgrep-when-exit-insert()
  (when (equal major-mode 'helm-grep-mode)
    (wgrep-abort-changes)))

(with-eval-after-load 'helm-grep
  (autoload 'wgrep-change-to-wgrep-mode "wgrep" "enable wgrep" nil)
  (autoload 'wgrep-abort-changes "wgrep" "disable wgrep" nil)
  (add-hook 'evil-insert-state-entry-hook 'enable-wgrep-when-entry-insert)
  (add-hook 'evil-insert-state-exit-hook 'disable-wgrep-when-exit-insert)
  )

(setq-default
 enable-recursive-minibuffers t        ;在minibuffer 中也可以再次使用minibuffer
 history-delete-duplicates t          ;minibuffer 删除重复历史
 minibuffer-prompt-properties (quote (read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)) ;;;;minibuffer prompt 只读，且不允许光标进入其中
 resize-mini-windows t
 read-buffer-completion-ignore-case t
 read-file-name-completion-ignore-case t
 completion-cycle-threshold 8)
;; (add-hook 'minibuffer-setup-hook 'minibuf-define-key-func )

(setq-default
 compilation-ask-about-save nil         ;编译之前自动保存buffer
 compilation-auto-jump-to-first-error t ;编译完成后自动跳到第一个error处
 compilation-read-command t
 compilation-disable-input nil
 compilation-scroll-output t
 )

(with-eval-after-load 'compile-dwim (require 'joseph-compile-dwim))

(setq-default hippie-expand-try-functions-list
              '(
                yas-hippie-try-expand
                try-expand-dabbrev
                try-joseph-dabbrev-substring
                try-expand-dabbrev-visible
                try-expand-dabbrev-all-buffers
                try-expand-dabbrev-from-kill
                try-expand-list
                try-expand-list-all-buffers
                try-expand-line
                try-expand-line-all-buffers
                try-complete-file-name-partially
                try-complete-file-name
                try-expand-whole-kill
                )
              )
;; a hook to be able to automatically decompile-find-file .class files
(defun jad-find-file-hook()
  (when (string-match "\\.class$" (buffer-file-name))
    (when (executable-find "jad") (jdc-buffer))))

(add-hook 'find-file-hooks 'jad-find-file-hook)
(add-hook 'archive-extract-hooks 'jar-archive-extract-hooks)

(add-hook 'after-save-hook 'joseph_compile_current_el_without_output)

;; (push '("lambda" . #x1d77a) prettify-symbols-alist)
(add-hook 'emacs-lisp-mode-hook 'prettify-symbols-mode)


;;; 设置备份文件的位置
;; (setq-default abbrev-file-name   "~/.emacs.d/cache/abbrev_defs")
;; (message "Deleting old backup files 7 days ago...")
;; (let ((week (* 60 60 24 7))
;;       (current (float-time (current-time))))
;;   (dolist (file (directory-files "~/.emacs.d/cache/backup_files" t))
;;     (when (and (backup-file-name-p file)
;;                (> (- current (float-time (nth 5 (file-attributes file))))
;;                   week))
;;       (message "%s" file)
;;       (delete-file file))))

;; ;;在auto-save到另外一个文件的同时,也保存到当前的文件
;; ;;
;; (defun save-buffer-if-visiting-file (&optional args)
;;   "如果此buffer与文件进行了关联，则保存之."
;;   (interactive)
;;   (if (and (buffer-file-name) (buffer-modified-p)
;;            (not buffer-read-only)
;;            (not (string-match "ssh:" (buffer-file-name))))
;;       (save-buffer args)))
;; (add-hook 'auto-save-hook 'save-buffer-if-visiting-file)





;(find-function-setup-keys)
;; 加入自己的 Info 目录
;; (dolist (path '("/media/hdb1/Programs/Emacs/home/info/perlinfo"
;;                 "/media/hdb1/Programs/Emacs/home/info"
;;                 "~/info" "~/info/perlinfo"))
;;   (add-to-list 'Info-default-directory-list path))



;; (setq echo-keystrokes -1);;立即回显，(当你按下`C-x'等，命令前缀时，立即将显回显，而不是等一秒钟)


;; emacs24 自带的autopair 自动插入 ）]} after ([{
;; (electric-pair-mode 1)


;; (setq-default kill-ring-max 200) ;;用一个很大的 kill ring. 这样防止我不小心删掉重要的东西,默认是60个
 ;; (delete-selection-mode 1) ;;当选中内容时，输入新内容则会替换掉,启用delete-selection-mode
;; (put 'scroll-left 'disabled nil);;允许屏幕左移
;; (put 'scroll-right 'disabled nil);;允许屏幕右移
;;
;;;防止頁面滾動時跳動 scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动，(setq-default scroll-step 1 scroll-margin 0 scroll-conservatively 10000)


;; (mouse-wheel-mode  1);;支持鼠标滚动
;; ;;鼠标在哪个window上,滚动哪个窗口,不必focus后才能滚动
;; (setq-default mouse-wheel-follow-mouse  t)
;; (mouse-avoidance-mode 'animate) ;;鼠标自动避开指针，如当你输入的时候，指针到了鼠标的位置，鼠标有点挡住视线了 X下
;;  ;; scroll one line at a time (less "jumpy" than defaults)
;; (setq-default mouse-wheel-scroll-amount '(3 ((shift) . 1))) ;; one line at a time
;; ;; (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling





;; ** – modified since last save
;; -- – not modified since last save
;; %* – read-only, but modified
;; %% – read-only, not modifed

;; ;;; 看没看见此文件的开头两三行处有一个 Last Updated: <Joseph 2011-05-29 11:10:43>
;; ;;在你每次保存文件的时候，更新上面所对应的时间，
;; ;;前提是文件开头，你得有 Time-stamp: <> 字样，或Time-stamp: ""字样
;; (add-hook 'write-file-hooks 'time-stamp)
;; ;;时间戳的格式为"用户名 年-月-日时:分:秒 星期"
;; (setq-default  time-stamp-format "%:U %04y-%02m-%02d %02H:%02M:%02S")
;; (setq-default time-stamp-start "Last \\([M|m]odified\\|[r|R]evised\\|[u|U]pdated?\\)[ \t]*: +")
;; (setq-default time-stamp-end "$" )
;; (setq-default time-stamp-active t time-stamp-warn-inactive t)

;;; (require 'paren)
;; (show-paren-mode 1) ;显示匹配的括号
;;以高亮的形式显示匹配的括号,默认光标会跳到匹配的括号端，晃眼
;; (setq-default show-paren-style  'parenthesis)

;; (setq-default fill-column 80) ;;把 fill-column 设为 60. 这样的文字更好读。,到60字自动换行



;; (scroll-bar-mode -1);;取消滚动条
;; (defadvice clipboard-kill-ring-save (before slickcopy activate compile)
;;   "When called interactively with no active region, copy a single line instead."
;;   (interactive
;;    (if mark-active (list (region-beginning) (region-end))
;;      (list (line-beginning-position)
;;            (line-beginning-position 2)))))

;;; linum-mode 太慢了
;;(global-linum-mode)


(provide 'joseph-common)
