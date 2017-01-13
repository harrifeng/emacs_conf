;;; Code:
(defvar auto-complete-dict-path "~/.emacs.d/auto-complete-dict")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories auto-complete-dict-path)
(ac-config-default)
;; After completion is started, operations in the following table will be enabled temporarily
;;这几个键是临时的，补全完毕会即不可用
;; TAB,  C-i 	ac-expand 	Completion by TAB
;; RET,  C-m 	ac-complete 	Completion by RET  同TAB，但是他是级联的，也会完成补全的补全
;; down, M-n 	ac-next 	Select next candidate   选择下一个，我修改为C-n
;; up,   M-p 	ac-previous 	Select previous candidate
;; C-?,  f1 	ac-help 	Show buffer help
;; C-s 在出现候选项后，可以C-s 进行过滤，只过滤想要的选项
(setq ac-use-menu-map t) ;;只在菜单出现的出时进行C-n C-p 选择菜单的操作
(define-key ac-menu-map "\C-n" 'ac-next) ;;选择下一个候选项
(define-key ac-menu-map "\C-p" 'ac-previous)
(define-key ac-menu-map "\r" 'ac-complete)
(define-key ac-completing-map "\C-e" 'ac-complete)
(setq ac-show-menu-immediately-on-auto-complete nil) ;;
(setq ac-expand-on-auto-complete t)
(setq ac-menu-height 13);;设置菜单栏的高度20行

(setq ac-delay 0.5)
;; (define-key ac-mode-map (kbd "C-h") 'auto-complete)
;; that is a case that an user wants to complete without inserting any character or
;; a case not to start auto-complete-mode automatically by settings
;;好像是说在还没有调入任何字符的时候,或者默认没启动auto-complete-mode 时，使用这个快捷键进行补全
;; (ac-set-trigger-key  "\t")   ;;当ac-auto-start=nil 时哪个键触发补全
;; (define-key ac-mode-map "\t" 'auto-complete)
(setq ac-use-quick-help t) ;;不显示帮助信息,默认是启用的
;; (setq ac-quick-help-delay 10)  ;;或者设置显示帮助的延迟

(setq ac-auto-start 2); nil将不会进行自动补全，结合ac-set-trigger-key 使用
(make-variable-buffer-local  'ac-auto-start)
(eval-after-load 'cc-mode '(add-hook 'java-mode-hook (lambda() (setq ac-auto-start nil))))
(eval-after-load 'cc-mode '(add-hook 'c++-mode-hook (lambda() (setq ac-auto-start nil))))
(eval-after-load 'cc-mode '(add-hook 'c-mode-hook (lambda() (setq ac-auto-start nil))))
(eval-after-load 'shell-mode '(add-hook 'shell-mode-hook (lambda() (setq ac-auto-start t))))
;;  w32有现在编译版的clang llvm  直接下载后，安装即可, 同时安装mingw 中的c++支持
;; http://clang.org/ w32编译好的clang, 不过需要安装上vs2010
(defun my-ac-clang-setup ()
  "clang setup for c++ or c"
  (require 'auto-complete-clang nil t)
  ;;set ac-clang-executable if clang is not under PATH
  (when (and (featurep 'auto-complete-clang)
             ac-clang-executable)       ;只有当clang确实在系统上存在时,才启用
    (add-to-list 'ac-sources 'ac-source-clang)))

(add-hook 'c++-mode-hook 'my-ac-clang-setup)
(add-hook 'c-mode-hook 'my-ac-clang-setup)

;;(setq ac-use-comphist nil);; 默认会根据用户输入频度调整候选词顺序，不想用可禁用之
(setq ac-comphist-file "~/.emacs.d/cache/ac-comphist.dat" )

(setq global-auto-complete-mode nil)
;;使用字典 ~/.dict
;;或者用这个命令,一个个加入1
;;(setq ac-user-dictionary '("aaa" "bbb"))
;;auto-complete-mode won't be enabled automatically for modes that are not in ac-modes. So you need to set if necessary:
;;将jde-mode 加入到ac-modes ,auto-complete 只对ac-modes 中的mode 开启，如果默认没加入进去，需手工加入
(add-to-list 'ac-modes 'jde-mode)
(add-to-list 'ac-modes 'c++-mode)
(add-to-list 'ac-modes 'java-mode)
(add-to-list 'ac-modes 'sh-mode)
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'text-mode)
(add-to-list 'ac-modes 'sql-mode)
(add-to-list 'ac-modes 'sql-interactive-mode)
(add-to-list 'ac-modes 'sqlplus-mode)
(add-to-list 'ac-modes 'sqlserver-mode)
(add-to-list 'ac-modes 'csharp-mode)
(add-to-list 'ac-modes 'cperl-mode)
(add-to-list 'ac-modes 'nxml-mode)
(add-to-list 'ac-modes 'nxhtml-mode)
(add-to-list 'ac-modes 'erlang-mode)
(add-to-list 'ac-modes 'erlang-shell-mode)
(add-to-list 'ac-modes 'xahk-mode)
(add-to-list 'ac-modes 'visual-basic-mode)
(add-to-list 'ac-modes 'protobuf-mode)
(add-to-list 'ac-modes 'eshell-mode)
(add-to-list 'ac-modes 'python-mode)

;;(setq ac-ignore-case 'smart);; 智能的处理大小写的匹配 ，当有大写字母的时候不忽略大小写，
(setq ac-ignore-case nil)
;;dwim  do what i mean
;; * After selecting candidates, TAB will behave as RET
;; * TAB will behave as RET only on candidate remains
;;当用C-n c-p 选中候选项时tab 表现为return 的行为，即令其上屏
(setq ac-dwim  nil)
;; (defun my_ac-java-mode-setup ()
;;        (setq ac-sources '( ac-source-filename
;;                            ac-source-files-in-current-dir
;;                            ac-source-yasnippet
;;                            ac-source-semantic
;;                            ac-source-semantic-raw
;;                            ac-source-gtags
;;                            ac-source-abbrev
;;                            ac-source-dictionary
;;                             )))
;; (add-hook 'java-mode-hook 'my_ac-java-mode-setup)
(defun my-ac-common-setup()
  (add-to-list 'ac-sources 'ac-source-filename)
  )
(add-hook 'auto-complete-mode-hook 'my-ac-common-setup)
;; 12.1 Auto completion will not be started in a buffer flyspell-mode enabled
(ac-flyspell-workaround)
;;----------------------------------------------------------------------------
;; Use Emacs' built-in TAB completion hooks to trigger AC (Emacs >= 23.2)
;;----------------------------------------------------------------------------
;; (require 'minibuffer)
;; (setq tab-always-indent 'complete) ;; use 'complete when auto-complete is disabled
;; (add-to-list 'completion-styles 'initials t)

;; ;; hook AC into completion-at-point
;; (defun set-auto-complete-as-completion-at-point-function ()
;;   (setq completion-at-point-functions '(auto-complete)))
;; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(provide 'joseph-auto-complete)
;;; joseph-auto-complete.el ends here
