;; https://github.com/mbriggs/.emacs.d/blob/master/my-keymaps.el

;; http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
;; https://github.com/cofi/dotfiles/blob/master/emacs.d/config/cofi-evil.el
;; https://github.com/syl20bnr/dotemacs/blob/master/init-package/init-evil.el
;;
;; gn 命令的用法 / search 之后，可以用dgn 或cgn 对search到的第一个内容进行处理，然后用.去重复之

;; 如果不想让某些命令jump ,则可以通过这种方式实现
;; You can disable it for %, f, F, t and T with the following:
;; (evil-set-command-property #'evil-jump-item :jump nil)
;; (evil-set-command-property #'evil-find-char :jump nil)
;; (evil-set-command-property #'evil-find-char-backward :jump nil)
;; (evil-set-command-property #'evil-find-char-to :jump nil)
;; (evil-set-command-property #'evil-find-char-to-backward :jump nil)

;; vim register 的用法
;; :reg 可以查看所有寄存器中的内容
;; 默认的寄存器为"即yy dd 的内容会被放到"寄存器中,即 ""yy 与yy等同，""p 与p 等同

;; 要操作指定的寄存器可以
;; "ayy 即把当前行yy到a的寄存器中
;; "ap 把寄存器a的内容paste 下当下位置
;;


;; 利用 “ 与0的区别的一个小技巧
;; yank 操作默认会把内容放到"与0中，
;; 而delete操作则只会放到"而不会放到0中
;; 即都会影响",区别是 是否影响0
;;
;; 而"1 "2 "3 .... "9 则分别存最近yank or delete 的内容，即类似于emacs 中的kill-ring
;; 而利用1~9 这几个寄存器与.重复命令，可以依次将其取出
;; "1p... 则会依次将 1 2 3 4 寄存器中的内容paste 到当前位置
;;
;;
;; 所以 先yank 一段内容A，后delete 一段内容B, p操作 会paste B 而"0p 而会paster A

;; 在windows 下 * 寄存器表示system clipboard,"*p 将把clipboard 的内容paste
;; 在X(Linux, possibly also OS-X),+表示 Ctrl-XCV clipboard
;; 在linux下 * 寄存器表示primary selection ，即linux下选中即复制到此的clipboard
;; "/  last search command
;; ":  last command.
;; ". 里面存最近insert 的内容
;; "_ 类似于/dev/null 是个无底洞

(eval-when-compile
  (require 'package)
  ;; (require 'joseph-keybinding)
  (require 'compile)
  (require 'magit)
  (require 'evil-magit)
)


(setq-default
 ;; evil-search-module 'isearch        ;可以用C-w yank word
 evil-search-module 'evil-search        ;可以用gn 命令，需要取舍
 evil-ex-search-highlight-all nil
 evil-toggle-key "<f16>"                ;用不到了 绑定到一个不常用的键
 evil-want-visual-char-semi-exclusive t ; 当v 选择到行尾时是否包含换行符
 evil-want-C-i-jump nil
 evil-cross-lines t
 evil-default-state 'normal
 evil-want-fine-undo t                  ;undo更细化,否则从N->I->N 中所有的修改作为一个undo
 evil-symbol-word-search t              ;# search for symbol not word
 evil-flash-delay 0.5                   ;default 2
 evil-ex-search-case 'sensitive
 ;; C-e ,到行尾时,光标的位置是在最后一个字符后,还是在字符上
 evil-move-cursor-back nil)

(setq-default
 evil-normal-state-tag (propertize "N" 'face '((:background "green" :foreground "black")))
 evil-emacs-state-tag (propertize "E" 'face '((:background "orange" :foreground "black")))
 evil-insert-state-tag (propertize "I" 'face '((:background "red")))
 evil-motion-state-tag (propertize "M" 'face '((:background "blue")))
 evil-visual-state-tag (propertize "V" 'face '((:background "grey80" :foreground "cyan")))
 evil-operator-state-tag (propertize "O" 'face '((:background "purple"))))

;; (setq evil-highlight-closing-paren-at-point-states nil)
(setq-default
 evil-default-cursor '(t "white")
 evil-emacs-state-cursor  '("gray" box)
 evil-normal-state-cursor '("green" box)
 evil-visual-state-cursor '("cyan" hbar)
 evil-insert-state-cursor '("orange" bar)
 evil-motion-state-cursor '("gray" box))



(require 'evil)
;; minor-mode
(add-hook 'org-capture-mode-hook 'evil-insert-state)
(setq-default evil-buffer-regexps
              '(("**testing snippet:" . insert)
                ("*compile*" . normal)
                ("*Org Src" . insert)
                ("*Org Export Dispatcher*" . insert)
                ("*Async Shell Command*" . normal)
                ("^ \\*load\\*")))

(evil-set-initial-state 'bm-show-mode 'insert)
(evil-set-initial-state 'diff-mode 'insert)
(evil-set-initial-state 'git-rebase-mode 'insert)
(evil-set-initial-state 'package-menu-mode 'normal)
(evil-set-initial-state 'vc-annotate-mode 'normal)
(evil-set-initial-state 'Custom-mode 'normal)
(evil-set-initial-state 'erc-mode 'normal)
(evil-set-initial-state 'ibuffer-mode 'normal)
(evil-set-initial-state 'vc-dir-mode 'normal)
(evil-set-initial-state 'vc-git-log-view-mode 'normal)
(evil-set-initial-state 'vc-svn-log-view-mode 'normal)
(evil-set-initial-state 'erlang-shell-mode 'normal)
(evil-set-initial-state 'org-agenda-mode 'normal)
(evil-set-initial-state 'minibuffer-inactive-mode 'normal)
;; 把所有emacs state  的mode 都转成insert mode
(dolist (mode evil-emacs-state-modes)
  (cond
   ((memq mode evil-normal-state-modes)
    (evil-set-initial-state mode 'normal))
   ((memq mode evil-motion-state-modes)
    (evil-set-initial-state mode 'motion))
   (t
    (evil-set-initial-state mode 'insert))))

(setq evil-emacs-state-modes nil)


(add-to-list 'evil-overriding-maps '(vc-git-log-view-mode-map . nil))
(add-to-list 'evil-overriding-maps '(vc-svn-log-view-mode-map . nil))
(add-to-list 'evil-overriding-maps '(evil-leader--default-map . nil))
(add-to-list 'evil-overriding-maps '(custom-mode-map . nil))
(add-to-list 'evil-overriding-maps '(ediff-mode-map . nil))
(add-to-list 'evil-overriding-maps '(package-menu-mode-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-completion-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-must-match-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-isearch-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-ns-map . nil))



;; 更新 evil-overriding-maps ,因为org-agenda-mode-map 变量初始为空keymap,在org-agenda-mode内才往里添加绑定
(evil-set-custom-state-maps 'evil-overriding-maps
                            'evil-pending-overriding-maps
                            'override-state
                            'evil-make-overriding-map
                            evil-overriding-maps)

(with-eval-after-load 'org-agenda
  (add-to-list 'evil-overriding-maps '(org-agenda-mode-map . nil))
  (evil-set-custom-state-maps 'evil-overriding-maps
                              'evil-pending-overriding-maps
                              'override-state
                              'evil-make-overriding-map
                              evil-overriding-maps))

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
;; (setq-default evil-magit-state 'normal)
(setq-default evil-magit-use-y-for-yank t)
(with-eval-after-load 'magit
  (require 'evil-magit)
  ;;(setq evil-window-map  ctl-w-map)
  (evil-magit-define-key evil-magit-state 'magit-mode-map
                         "C-w"  evil-window-map)

  (evil-magit-define-key evil-magit-state 'magit-mode-map
                         "gw" 'toggle-diff-whitespace-eol))

(evil-mode 1)
(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)
  (evil-terminal-cursor-changer-activate))

(global-evil-matchit-mode 1)


;; (dolist (mode evil-motion-state-modes)
;;   (evil-set-initial-state mode 'normal))
;; (setq evil-motion-state-modes nil)

;; (add-hook 'after-save-hook 'evil-change-to-initial-state)

(evil-declare-motion 'golden-ratio-scroll-screen-down)
(evil-declare-motion 'golden-ratio-scroll-screen-up)

;; ;; 同一buffer 内的jump backward
;; (defadvice ace-jump-word-mode (before evil-jump activate)
;;   (push (point) evil-jump-list))
;; (defadvice ace-jump-char-mode (before evil-jump activate)
;;   (push (point) evil-jump-list))
;; (defadvice ace-jump-line-mode (before evil-jump activate)
;;   (push (point) evil-jump-list))

;; (defadvice eval-print-last-sexp (around evil activate)
;;   (if (evil-normal-state-p)
;;       (progn
;;         (unless (or (eobp) (eolp)) (forward-char))
;;         ad-do-it)
;;     ad-do-it))

;; (defadvice eval-last-sexp (around evil activate)
;;   (if (evil-normal-state-p)
;;       (progn
;;         (unless (or (eobp) (eolp)) (forward-char))
;;         ad-do-it)
;;     ad-do-it))



;; emacs 自带的repeat 绑定在C-xz上， 这个advice ,奖 repeat 的功能 与evil 里的","功能合
;; 2为1,一起绑定在","紧临evil-repeat"." 如此一来， 跟编辑相关的repeat用"." ,跟光标移动相关的
;; 可以用","
(defadvice repeat(around evil-repeat-find-char-reverse activate)
  "if last-command is `evil-find-char' or
`evil-repeat-find-char-reverse' or `evil-repeat-find-char'
call `evil-repeat-find-char-reverse' if not
execute emacs native `repeat' default binding to`C-xz'"
  (if (member last-command '(evil-find-char
                             evil-repeat-find-char-reverse
                             repeat
                             evil-find-char-backward
                             evil-repeat-find-char))
      (progn
        ;; ;I do not know why need this(in this advice)
        (when (evil-visual-state-p)(unless (bobp) (forward-char -1)))
        (call-interactively 'evil-repeat-find-char-reverse)
        (setq this-command 'evil-repeat-find-char-reverse))
    ad-do-it))

(defadvice keyboard-quit (before evil-insert-to-nornal-state activate)
  "C-g back to normal state"
  (when  (evil-insert-state-p)
    (cond
     ((equal (evil-initial-state major-mode) 'normal)
      (evil-normal-state))
     ((equal (evil-initial-state major-mode) 'insert)
      (evil-normal-state))
     ((equal (evil-initial-state major-mode) 'motion)
      (evil-motion-state))
     ((equal (evil-initial-state-for-buffer-name (buffer-name) 'insert) 'insert)
      (evil-normal-state))
     ((equal (evil-initial-state-for-buffer-name (buffer-name) 'insert) 'motion)
      (evil-motion-state))
     (t
      (if (equal last-command 'keyboard-quit)
          (evil-normal-state)           ;如果初始化state不是normal ，按两次才允许转到normal state
        (evil-change-to-initial-state)) ;如果初始化state不是normal ，按一次 转到初始状态
      ))))

;; (defadvice joseph-comment-dwim-line(around evil activate)
;;   "In normal-state, eol check"
;;   (when (and (evil-normal-state-p)
;;              evil-move-cursor-back)
;;     (unless (or (eobp) (eolp)) (forward-char))) ;
;;   ad-do-it)

;; ;; 下面的部分 insert mode 就是正常的emacs
;; ;; Insert state clobbers some useful Emacs keybindings
;; ;; The solution to this is to clear the insert state keymap, leaving you with
;; ;; unadulterated Emacs behavior. You might still want to poke around the keymap
;; ;; (defined in evil-maps.el) and see if you want to salvage some useful insert
;; ;; state command by rebinding them to keys of your liking. Also, you need to
;; ;; bind ESC to putting you back in normal mode. So, try using this code.
;; ;; With it, I have no practical need to ever switch to Emacs state.
;; ;; 清空所有insert-state的绑定,这样 ,insert mode 就是没装evil 前的正常emacs了
;; ;; evil-emacs-state is annoying, the following function and hook automatically
;; ;; switch to evil-insert-state whenever the evil-emacs-state is entered.
;; ;; It allows a more consistent navigation experience among all mode maps.
;; (defun evil-emacs-state-2-evil-insert-state ()
;;   (if (equal (evil-initial-state major-mode) 'normal)
;;       (evil-normal-state)
;;     (evil-insert-state))
;;   (remove-hook 'post-command-hook 'evil-emacs-state-2-evil-insert-state))
;; (add-hook 'evil-emacs-state-entry-hook
;;           (lambda ()
;;             (add-hook 'post-command-hook 'evil-emacs-state-2-evil-insert-state)))

;; ;; same thing for motion state but switch in normal mode instead
;; ;; 这一部分暂时注掉,以观后效
;; (defun evil-motion-state-2-evil-normal-state ()
;;   (if (equal (evil-initial-state major-mode) 'insert)
;;       (evil-insert-state)
;;     (evil-normal-state))
;;   (remove-hook 'post-command-hook 'evil-motion-state-2-evil-normal-state))
;; (add-hook 'evil-motion-state-entry-hook
;;   (lambda ()
;;     (add-hook 'post-command-hook 'evil-motion-state-2-evil-normal-state)))


;; (with-eval-after-load 'log-view
;;   (evil-make-overriding-map log-view-mode-map 'normal t)
;;      (evil-define-key 'normal log-view-mode-map
;;        (kbd "SPC") evil-leader--default-map))

;; 默认dird 的r 修改了, 不是 wdired-change-to-wdired-mode,现在改回
(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map
    "r" 'revert-buffer                ; "l"
    "gr" 'revert-buffer
    "gg" 'dired-beginning-of-buffer
    "G" 'dired-end-of-buffer
    ";" nil                             ;取消对;的绑定
))

(with-eval-after-load 'compile
  (define-key compilation-mode-map "g" nil)
  (define-key compilation-mode-map "C-o" nil)
  (evil-define-key 'normal compilation-mode-map
    "C-j" 'compilation-display-error        ;old C-o
    "r" 'recompile))

(with-eval-after-load 'diff-mode
  (evil-add-hjkl-bindings diff-mode-map 'insert
    (kbd "SPC") evil-leader--default-map
    "t" 'toggle-diff-whitespace-eol
))

(with-eval-after-load 'package
  (define-key package-menu-mode-map "g" nil)
  (define-key tabulated-list-mode-map "n" nil)
  (define-key tabulated-list-mode-map "0" nil))

;; (eval-after-load 'comint
;;   '(progn
;;      ;; use the standard Dired bindings as a base
;;      (evil-set-initial-state 'comint-mode 'normal)
;;      (defvar comint-mode-map)
;;      (evil-make-overriding-map comint-mode-map 'normal t)
;;      (evil-define-key 'normal comint-mode-map
;;        (kbd "SPC") evil-leader--default-map)))


(with-eval-after-load 'org-agenda
  (evil-define-key 'normal org-agenda-mode-map
    "j" 'evil-next-line
    "k" 'evil-previous-line
    ":" 'evil-ex
    "r" 'org-agenda-redo))





;; 交换y p 的功能
;; (define-key evil-normal-state-map "y" 'evil-paste-after)
;; (define-key evil-normal-state-map "Y" 'evil-paste-before)
;; (define-key evil-normal-state-map "p" 'evil-yank)
;; (define-key evil-normal-state-map "P" 'evil-yank-line)
;; (define-key evil-normal-state-map "w" 'evil-window-map)
;; (define-key evil-normal-state-map (kbd "C-y") 'yank)
;;

;; (defun my-enter-evil-insert-state()
;;   (interactive)
;;   (message "mmm %s" (symbol-name real-last-command))
;;   ;; (if (string-match "\\(isearch-\\|evil.*search\\)" (symbol-name real-last-command))
;;   ;;   (message "word")
;;   ;;   (message "hello"))
;; (evil-insert-state)
;; )
;; (add-hook 'evil-jumps-pre-jump-hook 'my-evil-jumps-pre-jump-hook)
(defadvice evil-set-jump (around evil-jump activate)
  (unless (string-match "bm-.*" (symbol-name this-command))
    (bm-bookmark-add nil nil t))
  ad-do-it)


(defadvice isearch-cancel(around evil-jump-remomve activate)
  (goto-char isearch-opoint)
  (bm-bookmark-remove)
  ad-do-it)


;; esc
(setcdr evil-insert-state-map nil)
(setq evil-window-map nil)
;; (define-key evil-insert-state-map [escape] nil) ;emacs karabiner shift 输入法切换相关
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)

(define-key minibuffer-local-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-ns-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-completion-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-must-match-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-isearch-map [escape] 'abort-recursive-edit)

(with-eval-after-load 'isearch (define-key isearch-mode-map [escape] 'isearch-abort))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 这段代码实现 squirrel中文输入法的切换与evil-mode 的协调
;; 主要实现两个功能
;; 1 shift切换到中文输入法时，自动进入evil-insert-state
;; 2当emacs进入evil-normal-state ,使squirrel输入法进入输入英文状态
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-evil-normal()
  (interactive)
  (evil-normal-state)
  (setq this-command 'evil-normal-state))


(define-key evil-insert-state-map (kbd "C-g") 'my-evil-normal)
(define-key evil-insert-state-map [escape] 'my-evil-normal)
;; (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
(defun disable-input-method-hook()
  ;; (start-process "squirrel-input-method-disable-chinese" nil "/Library/Input Methods/Squirrel.app/Contents/MacOS/squirrel_client" "-s" "ascii_mode" "--clear")
  (when (and (equal system-type 'darwin)(file-exists-p "/Library/Input Methods/Squirrel.app/Contents/MacOS/squirrel_client" )) ;mac 上squirrel与输入法相关
    (call-process  "/Library/Input Methods/Squirrel.app/Contents/MacOS/squirrel_client" nil 0 nil "-s" "ascii_mode" )))

;; 输入法进入normal state时，关闭输入法的中文模式
(add-hook 'evil-normal-state-entry-hook 'disable-input-method-hook)
(global-set-key (kbd "<f17>") 'my-evil-normal) ;mac karabiner用来控制输入法
(define-key isearch-mode-map (kbd "<f17>") 'my-evil-normal) ;详见isearch-pre-command-hook

;; 当切换输入法到中文状态时的时候会回调到这里
;;回调的时候有可能是上面disable-input-method-hook 里调，此时不应该切到insert模式
(defun my-evil-insert()
  (interactive)
  (unless (equal 'evil-normal-state last-command)
    (evil-insert-state)))
(global-set-key (kbd "<f18>") 'my-evil-insert) ;mac karabiner用来控制输入法
(define-key isearch-mode-map (kbd "<f18>") 'my-evil-insert) ;详见isearch-pre-command-hook
;; "Non-nil means random control characters terminate incremental search."
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (define-key evil-normal-state-map "/" 'helm-swoop)

;; (define-key evil-motion-state-map "/" 'evil-search-forward)
;; (define-key evil-normal-state-map "/" 'evil-search-forward)



;; (define-key evil-window-map "1" 'delete-other-windows)
;; (define-key evil-window-map "0" 'delete-window)
;; (define-key evil-window-map "2" 'split-window-func-with-other-buffer-vertically)
;; (define-key evil-window-map "3" 'split-window-func-with-other-buffer-horizontally)

;; (define-key evil-normal-state-map (kbd "f") 'ace-jump-mode)
(define-key evil-normal-state-map (kbd "C-z") nil)
;; (define-key evil-normal-state-map (kbd "C-w") 'ctl-w-map)
(define-key evil-normal-state-map "\C-n" nil)
(define-key evil-normal-state-map "\C-p" nil)
(define-key evil-normal-state-map "\C-v" nil)
(define-key evil-motion-state-map "\C-v" nil)
(define-key evil-normal-state-map "\C-e" nil)

(fset 'evil-next-line 'evil-next-visual-line)
(fset 'evil-previous-line 'evil-previous-visual-line)
;; (define-key evil-motion-state-map "j" 'evil-next-visual-line)
;; (define-key evil-motion-state-map "k" 'evil-previous-visual-line)


;; (define-key evil-motion-state-map (kbd "C-w") nil)
(define-key evil-motion-state-map (kbd "C-i") nil)
(define-key evil-motion-state-map (kbd "C-b") nil)
(define-key evil-motion-state-map (kbd "C-d") nil)
(define-key evil-motion-state-map (kbd "C-e") nil)
(define-key evil-motion-state-map (kbd "C-f") nil)
(define-key evil-motion-state-map (kbd "C-y") nil)
(define-key evil-normal-state-map [remap yank-pop] nil)
(define-key evil-normal-state-map (kbd "M-.") nil)
;; (define-key evil-normal-state-map "q" nil)
(define-key evil-normal-state-map (kbd "DEL") nil) ;backupspace
(define-key evil-motion-state-map  (kbd "RET") nil) ;
(define-key evil-normal-state-map  (kbd "RET") nil) ;
;; (define-key evil-motion-state-map "n" nil)
;; (define-key evil-motion-state-map "N" nil)
(define-key evil-normal-state-map "\C-r" nil)
(define-key evil-normal-state-map  (kbd "C-.") nil)
(define-key evil-normal-state-map  (kbd "M-.") nil)
;; (define-key evil-normal-state-map "o" nil)
;; (define-key evil-normal-state-map "\M-o" 'evil-open-below)
;; (define-key evil-normal-state-map "O" nil)
(define-key evil-motion-state-map (kbd "C-o") nil)

;; (define-key evil-normal-state-map "m" nil) ;evil-set-marker

(define-key evil-motion-state-map "`" nil) ;'evil-goto-mark


(define-key evil-normal-state-map "q" 'kill-buffer-or-server-edit)
(define-key evil-normal-state-map "Q" 'kill-buffer-and-window)
(define-key evil-motion-state-map "L" 'joseph-forward-4-line)
(define-key evil-motion-state-map "H" 'joseph-backward-4-line)
;; (define-key evil-normal-state-map "s" 'joseph-forward-symbol-or-isearch-regexp-forward)
;; (define-key evil-normal-state-map "S" 'joseph-backward-symbol-or-isearch-regexp-backward)
(define-key evil-normal-state-map "m" nil)
(define-key evil-normal-state-map "mm" 'bm-toggle) ;evil-set-marker
(define-key evil-normal-state-map "mq" 'fill-paragraph)
;; (define-key evil-normal-state-map "m\t" 'novel-fill)

(define-key evil-normal-state-map "mv" 'evil-visual-block) ;=vim.C-v

(define-key evil-motion-state-map "sv" 'evil-visual-char) ;vim.v
(define-key evil-motion-state-map "sm" 'evil-visual-line) ;vim.V
;; C-3 加任一char ,start  and C-3 end ,then @char repeat
(define-key evil-normal-state-map (kbd "C-[ [ a i") 'evil-record-macro) ;C-3 default q

;; g; goto-last-change
;; g,  goto-last-change-reverse
;; (define-key evil-normal-state-map "g/" 'goto-last-change-reverse); goto-last-change

(define-key evil-normal-state-map "gh" 'evil-goto-line) ;default G

(define-key evil-normal-state-map "gf" 'evil-jump-forward)
(define-key evil-normal-state-map "gb" 'evil-jump-backward)
(define-key evil-normal-state-map "ga" (kbd "M-a"))
(define-key evil-normal-state-map "ge" (kbd "M-e"))
;; (define-key evil-normal-state-map "gA" (kbd "C-M-a"))
;; (define-key evil-normal-state-map "gE" (kbd "C-M-e"))
(define-key evil-normal-state-map "s" nil)
(define-key evil-normal-state-map "sa" 'evil-begin-of-defun)

(define-key evil-normal-state-map "sp" 'evil-paste-pop)
(define-key evil-normal-state-map "sP" 'evil-paste-pop)

(define-key evil-motion-state-map "gj" 'joseph-forward-4-line)
(define-key evil-motion-state-map "gk" 'joseph-backward-4-line)

(define-key evil-normal-state-map "ss" 'evil-end-of-defun)
(define-key evil-normal-state-map "se" 'evil-end-of-defun)

(define-key evil-normal-state-map "me" 'evil-M-e)
(define-key evil-normal-state-map "ma" 'evil-M-a)

(define-key evil-normal-state-map "s/" 'goto-last-change)
(define-key evil-normal-state-map "s," 'goto-last-change-reverse)

;; (define-key evil-normal-state-map "eh" (kbd "C-M-h"))
(define-key evil-normal-state-map "sf" 'evil-C-M-f)
(define-key evil-normal-state-map "sb" 'evil-C-M-b)
(define-key evil-normal-state-map "sd" 'evil-C-M-k)
(define-key evil-normal-state-map "sy" 'evil-copy-sexp-at-point) ;kill-sexp,undo
(define-key evil-normal-state-map "sk" (kbd "C-k"))
(define-key evil-normal-state-map "su" (kbd "C-u 0 C-k")) ;H-i =C-u 删除从光标位置到行首的内容

(define-key evil-normal-state-map "so" 'helm-occur)


(define-key evil-normal-state-map "mf" 'evil-mark-defun) ;mark-defun
(define-key evil-normal-state-map "mh" 'evil-M-h)
(define-key evil-normal-state-map "mxh" 'evil-mark-whole-buffer)
(define-key evil-normal-state-map "mb" 'evil-mark-whole-buffer)
;; (define-key evil-normal-state-map "mo" 'er/expand-region);
;; (define-key evil-visual-state-map "mo" 'er/expand-region);
;; (define-key evil-normal-state-map "mO" 'er/contract-region);
;; e ,r 移动
(define-key evil-normal-state-map "e" 'evil-forward-symbol-begin)
(define-key evil-normal-state-map "r" 'evil-forward-symbol-end)
;; (define-key evil-normal-state-map "E" 'evil-forward-symbol-end)
(define-key evil-normal-state-map "v" 'evil-backward-symbol-begin)
;; (define-key evil-normal-state-map ";" 'evil-repeat-find-char-or-evil-backward-symbol-begin)
(define-key evil-normal-state-map "R" 'evil-backward-symbol-end)

(define-key evil-visual-state-map "e" 'evil-forward-symbol-begin)
(define-key evil-visual-state-map "r" 'evil-forward-symbol-end)
;; (define-key evil-visual-state-map "E" 'evil-forward-symbol-end)
(define-key evil-visual-state-map "v" 'evil-backward-symbol-begin)
(define-key evil-visual-state-map "R" 'evil-backward-symbol-end)

(define-key evil-visual-state-map "n" 'rectangle-number-lines) ;C-xrN

;; de dr
(define-key evil-motion-state-map "e" 'evil-forward-symbol-end)
(define-key evil-motion-state-map "r" 'evil-backward-symbol-begin)
;; dae die
(define-key evil-outer-text-objects-map "e" 'evil-a-symbol)
(define-key evil-inner-text-objects-map "e" 'evil-inner-symbol)


(define-key evil-normal-state-map (kbd "C-j") 'open-line-or-new-line-dep-pos)
;; (define-key evil-normal-state-map (kbd ".") 'repeat)
;; (define-key evil-normal-state-map (d "zx") 'repeat) ;
(define-key evil-normal-state-map "," 'repeat)
(define-key evil-visual-state-map "," 'repeat)
(define-key evil-motion-state-map "," 'repeat) ;
(define-key evil-visual-state-map "x" 'exchange-point-and-mark)
(define-key evil-visual-state-map "X" 'evil-visual-exchange-corners)

;; (global-set-key (kbd "M-SPC") 'rm-set-mark);;alt+space 开始矩形操作，然后移动位置，就可得到选区
(define-key evil-motion-state-map (kbd "M-SPC")  'evil-visual-block)
(define-key evil-motion-state-map "K" 'kill-buffer-or-server-edit)
(define-key evil-ex-completion-map (kbd "H-m") 'exit-minibuffer)
(define-key global-map (kbd   "M-:") 'evil-ex)

;; (), {}, [], <>, '', "", ` `, or “” by default
;; 不论是何种 ，都会将最近的配对进行操作
(setq-default evil-textobj-anyblock-blocks
              '(("(" . ")")
                ("{" . "}")
                ("\\[" . "\\]")
                ("<" . ">")
                ("'" . "'")
                ("\"" . "\"")
                ("`" . "`")
                ("“" . "”")
                ("［" . "］")           ;全角
                ("（" . "）")           ;全角
                ("{" . "}")             ;全角
                ))
(add-hook 'lisp-mode-hook
          (lambda ()
            (setq-local evil-textobj-anyblock-blocks
                        '(("(" . ")")
                          ("{" . "}")
                          ("\\[" . "\\]")
                          ("\"" . "\"")))))

(define-key evil-inner-text-objects-map "b" 'evil-textobj-anyblock-inner-block)
(define-key evil-outer-text-objects-map "b" 'evil-textobj-anyblock-a-block)
;; (define-key evil-inner-text-objects-map "[" 'evil-textobj-anyblock-inner-block)
;; (define-key evil-outer-text-objects-map "[" 'evil-textobj-anyblock-a-block)
;; (define-key evil-outer-text-objects-map "]" 'evil-textobj-anyblock-a-block)
;; (define-key evil-inner-text-objects-map "]" 'evil-textobj-anyblock-inner-block)

;; 不常用， 且如果这样绑定则无法全无 vim 的 :s/abc/def/g替换
;; (evil-ex-define-cmd "s[ave]" 'evil-write)

(evil-leader/set-key "?" 'helm-descbinds)
(evil-leader/set-key "SPC" 'helm-multi-files)
(evil-leader/set-key "wl" 'helm-locate)
(evil-leader/set-key "wi" 'helm-semantic-or-imenu)
(evil-leader/set-key "wf" 'helm-locate)
(evil-leader/set-key "wo" 'helm-ls-git-ls)
(evil-leader/set-key "b" 'helm-resume)
(evil-leader/set-key "wy" 'helm-all-mark-rings)
(evil-leader/set-key "wp" 'helm-list-emacs-process)

(define-key evil-motion-state-map "gd" 'goto-definition)
(define-key evil-motion-state-map "gs" 'helm-etags+-select)
(define-key evil-motion-state-map "gt" 'helm-gtags-find-tag-and-symbol)
(define-key evil-motion-state-map "gr" 'helm-gtags-find-rtag)
(define-key evil-motion-state-map "gc" 'helm-gtags-find-tag-from-here)

(evil-leader/set-key "wge" 'helm-gtags-update-tags)
(evil-leader/set-key "wgr" 'helm-gtags-find-rtag)
(evil-leader/set-key "wgp" 'helm-gtags-parse-file)
(evil-leader/set-key "wgi" 'helm-gtags-parse-file)
(evil-leader/set-key "we" 'ctags-update)



(define-key evil-normal-state-map "sl" 'helm-locate)
(define-key evil-normal-state-map "s;" 'joseph-comment-dwim-line)


(evil-leader/set-key "wf" 'helm-find-files)
(evil-leader/set-key "f" 'helm-find-files)
;; (evil-leader/set-key "f" 'ido-find-file)
(evil-leader/set-key "wb" 'helm-resume)

(evil-leader/set-key "o" 'other-window)
(evil-leader/set-key "g" 'helm-search)
;; (evil-leader/set-key "G" 'helm-do-zgrep)
(evil-leader/set-key "vj" 'magit-status)
(evil-leader/set-key "vv" 'vc-next-action)
(evil-leader/set-key "vu" 'vc-revert)
(evil-leader/set-key "vl" 'vc-print-log)
(evil-leader/set-key "vL" 'vc-print-root-log)
(evil-leader/set-key "v+" 'vc-update)
(evil-leader/set-key "vf" 'vc-pull)
(evil-leader/set-key "vp" 'magit-push-current-to-upstream)
(evil-leader/set-key "vs" 'magit-file-popup)
(evil-leader/set-key "vg" 'vc-annotate)
(evil-leader/set-key "vd" 'vc-dir)
(evil-leader/set-key "v=" 'vc-diff)
(evil-leader/set-key "=" 'vc-diff)
(evil-leader/set-key "+" 'vc-ediff)
(evil-leader/set-key "2" 'split-window-func-with-other-buffer-vertically)
(evil-leader/set-key "3" 'split-window-func-with-other-buffer-horizontally)
(global-set-key (kbd "C-x 2")  'split-window-func-with-other-buffer-vertically)
(global-set-key (kbd "C-x 3")  'split-window-func-with-other-buffer-horizontally)

(evil-leader/set-key "4" 'toggle-split-window-horizontally-vertically)
(evil-leader/set-key "1" 'delete-other-windows)
(evil-leader/set-key "0" 'delete-window)
;; (evil-leader/set-key "dj" 'dired-jump)
(autoload 'dired-jump "dired-x" "dired-jump" t)
(evil-leader/set-key "j" 'dired-jump)
;; (evil-leader/set-key "b" 'ido-switch-buffer)
;; (evil-leader/set-key "c" 'ido-switch-buffer)
(evil-leader/set-key "a" 'smart-beginning-of-line)
(evil-leader/set-key "e" 'smart-end-of-line)
(evil-leader/set-key "d" 'evil-next-buffer) ;K prev-buffer
(evil-leader/set-key "k" 'evil-prev-buffer) ;
(evil-leader/set-key "xk" 'kill-buffer-or-server-edit)
(evil-leader/set-key-for-mode 'emacs-lisp-mode "xe" 'eval-print-last-sexp)
(evil-leader/set-key  "w;" 'ff-find-other-file) ;头文件与源文件间快速切换


(evil-leader/set-key "wk" 'kill-buffer-or-server-edit)
(evil-leader/set-key "q" 'bury-buffer-and-window)
(evil-leader/set-key ";" 'helm-M-x)
(evil-leader/set-key "；" 'helm-M-x)

(evil-leader/set-key "l" 'ibuffer)
(evil-leader/set-key (kbd "C-g") 'keyboard-quit)
(evil-leader/set-key "ws" 'compile-dwim-compile)
(evil-leader/set-key "wr" 'compile-dwim-run)
(evil-leader/set-key "<f5>" 'compile-dwim-run)
(evil-leader/set-key "<f6>" 'recompile)
(evil-leader/set-key "z$" 'toggle-truncate-lines)
(evil-leader/set-key "zd" 'sdcv-to-buffer)
(evil-leader/set-key "s" 'evil-write-all)
(global-set-key (kbd "C-x C-s") 'evil-write-all)
(global-set-key (kbd "C-x s") 'evil-write-all)

;; (evil-leader/set-key "S" 'save-buffer)
;; (evil-leader/set-key "j" 'open-line-or-new-line-dep-pos)
(evil-leader/set-key "rt" 'string-rectangle)
(evil-leader/set-key "rk" 'kill-rectangle)
(evil-leader/set-key "ry" 'yank-rectangle)
(evil-leader/set-key "h" 'evil-mark-whole-buffer)
(evil-leader/set-key "nw" 'widen)
(evil-leader/set-key "nn" 'narrow-to-region)
(evil-leader/set-key "xu" 'undo-tree-visualize)
(evil-leader/set-key "xv" 'switch-to-scratch-buffer)
(evil-leader/set-key "<RET>r" 'revert-buffer-with-coding-system) ;C-x<RET>r
(evil-leader/set-key "(" 'kmacro-start-macro) ;C-x(
(evil-leader/set-key ")" 'kmacro-end-macro) ;C-x
(evil-leader/set-key "ck" 'compile-dwim-compile)
(evil-leader/set-key "ca" 'org-agenda)
(evil-leader/set-key "cc" 'toggle-case-fold)
(evil-leader/set-key "," 'bm-previous)
(evil-leader/set-key "." 'bm-next)
(evil-leader/set-key "u" 'universal-argument)
(evil-leader/set-key "t" 'org-agenda)
(evil-leader/set-key "/" 'undo)
(evil-leader/set-key "$" 'toggle-truncate-lines)

(evil-leader/set-key "pr" 'publish-my-note-recent)
(evil-leader/set-key "pa" 'publish-my-note-all)
(evil-leader/set-key "pp" 'publish-my-note-local-preview)

;; (evil-leader/set-key "\\" 'just-one-space-or-delete-horizontal-space)
(define-key evil-normal-state-map "\\" 'just-one-space-or-delete-horizontal-space)

;; (define-key evil-normal-state-map ";" 'evil-repeat-find-char-or-evil-use-register)
;; (define-key evil-visual-state-map ";" 'evil-repeat-find-char-or-evil-use-register)
;; [;;yy]==["+yy] 将此行copy到clipboard
(define-key evil-motion-state-map ";" 'evil-repeat-find-char-or-evil-use-register)

;; http://wayback.archive.org/web/20150313145313/http://www.codejury.com/bypassing-the-clipboard-in-emacs-evil-mode/
(setq interprogram-paste-function nil)  ;当paste时是否从clipbloard等系统剪切板 等获取内容，设置成nil表示不获取，只使用kill-ring
;; (setq interprogram-cut-function #'gui-select-text)    ;默认当emacs 更新kill-ring时，会同时更新clipboard的值，这里改成nil 即不更新clipboard
;; gui-select-text 会同时考虑select-enable-clipboard 及select-enable-primary的值，故一般不需要将interprogram-cut-function设置成nil
(setq select-enable-clipboard   nil)    ;每一次往kill-ring 里加入东西时,是否同时往clipboard中放一份,
(setq select-enable-primary  nil) ;每一次往kill-ring 里加入东西时,是否也往primary 中放入

;; "+p 从系统剪切板paste时会调到此处
;; 如果在mac 终端下使用emacs ,则使用pbpaste从clipboard 获取内容
(defadvice gui-backend-get-selection (around get-clip-from-terminal-on-osx activate)
  ad-do-it
  (when (and (equal system-type 'darwin)
             (not (display-graphic-p))
             (not (window-system))
             (equal (ad-get-arg 0) 'CLIPBOARD))
    (let ((default-directory "~/"))
      (setq ad-return-value (shell-command-to-string "pbpaste")))))

;; "+yy 设置内容到系统clipboard
;; 如果在mac 终端下使用emacs ,则使用pbpaste从clipboard 获取内容
(defadvice gui-backend-set-selection (around set-clip-from-terminal-on-osx activate)
  ad-do-it
  ;; (message "%s %s"  (ad-get-arg 0)  (ad-get-arg 1))
  (when (and (equal system-type 'darwin)
             (not (display-graphic-p))
             (not (window-system))
             (equal (ad-get-arg 0) 'CLIPBOARD))
    (let ((process-connection-type nil)   ; ; use pipe
          (default-directory "~/"))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc (ad-get-arg 1))
        (process-send-eof proc)))))


(defun evil-paste-from-clipboard ()
  "Paste text from system clipboard."
  (interactive)
  (if (not  (string= major-mode "term-mode"))
      (evil-paste-from-register ?+)
    (require 'term)
    (term-send-raw-string (evil-get-register ?+))))

;; 这里参数跟evil-yank 完全相同， 只是函数里忽略了register 参数，而写死成?+,即使用系统clipboard
(evil-define-operator evil-yank-to-clipboard (beg end type register yank-handler)
  "Yank text to system clipboard."
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (evil-yank beg end type ?+ yank-handler))

(evil-define-operator evil-delete-to-clipboard (beg end type register yank-handler)
  "Delete text from BEG to END with TYPE.
Save in REGISTER or in the kill-ring with YANK-HANDLER."
  (interactive "<R><x><y>")
  (evil-delete beg end type ?+ yank-handler))

;; Y不常用故
(define-key evil-normal-state-map "Y" 'evil-yank-to-clipboard)
(define-key evil-motion-state-map "Y" 'evil-yank-to-clipboard)
(evil-leader/set-key "y" 'evil-yank-to-clipboard)

(when (equal system-type 'darwin)
  (global-set-key (kbd "s-c") 'evil-yank-to-clipboard) ;等同于 "+y
  (global-set-key (kbd "s-x") 'evil-delete-to-clipboard) ;等同于 "+d
  (global-set-key (kbd "s-v") 'evil-paste-from-clipboard)) ;等同于 "+p


;; 默认情况下普通的evil-paste-before，会move-back 一个字符，此defadvice向前move回去
(defadvice evil-paste-before (around no-move-back activate)
  (let* ((text (if register
                   (evil-get-register register)
                 (current-kill 0)))
         (yh  (or yank-handler
                  (when (stringp text)
                    (car-safe (get-text-property
                               0 'yank-handler text))))))
    ad-do-it
    (unless yh
      (evil-set-marker ?\] (point))
      (when (vectorp text)
        (setq text (evil-vector-to-string text)))
      (when (> (length text) 0)
        (forward-char)))))

;; (fset 'yank 'evil-paste-before)
(global-set-key (kbd "C-y") 'evil-paste-before)
;; ;; 交换p P
;; (define-key evil-normal-state-map "P" 'evil-paste-after)
;; (define-key evil-normal-state-map "p" 'evil-paste-before)

(defadvice evil-ex-search-next (after dotemacs activate)
  (recenter))

(defadvice evil-ex-search-previous (after dotemacs activate)
  (recenter))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key evil-ex-search-keymap "\C-w" 'evil-search-yank-word)
;; 默认情况下，对于光标下的内容，/的时候会跳过，此处不跳过
(defadvice evil-ex-start-search (around  go-back-one-char activate)
  "replace evil-ex-start-search"
  ;; store buffer and window where the search started
  (let ((evil-ex-current-buffer (current-buffer)))
    (setq evil-ex-search-count count
          evil-ex-search-direction direction
          evil-ex-search-start-point (point)
          evil-ex-last-was-search t)
    (progn
      ;; ensure minibuffer is initialized accordingly
      (add-hook 'minibuffer-setup-hook #'evil-ex-search-start-session)
      ;; read the search string
      (let* ((minibuffer-local-map evil-ex-search-keymap)
             (search-string
              (condition-case err
                  (minibuffer-with-setup-hook
                      #'evil-ex-search-setup
                    (read-string (if (eq evil-ex-search-direction 'forward)
                                     "/" "?")
                                 (and evil-ex-search-history
                                      (propertize
                                       (car evil-ex-search-history)
                                       'face 'shadow))
                                 'evil-ex-search-history))
                (quit
                 (evil-ex-search-stop-session)
                 (evil-ex-delete-hl 'evil-ex-search)
                 (goto-char evil-ex-search-start-point)
                 (signal (car err) (cdr err))))))
        ;; pattern entered successful
        (goto-char evil-ex-search-start-point) ;------changed only here
        ;; (goto-char (1+ evil-ex-search-start-point))
        (let* ((result
                (evil-ex-search-full-pattern search-string
                                             evil-ex-search-count
                                             evil-ex-search-direction))
               (success (pop result))
               (pattern (pop result))
               (offset (pop result)))
          (setq evil-ex-search-pattern pattern
                evil-ex-search-offset offset)
          (cond
           ((memq success '(t wrap))
            (goto-char (match-beginning 0))
            (setq evil-ex-search-match-beg (match-beginning 0)
                  evil-ex-search-match-end (match-end 0))
            (evil-ex-search-goto-offset offset)
            (evil-push-search-history search-string (eq direction 'forward))
            (unless evil-ex-search-persistent-highlight
              (evil-ex-delete-hl 'evil-ex-search)))
           (t
            (goto-char evil-ex-search-start-point)
            (evil-ex-delete-hl 'evil-ex-search)
            (signal 'search-failed (list search-string)))))))))

;; ;; 当搜索开始的时候，黑夜光标会跳过当前字符，此时后退一个字符，以便光标下的内容可以被搜到
;; 以方便evil-search-yank-word yank 光标下的内容
(defadvice evil-ex-search-update-pattern (around  go-back-one-char activate)
  (let ((evil-ex-search-start-point evil-ex-search-start-point))
    (when (equal evil-search-module 'evil-search)
      (if (equal evil-ex-search-direction 'forward)
          (setq evil-ex-search-start-point (1- evil-ex-search-start-point))
        ;; (setq evil-ex-search-start-point (1+ evil-ex-search-start-point))
        ))
    ad-do-it))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (fset 'evil-visual-update-x-selection 'ignore)

;; (defun evil-clipboard-config()
;;   (setq-local interprogram-cut-function nil)
;;   (setq-local interprogram-paste-function nil)
;;   (setq-local select-enable-clipboard   nil)
;; )
;; (add-hook 'evil-local-mode-hook 'evil-clipboard-config)

;; bug of osx interprogram-paste-function  interprogram-cut-function 与系统co
;; (define-key evil-normal-state-map (kbd "p") 'my-evil-paste-after)
;; (autoload 'evil-jk-to-normal-mode "joseph-evil-lazy")
;; (define-key  evil-insert-state-map "j" #'evil-jk-to-normal-mode)

 (require 'joseph-evil-symbol)


;; (require'joseph-evil-linum)

;; ;; 用两个字符来定位， 可取代默认的f F T t
;; (setq-default
;;  ;; evil-snipe-auto-disable-substitute nil ;do not change s S
;;  evil-snipe-enable-highlight nil
;;  evil-snipe-enable-incremental-highlight nil
;;  evil-snipe-scope 'buffer
;;  evil-snipe-repeat-scope 'buffer
;;  evil-snipe-override-evil t             ; ;Replace evil-mode's f/F/t/T/;/, with snipe.
;;  )
;; (require 'evil-snipe)
;; (global-evil-snipe-mode 1)

(provide 'joseph-evil)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-tmp.el ends here
