;; -*- coding:utf-8 -*-
;; eval-when-compile
(eval-when-compile
  (progn
    (add-to-list 'load-path  (expand-file-name "~/.emacs.d/site-lisp/"))
    (require   'joseph-util)
    (require  'ediff)
    (require  'vc-hooks)
    (require  'log-edit)
    (require  'org)
    (require  'term)
    (require  'helm)
    (require  'ibuffer)
    (require  'log-view)
    ;; (require 'semantic)
    ;; (require 'semantic-tag-ls)
    (require 'hippie-exp)
    ))

;; ;;;###autoload
;; (defun goto-match-paren (arg)
;;   "Go to the matching paren if on a paren; otherwise insert %."
;;   (interactive "p")
;;   (cond ((looking-at "\\s\(") (forward-list 1) )
;;         ((looking-back "\\s\)")  (backward-list 1))
;;         ((looking-at "\\s\{") (forward-list 1) )
;;         ((looking-back "\\s\}") (forward-char 1))
;;         (t (self-insert-command (or arg 1)))))

;; ;;;###autoload
;; (defun joseph-join-lines(&optional arg)
;;   (interactive "*p")
;;   (end-of-line)
;;   (delete-char  1)
;;   (just-one-space)
;;   (when (looking-back "[ \t]*" (point-at-bol) t)
;;     (goto-char (match-beginning 0)))
;;   )

;;;###autoload
(defun open-line-or-new-line-dep-pos()
  "binding this to `C-j' if point is at head of line then
open-line if point is at end of line , new-line-and-indent"
  (interactive)
  (let ((pos))
    (if (or (and (= (point) (point-at-bol))
                 (not (looking-at "^[ \t]*$")))
            (looking-back "^[ \t]*" (point-at-bol)))
        (progn
          (open-line 1)
          (indent-for-tab-command)
          (setq pos (point))
          (forward-line)
          (indent-for-tab-command)
          (goto-char pos))
      (when (member last-command '(evil-open-line-or-new-line-dep-pos
                                   move-end-of-line
                                   evil-move-end-of-line
                                   smart-end-of-line))
        (end-of-line))
      (newline-and-indent))))

;;;###autoload
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.
Move point to beginning-of-line ,if point was already at that position,
  move point to first non-whitespace character. "
  (interactive)
  (if (and (string= major-mode "term-mode") (equal (line-number-at-pos)  (count-lines (point-min) (point-max))))
      (term-send-raw)
    (let ((oldpos (point)))
      (beginning-of-line)
      (and (= oldpos (point))
           (back-to-indentation) ))))

;;;###autoload
(defun org-mode-smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.
Move point to beginning-of-line ,if point was already at that position,
  move point to first non-whitespace character. "
  (interactive)
  (let ((oldpos (point)))
    (org-beginning-of-line)
    (and (= oldpos (point))
         (back-to-indentation) )))

;;;###autoload
(defun smart-end-of-line(&optional arg)
  "like `org-end-of-line' move point to
   virtual end of line
or Move point to end of line (ignore white space)
or end-of-line.
Move point to end-of-line ,if point was already at end of line (ignore white space)
  move point to end of line .if `C-u', then move to end of line directly."
  (interactive "^P")
  (if (and (string= major-mode "term-mode") (equal (line-number-at-pos)  (count-lines (point-min) (point-max))))
      (term-send-raw)
    (if arg
        (end-of-line)
      (let ((oldpos (point))
            (new-pos)
            )
        (beginning-of-line)
        (if (re-search-forward "[ \t]*$" (point-at-eol) t 1)
            (setq new-pos  (match-beginning 0))
          (setq new-pos (point-at-eol))
          )
        (when (= oldpos new-pos)
          (setq new-pos (point-at-eol))
          )
        (when (> new-pos (+ (frame-width) oldpos))
          (setq new-pos (+ (frame-width) oldpos)))
        (goto-char new-pos)
        )
      )
    )
  )

;;;###autoload
(defun org-mode-smart-end-of-line()
  "Move point to first non-whitespace character or end-of-line.
Move point to end-of-line ,if point was already at that position,
  move point to first non-whitespace character."
  (interactive)
  (let ((oldpos (point)))
    (org-end-of-line)
    (if  (equal (point-at-eol) (point))
      (progn
        (beginning-of-line)
        (when (re-search-forward "[ \t]*$" (point-at-eol) t)
          (goto-char (match-beginning 0)))
        )
      (when (equal oldpos (point))
        (end-of-line)
        )
      )
    ))

;;;###autoload
;; (defun kill-syntax-forward ()
;;   "Kill characters with syntax at point."
;;   (interactive)
;;   (kill-region (point)
;;                (progn (skip-syntax-forward (string (char-syntax (char-after))))
;;                       (point))))
;;;###autoload
;; (defun kill-syntax-backward ()
;;   "Kill characters with syntax at point."
;;   (interactive)
;;   (kill-region (point)
;;                (progn (skip-syntax-backward (string (char-syntax (char-before))))
;;                       (point))))

;; ;;;###autoload
;; (defun joseph-jump-to-space-forward()
;;   (interactive)
;;   (let ((old-pos (point))
;;         m-end m-begin
;;         )
;;     (when (re-search-forward "[ \t]+"  nil t)
;;       (setq m-begin (match-beginning 0))
;;       (setq m-end (match-end 0))
;;       (goto-char m-begin)
;;       (if (equal old-pos m-end)
;;           (progn
;;             (re-search-forward "[ \t]+"  nil t)
;;             (goto-char (match-beginning 0)))
;;         (if (equal m-begin old-pos)
;;             (goto-char m-end)
;;             )))))


;;;###autoload
(defun switch-to-scratch-buffer ()
  "Toggle between *scratch* buffer and the current buffer.
     If the *scratch* buffer does not exist, create it."
  (interactive)
  (let ((scratch-buffer-name  "*scratch*")
        (prev-major-mode major-mode)
        )
    (if (equal (buffer-name (current-buffer)) scratch-buffer-name)
        (switch-to-buffer (other-buffer))
      (with-current-buffer
          (switch-to-buffer  scratch-buffer-name)
        ;; (when (functionp prev-major-mode) (funcall prev-major-mode ))
        (when (equal major-mode 'fundamental-mode )(emacs-lisp-mode))
        (goto-char (point-max))))))


;; ;;;###autoload
;; (defun move-backward-paren()
;;   (interactive)
;;   (re-search-backward "\\s[\\|\\s(\\|\\s{" nil t)
;;   )

;; ;;;###autoload
;; (defun move-forward-paren()
;;   (interactive)
;;   (re-search-forward "\\s]\\|\\s)\\|\\s}" nil t)
;;   )


;;;;;###autoload
;; (defun query-stardict ()
;;   "Serch dict in stardict."
;;   (interactive)
;;   (let ((begin (point-min))
;;         (end (point-max)))
;;     (if mark-active
;;         (setq begin (region-beginning)
;;               end (region-end))
;;       (save-excursion
;;         (backward-word)
;;         (mark-word)
;;         (setq begin (region-beginning)
;;               end (region-end))))
;;     (message "searching  %s ... using stardicr" (buffer-substring begin end))
;;     (shell-command "notify-send \"`sdcv -n -u '朗道英汉字典5.0' %s`\"" (buffer-substring begin end) )
;;     (message "finished searching  朗道英汉字典5.0'")
;;     ))

;;;###autoload
(defun sdcv-to-buffer ()
  "Search dict in region or world."
  (interactive)
  (let* ((word (if mark-active
                   (buffer-substring-no-properties (region-beginning) (region-end))
                 (current-word nil t)))
         (buf-name (buffer-name))
         (mp3-file (concat "/usr/share/OtdRealPeopleTTS/" (downcase (substring word 0 1 )) "/" word ".mp3"))
         )
    ;; (setq word (read-string (format "Search the dictionary for (default %s): " word)
    ;;                         nil nil word))
    (set-buffer (get-buffer-create "*sdcv*"))
    (buffer-disable-undo)
    (erase-buffer)
    (when (file-exists-p mp3-file)(shell-command (concat "mpg123 "  mp3-file " >/dev/null 2>/dev/null")))
    (insert (shell-command-to-string  (format "sdcv --data-dir %s --utf8-input --utf8-output -n %s " (expand-file-name "~/.emacs.d/bin/sdcv/dic/")  word)))
    ;;
    (if (equal buf-name "*sdcv*")
        (switch-to-buffer "*sdcv*")
      (pop-to-buffer "*sdcv*" t nil))
    (goto-char (point-min))
    ))

;; (shell-command "notify-send \"`sdcv -n  %s`\"" (buffer-substring begin end))
;; (tooltip-show
;;      (shell-command-to-string
;;       (concat "sdcv -n "
;;               (buffer-substring begin end))))

;;只留光标处一个空格或者删除所有空格(按一次与按两次效果不同)
;;;###autoload
(defun just-one-space-or-delete-horizontal-space()
  "just one space or delete all horizontal space."
  (interactive)
  (if (equal last-command 'just-one-space-or-delete-horizontal-space)
      (delete-horizontal-space)
    (just-one-space)
    )
  (message "just-one-space or delete-horizontal-space(if press twice)")
  )

;; (defsubst at-term-end-of-line()            ;跳过后面的空格等，判断是否在最后一行
;;   (let ((p (point)) e)
;;     (goto-char (point-max))
;;     (when (re-search-backward "[ \t]+\\|\n" nil 'move 1)
;;       (goto-char (match-beginning 0))) ;skip space
;;     (setq e (equal (line-number-at-pos p)(line-number-at-pos )))
;;     (goto-char p)                       ;go back to init pos
;;     e))

;;我写的一个函数,如果有选中区域,则kill选区,否则删除当前行
;;注意当前行并不代表整行,它只删除光标到行尾的内容,也就是默认情况下
;;C-k 所具有的功能
;;;###autoload
(defun joseph-kill-region-or-line(&optional arg)
  "this function is a wrapper of (kill-line).
   When called interactively with no active region, this function
  will call (kill-line) ,else kill the region."
  (interactive "P")
  (if mark-active
      (if (= (region-beginning) (region-end) ) (kill-line arg)
        (kill-region (region-beginning) (region-end) )
        )
    (kill-line arg)
    )
  )
;; (if (and (string= major-mode "term-mode")(at-term-end-of-line))
;;         (term-send-raw-string (concat  "\^k")) ;ctrl-k

;;       )
;;;###autoload
(defun joseph-kill-region-or-org-kill-line(&optional arg)
  "this function is a wrapper of (kill-line).
   When called interactively with no active region, this function
  will call (kill-line) ,else kill the region."
  (interactive "P")
  (if mark-active
      (if (= (region-beginning) (region-end) ) (org-kill-line arg)
        (kill-region (region-beginning) (region-end) )
        )
    (org-kill-line arg)
    )
  )
;; ;;;;(global-unset-key "\C-w")  ;C-k 现在完全具有C-w的功能, 所以取消C-w的键定义
;; (defvar joseph-trailing-whitespace-modes '(c++-mode c-mode haskell-mode emacs-lisp-mode scheme-mode erlang-mode))
;; ;;;###autoload
;; (defun joseph-trailing-whitespace-hook ()
;;   (when (member major-mode joseph-trailing-whitespace-modes)
;;     (delete-trailing-whitespace)))

;; (defvar joseph-untabify-modes '(haskell-mode lisp-mode scheme-mode erlang-mode clojure-mode java-mode ))

;; ;;;###autoload
;; (defun joseph-untabify-hook ()
;;   (when (member major-mode joseph-untabify-modes)
;;     (untabify (point-min) (point-max))))

(autoload 'server-edit "server")
;;;###autoload
(defun kill-buffer-or-server-edit()
  (interactive)
  (message "kill buffer %s" (buffer-name))
  (when (equal (buffer-name) "*scratch*")
    (copy-region-as-kill (point-min)(point-max)))
  (if (and (featurep 'server) server-buffer-clients)
      (server-edit)
    (kill-this-buffer)
    )
  )

(autoload 'hippie-expand "hippie-exp" nil t)
(autoload 'indent-according-to-mode "indent" nil t)

(defun term-complete-tab()
  (interactive)
  ;; (require 'term)
  (term-send-raw-string "\t")
)
(defvar smart-tab-completion-functions
  '((emacs-lisp-mode helm-lisp-completion-at-point)
    (python-mode jedi:complete)
    (magit-status-mode magit-section-toggle)
    (magit-mode magit-section-toggle)
    (magit-process-mode magit-section-toggle)
    (term-mode term-complete-tab)
    ;; (org-mode novel-fill)
    (novel-mode novel-fill)
    (text-mode novel-fill)
    (help-mode forward-button)
    (nxml-mode nxml-complete)
    (objc-mode company-complete)
    (go-mode auto-complete))
  "List of major modes in which to use a mode specific completion
  function.")

(defvar smart-tab-mode-for-indent-tab-mode
'(applescript-mode))

(defun get-completion-function()
  "Get a completion function according to current major mode."
  (let ((completion-function
         (second (assq major-mode smart-tab-completion-functions))))
    (if (null completion-function)
        'hippie-expand

      completion-function)))


;;;###autoload
(defun smart-tab (&optional arg)
  (interactive "P")
  (cond
   ;; (looking-at "\\_>") at end of symbol
   ;; (looking-at "\\>") at end of word
   ((and (not buffer-read-only)
         (not (member major-mode '(term-mode org-mode novel-mode text-mode)))
         (or (looking-back "^[ \t]*")        ;at bol 在行首 不适合补全
             (looking-back (string-trim (concat comment-start ".*"))) ;前面是注释 不适合补全
             (and (looking-at "[ \t]*$")        ;at eol
                  (or (looking-back "[,;)}]")   ;前面是,;)} 几种符号 ，则不适全补全
                      (looking-back "]")        ;前面是] 也不适全补全
                      ))))
    (if (and mark-active )
        (indent-region (region-beginning) (region-end))

      (if (or indent-tabs-mode
              (or (member major-mode smart-tab-mode-for-indent-tab-mode)))
          (call-interactively 'indent-for-tab-command)
        (call-interactively 'indent-according-to-mode))))
   (t
    ;; Hippie also expands yasnippets, due to `yas-hippie-try-expand' in
    ;; `hippie-expand-try-functions-list'.
    (call-interactively (get-completion-function))
    )))


;;让hipperextend不仅可以匹配开头,也可以匹配字符串的内部
;;将这个函数加入到hippie-expand-try-functions-list中，
;;;###autoload
(defun try-joseph-dabbrev-substring (old)
  (let ((old-fun (symbol-function 'he-dabbrev-search)))
    (fset 'he-dabbrev-search (symbol-function 'joseph-dabbrev-substring-search))
    (unwind-protect
        (try-expand-dabbrev old)
      (fset 'he-dabbrev-search old-fun))))

(defun joseph-dabbrev-substring-search (pattern &optional reverse limit)
  (let ((result ())
        (regpat (cond ((not hippie-expand-dabbrev-as-symbol)
                       (concat (regexp-quote pattern) "\\sw+"))
                      ((eq (char-syntax (aref pattern 0)) ?_)
                       (concat (regexp-quote pattern) "\\(\\sw\\|\\s_\\)+"))
                      (t
                       (concat (regexp-quote pattern)
                               "\\(\\sw\\|\\s_\\)+")))))
    (while (and (not result)
                (if reverse
                    (re-search-backward regpat limit t)
                  (re-search-forward regpat limit t)))
      (setq result (buffer-substring-no-properties (save-excursion
                                                     (goto-char (match-beginning 0))
                                                     (skip-syntax-backward "w_")
                                                     (point))
                                                   (match-end 0)))
      (if (he-string-member result he-tried-table t)
          (setq result nil)))     ; ignore if bad prefix or already in table
    result))


;; 在当前行任何位置输入分号都在行尾添加分号，除非本行有for 这个关键字，
;; 如果行尾已经有分号则删除行尾的分号，将其插入到当前位置,就是说输入两次分号则不在行尾插入而是像正常情况一样.
;;;###autoload
(defun joseph-append-semicolon-at-eol(&optional arg)
  (interactive "*p")
  (let* ( ( init_position (point))
          (b (line-beginning-position))
          (e (line-end-position))
          (line_str (buffer-substring b e))
          (semicolon_end_of_line (string-match ";[ \t]*$" line_str ))
          )
    (if semicolon_end_of_line ;;;;如果行尾已经有分号，则删除行尾的分号，并在当前位置输入分号;;;;;;
        (progn
          (save-excursion
            (goto-char (+ semicolon_end_of_line b))
            (delete-char 1) )
          (insert ";") )
      ;;在整行内容中搜索有没有关键字for的存在,或者当前位置已经是行尾,直接插入分号
      (if   (or (string-match "^[ \t]*$" (buffer-substring init_position e))
                (string-match "\\bfor\\b" line_str))
          (insert ";")
        (save-excursion ;;如果搜索不到 for 则在行尾插入分号;
          (end-of-line)
          (delete-trailing-whitespace)
          (insert ";")
          )))))

;; ;;;###autoload
;; (defun joseph-hide-frame()
;;   "hide current frame"
;;   (interactive)
;;   (make-frame-invisible nil t))

;; ;;;###autoload
;; (defun scroll-other-window-up-or-previous-buffer(&optional ARG)
;;   "if there is an `other-window' ,then scroll it up ,if
;;  not ,call (previous-buffer)"
;;   (interactive)
;;   (if (equal 1 (length (window-list nil nil))) ;;if don't exist other window
;;       (previous-buffer)
;;     (scroll-other-window ARG)
;;       ))

;; ;;;###autoload
;; (defun scroll-other-window-down-or-next-buffer(&optional lines)
;;   "if there is an `other-window' ,then scroll it down ,if
;;  not ,call (next-buffer)"
;;   (interactive)
;;   (if (equal 1 (length (window-list nil nil))) ;;if don't exist other window
;;       (next-buffer)
;;     (scroll-other-window-down  lines)
;;     ))

;;;###autoload
(defun joseph-forward-4-line() (interactive) (forward-line 4) (scroll-up   4))
;;;###autoload
(defun joseph-backward-4-line() (interactive) (forward-line -4)(scroll-down 4))

;;代码注释工作，如果有选中区域，则注释或者反注释这个区域
;;如果，没选中区域，则注释或者注释当前行，如果光标在行末，则在行末添加或删除注释
;;;###autoload
(defun joseph-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

;; ;;;###autoload
;; (defun joseph-goto-line-by-percent ()
;;   (interactive)
;;   (let ((readed-string (read-from-minibuffer "Goto line( by percent): "))(percent) )
;;     (if (string-match "^[ \t]*\\([0-9]+\\)[ \t]*$" readed-string )
;;         (let* ((total (count-lines (point-min) (point-max))) (num ))
;;           (setq percent  (string-to-number (match-string-no-properties 1 readed-string)))
;;           (setq num (round (* (/ total 100.0) percent)))
;;           (goto-char (point-min) )
;;           (forward-line (1- num)) )
;;       ))
;;   )

;; ;; date命令插入当前时间
;; ;;;###autoload
;; (defun date ()
;;   "Insert a nicely formated date string."
;;   (interactive)
;;   (insert (format-time-string "%Y-%m-%d %H:%M")))
;;
;; "run ediff with marked buffer in ibuffer mode
;; 如果有两个marked 的buffer,对这两个进行ediff ,默认在merge 模式,
;; `C-u'的话,即普通的ediff,不进行merge
;; 如果是mark了三个buffer ,则会让你选哪一个是ancestor(祖先),然后进行三方合并
;; `C-u'的话,不进行合并,仅进行三方合并"
;;;###autoload
(defun ibuffer-ediff-merge(&optional arg)
  (interactive "P")
  (let ((marked-buffers  (ibuffer-marked-buffer-names))
        ancestor
        )
    (cond ((= (length marked-buffers) 2)
           (if arg
               (ediff-buffers (car marked-buffers) (nth 1 marked-buffers))
             (ediff-merge-buffers  (car marked-buffers) (nth 1 marked-buffers)))
           )
          ((= (length marked-buffers) 3)
           (setq ancestor (completing-read
                           "which is ancestor (for  Ediff 3 merge):" marked-buffers
                           nil nil nil nil (last marked-buffers)))
           (setq marked-buffers (delete ancestor marked-buffers))
           (if arg
               (ediff-buffers3 (car marked-buffers )(nth 1 marked-buffers) ancestor)
             (ediff-merge-buffers-with-ancestor (car marked-buffers )(nth 1 marked-buffers) ancestor)))
          (t (call-interactively 'ediff-buffers))
          )))

;;;###autoload
(defun bury-buffer-and-window()
  "bury buffer and window"
  (interactive)
  (bury-buffer)
  (when (< 1 (count-windows))
    (delete-window)))

;;;###autoload
(defun keyboard-quit-or-bury-buffer-and-window()
  "C-gC-g (bury buffer and window)"
  (interactive)
  (if (equal last-command 'keyboard-quit)
      (bury-buffer-and-window)
    (setq this-command 'keyboard-quit)
    (call-interactively 'keyboard-quit)
    )
  )

;; ;;;###autoload
;; (defun toggle-menu-bar-tool-bar()
;;   "toggle menu-bar and tool-bar"
;;   (interactive)
;;   (if menu-bar-mode
;;       (progn
;;         (menu-bar-mode 0)
;;         (tool-bar-mode 0)
;;         )
;;     (menu-bar-mode 1)
;;     (tool-bar-mode 1)
;;     )
;;   )

;;;###autoload
(defun minibuffer-quit ()
  "Quit the minibuffer command, even when the minibuffer loses focus."
  (interactive)
  (when (active-minibuffer-window)
    (save-window-excursion
      (select-window (minibuffer-window))
      (keyboard-escape-quit))))

;;;###autoload
(defun minibuffer-refocus ()
  "Refocus the minibuffer if it is waiting for input."
  (interactive)
  (when (active-minibuffer-window)
    (message "") ;; clear the echo area, in case it overwrote the minibuffer
    (select-window (minibuffer-window))))

;convert a buffer from dos ^M end of lines to unix end of lines
;;;###autoload
(defun dos2unix ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t)
    (replace-match "")))

;;;###autoload
(defun unix2dos ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t)
    (replace-match "\r\n")))

;;;###autoload
(defun joseph_compile_current_el_outside()
  (when (buffer-file-name)
    (let ((command (format  " emacs  -batch    -l %s -f batch-byte-compile %s "
                            (expand-file-name "~/.emacs.d/site-lisp/joseph/joseph_byte_compile_include.el")
                            (buffer-file-name))))
      (with-current-buffer (get-buffer-create "*joseph_compile_current_el*")
        (insert (shell-command-to-string command)))
      (switch-to-buffer (get-buffer-create "*joseph_compile_current_el*")))
    )
  )
;;;###autoload
(defun golang-setter-getter(beg end)
  "generate sets and gets for golang."
  (interactive "r")
  (require 'joseph-camelize)
  (let ((region-string (buffer-substring-no-properties beg end))
        (struct-name)
        (pairs)
        (buf-str))
    (with-temp-buffer
      (modify-syntax-entry ?< "w" )
      (modify-syntax-entry ?> "w" )
      (insert region-string) (insert "\n")
      (goto-char (point-min))
      (when (re-search-forward "type \\(.*\\) struct" (point-max) t)
        (setq struct-name (match-string 1))
        (message struct-name)
        (forward-line)(beginning-of-line)
        (while (re-search-forward "\\([a-zA-Z0-9_]+\\)[ \t]+\\([a-zA-z0-9_.]+\\)\\b" (point-at-eol) t)
          (setq pairs (append pairs (list (list (match-string 1)(match-string 2)))))
          (forward-line) (beginning-of-line)
          )
        (erase-buffer)
        (dolist (pair pairs)
          (insert (format "func (this *%s) Set%s(value %s) {\n" struct-name (upcase-first-char(car pair)) (nth 1 pair)) )
          (insert (format "    this.%s = value\n" (car pair)) )
          (insert (format "}\n" (car pair)) )
          (insert (format "func (this %s) Get%s() %s {\n" struct-name (upcase-first-char(car pair)) (nth 1 pair)) )
          (insert (format "    return this.%s\n" (car pair)) )
          (insert (format "}\n" (car pair)) )
          )
        (setq buf-str (buffer-string))))
    (goto-char end)
    (insert "\n")
    (insert buf-str)
    )
  )
;;;###autoload
(defun protobuf-indent-align(begin end &optional column)
  "do indent and align for protobuf.
bind`indent-region-function' to this function in protobuf-hook"
  (interactive "r")
  (save-excursion
    (let (end-marker
          (keyword-regexp (rx (or "required" "optional" "repeated"))))
      (unless mark-active
        (setq begin (point-min))
        (setq end (point-max)))
      (goto-char end)
      (setq end-marker (point-marker))
      (c-indent-region begin (marker-position end-marker))
      (while (re-search-backward "^message[ \t]+[a-zA-Z0-9_-]+[ \t]*{[ \t]*\\(//\\)?" begin t)
        (let ((max-type-column 0)
              message-end message-beginning)
          (goto-char (point-at-bol))
          (setq message-beginning (point-marker))
          (c-end-of-defun)
          (setq message-end (point-marker))
          (while (re-search-backward keyword-regexp (marker-position message-beginning) t)
            (forward-word 2)
            (when (> (current-column) max-type-column)
              (setq max-type-column (current-column)))
            (goto-char (point-at-bol)))
          (goto-char (marker-position message-end))
          (while (re-search-backward keyword-regexp (marker-position message-beginning) t)
            (forward-word )
            (just-one-space)
            (forward-word )
            (delete-horizontal-space)
            (insert (make-string (1+ (- max-type-column (current-column))) ? ))
            (goto-char (point-at-bol)))
          (align-regexp (marker-position message-beginning) (marker-position message-end) "\\(\\s-*\\)=") ;align for =
          ;; (align-regexp (marker-position message-beginning) (marker-position message-end) "\\(\\s-*\\)//") ;align for //
          (goto-char (marker-position message-beginning))))
      (goto-char (marker-position end-marker))
      (while (re-search-backward "\\(=\\)[ \t]*[0-9]+[ \t]*;" begin t)
        (goto-char (match-end 1))
        (just-one-space)                ;make sure one space after =
        (goto-char (match-end 0))
        (if (looking-at "[ \t]*//")
            (just-one-space)
          (delete-horizontal-space))
        (goto-char (point-at-bol))))))

;;;###autoload
(defun cd-iterm2()
  (interactive)
  (let ((cmd (format "tell application \"iTerm\"
    activate
    if (count of windows) = 0 then
        set w to (create window with default profile)
    else
        set w to current window
    end if
    tell w
        create tab with default profile
        tell current session of w
            set cmd to \"cd \" & quote & \"%s\" & quote & \";clear\"
            -- do script with command cmd
            write text cmd
            -- exec command (cmd)
        end tell

    end tell
end tell" (expand-file-name default-directory))))
    (start-process "cd-iterm2" nil "osascript" "-e" cmd)))

(defun toggle-case-fold()
  (interactive)
  (if case-fold-search
      (progn
        (setq
         helm-case-fold-search nil ;nil=case sensitive
         case-fold-search nil ;nil=case sensitive
         evil-ex-search-case 'sensitive)
        (message "case sensitive"))
    (setq
     helm-case-fold-search t ;nil=case sensitive
     case-fold-search t ;nil=case sensitive
     evil-ex-search-case 'insensitive)
    (message "case insensitive")))
;;;###autoload
;; http://eastmanreference.com/complete-list-of-applescript-key-codes/
;; 15 =R
;; 11=B
(defun xcode:build-and-run()
  (interactive)
  (let ((cmd  "tell application \"Xcode\" to activate
tell application \"System Events\"
tell process \"Xcode\"
key code 15 using {command down}
end tell
end tell"))
    (start-process "xcode:build-and-run" nil "osascript" "-e" cmd)))
;;;###autoload
(defun xcode:build()
  (interactive)
  (let ((cmd  "tell application \"Xcode\" to activate
tell application \"System Events\"
tell process \"Xcode\"
key code 11 using {command down}
end tell
end tell"))
    (start-process "xcode:build-and-run" nil "osascript" "-e" cmd)))

;;;###autoload
(defun my-complete()
  (interactive)
  (cond ((and (boundp 'company-mode) company-mode)
         (call-interactively 'company-complete)
         )
        ((and (boundp 'auto-complete-mode) auto-complete-mode)
         (call-interactively 'auto-complete)
         )
        (t
         (call-interactively 'hippie-expand))))

;; 小说 段首缩进4格
(defun novel-fill(&optional args)
  (interactive)
  (if (not mark-active)
      (novel-fill-intern)
    (save-excursion
      (let ((begin (region-beginning))
            (end (region-end)))
        (deactivate-mark)
        (goto-char begin)
        (while  (< (point) end)
          (novel-fill-intern)
          (forward-paragraph)
          (skip-chars-forward "[ |\t|\n|\r]*"))))))

(defun novel-fill-intern()
  (let* ((p (point))
         (begin (save-excursion
                  (forward-paragraph)
                  (backward-paragraph)
                  (point)))
         (is-blank-string (buffer-substring-no-properties begin p)))
    (save-excursion
      (goto-char begin)
      (skip-chars-forward "[ |\t|\n|\r]*")
      (delete-horizontal-space)
      (insert "    ")
      (fill-paragraph))
    (when (string-blank-p  is-blank-string)
      (skip-chars-forward "[ |\t|\n|\r]*"))))
;; 标点使用中文标点
(defun chinese-normal()
  (interactive)
  (let ((begin)
        (end))
    (if (not mark-active)
        (progn
          (setq begin (point-min))
          (setq end (point-max)))
      (setq begin (region-beginning))
      (setq end (region-end))
      )
    (save-excursion
      (goto-char begin)
      (while (search-forward "," end t) (replace-match "，"))
      (goto-char begin)
      (while (search-forward "?" end t) (replace-match "？"))

      (goto-char begin)
      (while (search-forward "“" end t) (replace-match "「"))
      (goto-char begin)
      (while (search-forward "”" end t) (replace-match "」"))
      (goto-char begin)
      (let ((cnt 0))
        (while (search-forward "\"" end t)
          (setq cnt (1+ cnt))
          (if (equal 1 (% cnt 2))
              (replace-match "「")
            (replace-match "」"))
          )
        )
      )))



(provide 'joseph-command)
