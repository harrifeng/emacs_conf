
;;; Code:


;;关于剪切板: X共享信息的有 clipboard primary secondary 三个区域
;;其中clipboard 就是我们常说的剪切板,而primary 就是常说的selection ,也就是说只要你选中一段内容,
;;那么这段内容就被存到primary 中了,而secondary 目前好像已经不推荐使用了,所以不用考虑
;;而emacs 默认存在内容的区域不是上面任何一个,它叫kill-ring叫剪切环,它能存储不只一份内容,
;;C-y 会取出kill-ring 中最近的一份内容,然后paste(专业点叫yank)到buffer 中,可以通过M-y
;;取得以前的版本

(defun setting-for-linux-x-clipboard (&optional frame)
  (when (and (eq system-type 'gnu/linux)(eq (window-system frame) 'x))
    ;;在向kill-ring 加入内容的同时会执行interprogram-cut-function 变量指定的函数
    (setq-default interprogram-cut-function 'gui-select-text);; default
    ;;在执行yank 操作时,会检查interprogram-paste-function 变量 所指向的函数
    ;;是否有返回值,如果有的话就将其yank在buffer 中,否则的话才会从kill-ring中取值
    ;;而x-cut-buffer-or-selection-value  和x-select-text函数一样,
    ;;也会根据x-select-enable-clipboard 和x-select-enable-primary 的值
    ;;决定是否从clipboard 和primary 中取得内容
    ;; (setq-default interprogram-paste-function 'x-cut-buffer-or-selection-value)
    ;;有关于往kill-ring加入内容时 是否往clipboard ,及primary 放入的判断
    (setq-default select-enable-clipboard t) ;每一次往kill-ring 里加入东西时,同时往clipboard中放一份,
    (setq-default select-enable-primary  nil) ;每一次往kill-ring 里加入东西时,是否也往primary 中放入
    (setq-default select-active-regions  t);这个忘了什么意思
    ;;在轮询kill-ring 的时候是否也同步改变系统的clipboard primary
    ;;(要根据x-select-enable-clipboard ,及x-select-enable-primary的值决定哪个会被改变)
    (setq-default yank-pop-change-selection t)  ;
    ;;Save clipboard strings into kill ring before replacing them
    (setq-default save-interprogram-paste-before-kill t)

    ;; make mouse middle-click only paste from primary X11 selection, not clipboard and kill ring.
    ;;鼠标中键粘贴,只考虑X11中的selection ,不考虑clipboard 和emacs 中的kill-ring
    (global-set-key [mouse-2] 'mouse-yank-primary)
    ;;其实有了以上几个配置 下面这三个键完全没有必要,但为防万一,
    ;;将与剪切板相关的三个操作绑到这三个不常用的键上.
    (global-set-key [(shift delete)] 'clipboard-kill-region)
    (global-set-key [(control insert)] 'clipboard-kill-ring-save)
    (global-set-key [(shift insert)] 'clipboard-yank)
    )
  )

;; (defun setting-faces-4-linux( &optional frame)
;;   (cond
;;    ((eq (window-system frame) 'x) ;;针对linux下X的设置
;;     (menu-bar-mode -1);;关闭菜单栏
;;     (tool-bar-mode -1);;关闭工具栏
;;     )
;;    ((eq (window-system frame) nil);;linux文本模式下的设置
;;     (menu-bar-mode -1)
;;     (tool-bar-mode -1)
;;     )
;;   ))
;;在daemon下，不起作用
;; (defun joseph-setting-4-C-iC-m-map( &optional frame)
;;   ;; 默认Emacs 把TAB==`C-i'
;;   ;;            RET==`C-m'
;;   ;;            ESC==`C-['
;;   ;;这样可以进行绑定的键好像少了一些,
;;   ;;下面的方法可以实现将`C-i' `C-m'绑定与`TAB' `RET'不同的func
;;   ;;不过只在Gui下有用
;;   ;;(when (or window-system (daemonp))
;;   (keyboard-translate ?\C-i ?\H-i)
;;   (keyboard-translate ?\C-m ?\H-m)
;;   (global-set-key [?\H-m] 'backward-char);C-m
;;   ;;  (global-set-key [?\H-i] 'delete-backward-char) ;C-i
;;   ;;  )
;;   (global-set-key "\C-m" 'newline-and-indent)
;;   )
(defun joseph-make-frame-func( &optional frame)
  (setting-for-linux-x-clipboard frame)
  ;; (setting-faces-4-linux frame)
;;  (joseph-setting-4-C-iC-m-map frame)
  )

;; 如果在.emacs里对X相关的选项（字体什么的）直接进行设置，那么会发现用emacsclient启动时，这些设置都失效了。
;; 这是因为这些设置是在X下的frame创建时才有效的，而启动服务器的时候是没有创建frame的。
;; 解决方法有两种，一种是使用after-make-frame-functions这个hook，在创建一个frame之后才进行设置。代码如下
(add-hook 'after-make-frame-functions 'joseph-make-frame-func t)
(joseph-make-frame-func)

(defun etc-confd-find-file()
  (when (string-match  "/etc/conf\.d" (buffer-file-name))
    (sh-mode)
    ))

(add-hook 'find-file-hook 'etc-confd-find-file)

(provide 'joseph-linux)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-linux.el ends here
