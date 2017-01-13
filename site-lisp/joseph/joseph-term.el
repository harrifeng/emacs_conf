(require 'term)
;;;###autoload
(defun multi-term-toggle-cd()
  (interactive)
  (multi-term-toggle t))

;;;###autoload
(defun multi-term-toggle(&optional make-cd)
  (interactive )
  (if  (or (string= major-mode 'term-mode)
            (string= major-mode "term-mode"))
      (bury-buffer)
    (let ((last-buf (last-term-buffer (buffer-list))))
      (if last-buf
          (let ((cd-command
                 ;; Find out which directory we are in (the method differs for
                 ;; different buffers)
                 (or (and make-cd
                          (buffer-file-name)
                          (file-name-directory (buffer-file-name))
                          (concat "cd " (file-name-directory (buffer-file-name))))
                     (and make-cd
                          list-buffers-directory
                          (concat "cd " list-buffers-directory)))))
            (switch-to-buffer last-buf)
            (when (and cd-command make-cd)
              (term-send-raw-string (concat  "\^U")) ;C-u clear,for zsh bindkey \^U backward-kill-line
              (term-send-raw-string (concat cd-command "\n"))))

        (call-interactively 'multi-term)))))
(defun last-term-buffer (l)
  "Return most recently used term buffer."
  (when l
    (if (eq 'term-mode (with-current-buffer (car l) major-mode))
        (car l) (last-term-buffer (cdr l)))))

(defun term-kill-auto-exit()
  (let ((p(get-buffer-process (current-buffer))))
    (when p
      (set-process-query-on-exit-flag p nil))))
;; (defun term-ctrl-d()                    ;delete char ,or exit if at end of buffer
;;   (interactive)
;;   (if (or (equal (line-number-at-pos) (line-number-at-pos (point-max)))
;;           (and (equal (line-number-at-pos) (1- (line-number-at-pos (point-max))))
;;                (string-equal "\n" (buffer-substring-no-properties (point) (point-max)))))
;;       (term-send-raw) ;ctrl-d
;;     (call-interactively 'delete-char)))

(defadvice keyboard-quit (before term-send-raw activate)
  "C-g back to normal state"
  (when (or (string= major-mode 'term-mode)
            (string= major-mode "term-mode"))
    (when (equal last-command 'keyboard-quit)
      (call-interactively 'term-send-raw))))


(defun term-ctrl-k(&optional arg)
  "this function is a wrapper of (kill-line).
   When called interactively with no active region, this function
  will call (kill-line) ,else kill the region."
  (interactive "P")
  (joseph-kill-region-or-line arg)
  (term-send-raw-string "\^K"))

(defadvice evil-paste-after (around paste-to-term activate)
  ad-do-it
  (when (or (string= major-mode 'term-mode)
            (string= major-mode "term-mode"))
    (term-send-raw-string (evil-get-register ?\" t)))) ; evil 所有的操作yank/delete/等都会把内容放到 "寄存器中

(defadvice evil-paste-before (around paste-to-term activate)
  ad-do-it
  (when (or (string= major-mode 'term-mode)
            (string= major-mode "term-mode"))
    (term-send-raw-string (evil-get-register ?\" t)))) ;evil 所有的操作yank/delete/等都会把内容放到 "寄存器中

;; term有两种模式 一种是像普通emacs 的buffer 方便copy，一种是纯terminal。
;; 比如是否允许用Ctrl-d 在非末行删除字符
(defun my-term-toggle-mode ()
  "Toggles term between line mode and char mode"
  (interactive)
  (if (term-in-line-mode)
      (term-char-mode)
    (term-line-mode)))

;; "进入term 输入命令模式"
(defun evil-insert-state-term-char-mode ()
  (when (and (or (string= major-mode 'term-mode)
                 (string= major-mode "term-mode"))
             (get-buffer-process (current-buffer)))
    (when (term-in-line-mode) (term-char-mode))))
(add-hook 'evil-insert-state-entry-hook 'evil-insert-state-term-char-mode)

;; 进入方便编辑buffer的模式
(defun evil-normal-state-term-char-mode ()
  (when  (and (or (string= major-mode 'term-mode)
                  (string= major-mode "term-mode"))
              (get-buffer-process (current-buffer)))
    (when (term-in-char-mode)
      (term-line-mode))))
(add-hook 'evil-normal-state-entry-hook 'evil-normal-state-term-char-mode)




(with-eval-after-load 'multi-term
  ;; . 如果你使用的是mac系统，发现multi-term每行出出了4m，在shell里运
  ;;  行下：tic -o ~/.terminfo  /Applications/Emacs.app/Contents/Resources/etc/e/eterm-color.ti
  ;;  Use Emacs terminfo, not system terminfo, mac系统出现了4m
  (setq system-uses-terminfo nil)
  (add-hook 'term-exec-hook 'term-kill-auto-exit)
  (setq multi-term-buffer-name "mterm")  ;; 设置buffer名字ls
  (add-to-list 'term-bind-key-alist '("<SPC>"))
  (add-to-list 'term-bind-key-alist '("C-g"))
  (setq multi-term-dedicated-select-after-open-p t)
  (setq multi-term-dedicated-close-back-to-open-buffer-p t)
  (setq multi-term-dedicated-window-height 30)
  (setq multi-term-dedicated-max-window-height 30)
  (setq term-buffer-maximum-size 10000)
  (add-to-list 'term-bind-key-alist '("C-M-p" . multi-term-prev))
  (when (equal system-type 'darwin) (add-to-list 'term-bind-key-alist '( "s-t" . multi-term)))
  (add-to-list 'term-bind-key-alist '("C-M-n" . multi-term-next))
  (add-to-list 'term-bind-key-alist '("C-c C-k" . my-term-toggle-mode))
  (add-to-list 'term-bind-key-alist '([(meta backspace)] . term-send-backward-kill-word)) ;M-backspace
  (add-to-list 'term-bind-key-alist '( "\^[\^?" . term-send-backward-kill-word)) ;M-backspace on terminal


  (add-to-list 'term-bind-key-alist '( "C-[ [ a a" . term-send-backward-kill-word)) ;== "M-[ a a" iterm2 map to ctrl-backspace

  (add-to-list 'term-bind-key-alist '("C-k" . term-ctrl-k))


  (add-to-list 'term-bind-key-alist '("M-c" . multi-term))
  (add-to-list 'term-unbind-key-list "C-a")
  (add-to-list 'term-unbind-key-list "C-e")
  ;; (add-to-list 'term-unbind-key-list "C-[ [ a b")
  ;; (add-to-list 'term-unbind-key-list "C-d")
  (add-to-list 'term-unbind-key-list "C-k")
  )


(provide 'joseph-term)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-term.el ends here
