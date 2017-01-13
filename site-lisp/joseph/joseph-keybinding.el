;;; -*- coding:utf-8 -*-
;;; 关于键绑定的一些知识
;;关于键绑定的一些设置
;; change a binding in the global keymap, the change is effective in all
;; buffers (though it has no direct effect in buffers that shadow the
;; global binding with a local one).  If you change the current buffer's
;; local map, that usually affects all buffers using the same major mode.
;; The `global-set-key' and `local-set-key' functions are convenient
;; interfaces for these operations .
;;也就是说global-set-key 对所有的buffer 有效,
;;而local-set-key 只影响某一种major-mode,
;;当同时设置了local-set-key global-set-key ,造成键冲突时,前者的优先级高.后者会被屏避掉.

;;(global-set-key key binding) 等价于 (define-key (current-global-map) key binding)
;;取消键绑定 (global-unset-key key) 等价于 (define-key (current-global-map) key nil)
;;(local-set-key key binding) == (define-key (current-local-map) key binding)
;;(local-unset-key key) == (define-key (current-local-map) key nil)
;;     (global-set-key (kbd "C-x C-\\") 'next-line)
;;     (global-set-key [?\C-x ?\C-\\] 'next-line)
;;     (global-set-key [(control ?x) (control ?\\)] 'next-line)
;;
;;关于前缀的一点介绍
;;比如默认情况下C-z 被绑定到最小化窗口,这个时候我们是没法绑定像"C-z C-f"
;;这样的以C-z 为前缀的快捷键的,如果想要这么做,必须定义一个 前缀,
;;然后把C-z 绑定到这个前缀上.
;;比如
;;(define-prefix-command 'ctl-z-map)
;;(global-set-key (kbd "C-z") 'ctl-z-map)
;;ctrl-z-map 的名字你可以随便取,比如
;;(define-prefix-command 'aaaaaaaaaa)
;;(global-set-key (kbd "C-z") 'aaaaaaaaaa)
;;效果也是相同的
;;这样定义的C-z 的前缀后就可以将键绑定到C-z 开头的的快捷键上了.
;;绑定的方式有两种
;;1, (global-set-key (kbd "C-z C-f") 'find-file)
;;2,或者明确指定使用ctl-z-map 前缀
;; (define-key ctl-z-map (kbd "C-f") 'find-file)

(eval-when-compile (require 'joseph-util))

;; ;;; bindings
;; (define-prefix-command 'ctl-z-map)
;; (global-set-key (kbd "C-z") 'ctl-z-map)

;; (define-prefix-command 'ctl-w-map)
;; (global-set-key (kbd "C-w") 'ctl-w-map)


;; (define-prefix-command 'meta-g-map)
;; (global-set-key (kbd "M-G") 'Meta-G-Map)

;; 默认Emacs 把TAB==`C-i'
;;            RET==`C-m'
;;            ESC==`C-['
;;这样可以进行绑定的键好像少了一些,
;;下面的方法可以实现将`C-i' `C-m'绑定与`TAB' `RET'不同的func
;;不过只在Gui下有用
;; (add-hook 'after-make-frame-functions 'make-frame-func t)
;; (defun make-frame-func( &optional frame)
;;   (with-selected-frame (or frame (selected-frame))
;;     (tool-bar-mode -1);;关闭工具栏
;;     (menu-bar-mode -1)

;;     ;; (keyboard-translate ?\C-i ?\H-i)
;;     ;; (keyboard-translate ?\C-m ?\H-m)
;;     ;; (global-set-key [?\H-m] 'backward-char);C-m
;;     ;; (global-set-key [?\H-i] 'universal-argument) ;C-i
;;     ;; (define-key universal-argument-map  [?\H-i] 'universal-argument-more)
;;     ))
;; (make-frame-func)
;; (global-set-key (kbd "C-o") 'universal-argument)
;; (define-key universal-argument-map (kbd "C-o") 'universal-argument-more)
;; (global-set-key (kbd "C-8") 'universal-argument)
;; (define-key universal-argument-map (kbd "C-8") 'universal-argument-more)



(global-set-key (kbd "`") 'other-window)
;; (global-set-key [?\H-m] 'other-window);C-m

(define-key special-mode-map (kbd "q") 'bury-buffer-and-window)
(global-set-key (kbd "M-o") 'toggle-camelize);


;; (global-set-key "\r" 'newline-and-indent);;return

;; C-h M-h backward delete
;; (global-set-key (kbd "C-?") 'help-command) ;;用C-? 取代C-h
;; (global-set-key (kbd "M-?") 'mark-paragraph)

;; iterm2 keys  选C-backspace send escape sequence 里输入 "[aa" 不包括引号，
;; 通过此方法（与iterm2的） ，可以在terminal 下使用一下terminal 本不该有的keybinding
;; http://superuser.com/questions/731427/how-do-i-send-ctrl-in-iterm2
(global-set-key (kbd "C-[ [ a a") 'backward-kill-word) ;== "M-[ a a" iterm2 map to ctrl-backspace
;; (global-set-key (kbd "C-[ [ a c") 'hippie-expand)   ; iterm map to ctrl-return
(global-set-key (kbd "C-[ [ a d") 'bm-previous)   ; iterm map to ctrl-,
(global-set-key (kbd "C-[ [ a e") 'goto-definition)   ; iterm map to ctrl-.
;; (global-set-key (kbd "C-[ [ a f") 'toggle-eshell-cd)   ; iterm map to ctrl-;
;; (global-set-key (kbd "C-[ [ a h") 'company-complete) ; iterm map to C-i
;; (global-set-key (kbd "C-[ [ a i") 'ignore) ; iterm map to C-3
(global-set-key (kbd "C-[ [ a j") 'ignore) ; iterm map to C-4
;; (global-set-key (kbd "C-w C-[ [ a h") 'goto-definition) ; C-wC-i

(global-set-key (kbd "C-[ [ a l") 'cd-iterm2)   ;iterm2 map to ctrl-f3
(global-set-key (kbd "C-<f3>") 'cd-iterm2)

(global-set-key (kbd "C-[ [ a b") 'toggle-eshell-cd) ; map to ctrl-f2
(global-set-key [f2] 'toggle-eshell)
(global-set-key [C-f2] 'toggle-eshell-cd)



(global-set-key (kbd "C-h") 'my-complete)

;; (global-set-key [f2] 'multi-term-toggle)
;; (global-set-key [C-f2] 'multi-term-toggle-cd)
;; (global-set-key (kbd "C-[ [ a b") 'multi-term-toggle-cd)   ;iterm2 map to ctrl-f2


;; he way I make these key combinations work is to go to the Keys
;; section of the iTerm prefs and create a shortcut for ^; that sends
;; some escape sequence, like ^[[aa (you can replace aa with anything,
;; but be aware that some things are mapped to actual keys). Then in
;; your .emacs, create a keyboard shortcut for what you want it to map
;; to, like
;; (global-set-key (kbd "C-[ [ a a") 'the-function-you-want-to-map-to)


(global-set-key "\C-j" 'open-line-or-new-line-dep-pos)
(global-set-key (kbd "C-a") 'smart-beginning-of-line)
(global-set-key (kbd "C-e") 'smart-end-of-line)
(with-eval-after-load 'org
  (define-key org-mode-map "\C-k" 'joseph-kill-region-or-org-kill-line)
  (define-key org-mode-map "\C-a" 'org-mode-smart-beginning-of-line)
  (define-key org-mode-map "\C-e" 'org-mode-smart-end-of-line))

;;(global-set-key (kbd "C-a" ) (quote  quoted-insert))
;; (global-set-key (kbd "C-c C-j") 'joseph-join-lines)
;; (global-set-key (kbd "C-c j") 'joseph-join-lines)

;;; others
;; (global-set-key ( kbd "C-x C-c") 'ibuffer)
;; (global-set-key "\C-x\c" 'switch-to-buffer)
(global-set-key "\C-x\C-b" 'save-buffers-kill-terminal);; 原来 的C-x C-c

(when (member system-type '(gnu/linux darwin))
  (global-set-key (kbd "C-c o") 'toggle-read-only-file-with-sudo))

(global-set-key  (kbd "C-2") 'set-mark-command)

(global-set-key (kbd "C-c w") 'browse-url-at-point)

;; Faster point movement,一次前进后退5行
(global-set-key "\C-n"  'joseph-forward-4-line)
(global-set-key "\C-p"  'joseph-backward-4-line)
(global-set-key "\M-n"  'next-line)
(global-set-key "\M-p"  'previous-line)



;; (define-key-lazy global-map "\M-\C-n" 'scroll-other-window-up-or-previous-buffer)
;; (define-key-lazy global-map "\M-\C-p" 'scroll-other-window-down-or-next-buffer)
;; (define-key-lazy dired-mode-map "\M-\C-n" 'scroll-other-window-up-or-previous-buffer)
;; (define-key-lazy dired-mode-map "\M-\C-p" 'scroll-other-window-down-or-next-buffer)

(global-set-key "\C-x\C-v" 'switch-to-scratch-buffer)
(define-key lisp-interaction-mode-map "\C-j" 'open-line-or-new-line-dep-pos)

;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
;; (global-set-key (kbd "C-c q") 'auto-fill-mode)
;; (global-set-key "\M-\\" 'just-one-space-or-delete-horizontal-space)
;;词典,需要sdcd的支持
;; (global-set-key "\C-z\C-d" 'query-stardict)
;; (global-set-key "\C-zd" 'sdcv-to-buffer)
(global-set-key "\C-k" 'joseph-kill-region-or-line)
(global-set-key (kbd "C-x k") 'kill-buffer-or-server-edit)
(global-set-key (kbd "C-x C-k") 'kill-buffer-or-server-edit)


(global-set-key "\M-;" 'joseph-comment-dwim-line)

;;; M-Backspace M-d
;; (global-set-key [(meta backspace)] 'kill-syntax-backward)
;; (global-set-key [(meta d)] 'kill-syntax-forward)

(define-key-lazy emacs-lisp-mode-map (kbd "C-x C-e") 'eval-print-last-sexp 'elisp-mode)
(define-key-lazy lisp-interaction-mode-map (kbd "C-x C-e") 'eval-print-last-sexp 'elisp-mode)

;;; goto-last change
;;快速跳转到当前buffer最后一次修改的位置 利用了undo定位最后一次在何处做了修改
;; (autoload 'goto-last-change "goto-last-change" "Set point to the position of the last change." t)
(autoload 'goto-last-change-reverse "goto-chg.el" "goto last change reverse" t)
(global-set-key (kbd "C-x C-/") 'goto-last-change)
(global-set-key (kbd "C-x C-_") 'goto-last-change) ;C-x C-/ for terminal
(global-set-key (kbd "C-x C-,") 'goto-last-change-reverse)
;;; compile dwim
(global-set-key "\C-c\C-k" 'compile-dwim-compile)
(global-set-key "\C-ck" 'compile-dwim-run)

;; (global-set-key (kbd "C-x C-j") 'dired-jump)

;; (when (equal system-type 'windows-nt)
;;   (global-set-key [f2] 'toggle-bash)
;;   (global-set-key [C-f2] 'toggle-bash-cd))
;; (when (equal system-type 'gnu/linux)
;;   (global-set-key [f2] 'toggle-zsh)
;;   (global-set-key [C-f2] 'toggle-zsh-cd))
;; (when (equal system-type 'darwin)
;;   (global-set-key [f2] 'toggle-zsh)
;;   (global-set-key [C-f2] 'toggle-zsh-cd))

;; (eval-after-load 'helm-config '(global-set-key [f5] '(lambda() (interactive) (revert-buffer t t))))
;; (eval-after-load 'actionscript-mode '(global-set-key [f5] '(lambda() (interactive) (revert-buffer t t))))
(global-set-key [f5] '(lambda() (interactive) (revert-buffer t t)))

(global-set-key [remap scroll-up-command] 'golden-ratio-scroll-screen-up) ;C-v
;; (global-set-key "\C-u" 'gold-ratio-scroll-screen-up)
(global-set-key [remap scroll-down-command] 'golden-ratio-scroll-screen-down) ;M-v
(global-set-key "\C-o" 'golden-ratio-scroll-screen-down)

;; (global-set-key ":" (quote shell-command)) ;`Esc:' 扫行shell命令

;; (global-set-key [pause] 'minibuffer-refocus)
(global-set-key (kbd "C-M-g") 'minibuffer-quit)
;; (global-set-key (kbd "C-w k") 'bury-buffer)
;; (global-set-key (kbd "C-w C-k") 'bury-buffer)


;; (global-set-key [(meta  left)]  'scroll-right-1)
;; (global-set-key [(meta  right)] 'scroll-left-1)


;;; 上下移动当前行, (Eclipse style) `M-up' and `M-down'
;; 模仿eclipse 中的一个小功能，用;alt+up alt+down 上下移动当前行
;;不仅当前行,也可以是一个选中的区域
;;; (require 'move-text)
;;default keybinding is `M-up' and `M-down'
;; (autoload 'move-text-up "move-text" "move current line or selected regioned up" t)
;; (autoload 'move-text-down "move-text" "move current line or selected regioned down" t)
(global-set-key [M-up] 'move-text-up)
(global-set-key [M-down] 'move-text-down)
(global-set-key (kbd "ESC <down>") 'move-text-down) ;on terminal
(global-set-key (kbd "ESC <up>") 'move-text-up)     ;on terminal


(define-key-lazy c-mode-base-map ";" 'joseph-append-semicolon-at-eol  'cc-mode)

;; (autoload 'hide-region-hide "hide-region" "hide region" t)
;; (autoload 'hide-region-unhide "hide-region" "unhide region" t)
;; (global-set-key (kbd "C-z h ") (quote hide-region-hide));;隐藏选区
;; (global-set-key (kbd "C-z H ") (quote hide-region-unhide));;重现选区

;; ;; (autoload 'hide-lines "hide-lines" "Hide lines based on a regexp" t)
;; (global-set-key (kbd  "C-z l") 'hide-lines);;;All lines matching this regexp will be ;; hidden in the buffer
;; ;;加一个前缀参数C-u C-z l  则 只显示符合表达式的行
;; (global-set-key (kbd "C-z L" ) 'show-all-invisible);; 显示隐藏的行

(define-key-lazy message-mode-map  [(control return)] 'helm-mail-addrbook-complete "message")

;; (define-key global-map (kbd "C-M-o") 'er/expand-region)

;; (define-key global-map (kbd "M-m") 'ace-jump-char-mode)
;; (define-key global-map (kbd "M-s") 'ace-jump-word-mode)

;; (define-key  isearch-mode-map (kbd  "C-5")  'isearch-query-replace)
;; (define-key  isearch-mode-map (kbd  "C-v")  'isearch-yank-kill)

(setq-default iedit-toggle-key-default (kbd "C-;"))
(autoload 'iedit-mode-from-isearch "iedit" "enable iedit-mode when in isearch mode")
(define-key global-map iedit-toggle-key-default 'iedit-mode)
(define-key global-map (kbd "C-[ [ a f") 'iedit-mode) ;iterm map C-; to this
(define-key isearch-mode-map iedit-toggle-key-default 'iedit-mode-from-isearch)
;; (define-key isearch-mode-map (kbd "C-[ [ a f") 'iedit-mode-from-isearch)

(global-set-key [(tab)]       'smart-tab)
(global-set-key (kbd "TAB")   'smart-tab)


(global-set-key [(meta return)] 'hippie-expand)
 ;meta return on terminal
(global-set-key (kbd "C-M-m") 'hippie-expand) ;meta return for terminal


(autoload 'publish-my-note "joseph-org-publish" "publish my note笔记" t)
(autoload 'publish-my-note-force "joseph-org-publish" "publish my note笔记" t)
(define-key global-map [(control meta ?r)] 'org-capture)
;; (global-set-key (kbd "C-c a")  'org-agenda)

(global-set-key (kbd "C-x C-f") 'ido-find-file)


(define-key  minibuffer-local-completion-map (kbd "C-l") 'minibuffer-up-parent-dir)
(define-key  minibuffer-local-map (kbd "C-l") 'minibuffer-up-parent-dir)
(provide 'joseph-keybinding)
;;emacs -batch -f batch-byte-compile  filename
;;C-x C-e run current lisp
