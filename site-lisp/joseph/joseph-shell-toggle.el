;; ;;   (global-set-key [f2] 'toggle-bash)
;; ;;   (global-set-key [C-f2] 'toggle-bash-cd)

;; ;;   (global-set-key [f2] 'toggle-zsh)
;; ;;   (global-set-key [C-f2] 'toggle-zsh-cd)

;; ;;; Code:

;; (eval-when-compile  (require 'shell))

;; ;;这里很多变量，都被我用let 置成临时变量，而全局的相应变量并没做修改，
;; ;;因为在windows 上，我使用默认的cdmproxy
;; (defun toggle-shell (&optional shell-name shell-buffer-name)
;;   "Start `bash' shell."
;;   (interactive "sshell name:\nsshell buffer name:")
;;   (let ((binary-process-input t)
;;         (binary-process-output nil)
;;         (comint-scroll-show-maximum-output 'this)
;;         ;; (shell-name (or shell-name "bash"))
;;         (shell-command-switch "-c");
;;         (explicit-shell-file-name (or shell-name "bash")) ;;term.el
;;         (explicit-bash-args '("-login" "-i"))
;;         (comint-completion-addsuffix t);;目录补全时,在末尾加一个"/"字符
;;         (comint-eol-on-send t)
;;         (comint-file-name-quote-list '(?\  ?\")) ;;当文件名中有这些(空格引号)特殊字符时会把这些特殊字符用"\"转义
;;         (w32-quote-process-args ?\")  ;;再给程序传递参数的时候,使用这个字符将参数括起来
;;         ;; (eval-after-load 'ediff-diff '(progn (setq ediff-shell shell-name))) ;;Ediff shell
;;         ;; Unfortunately, when you visit a DOS text file within an
;;         ;; encoded file, you'll see CRs (^Ms) in the buffer.
;;         ;; If `binary-process-output' is set to `nil', this problem goes
;;         ;; away, which is fine for files of type `.gz'.
;;         ;; (ediff-shell shell-name)
;;         ;; (shell-buffer-name (or shell-buffer-name "*bash*"))
;;         )
;;     ;; (when (equal system-type 'windows-nt)
;;     ;;   (setq comint-output-filter-functions '(comint-strip-ctrl-m))) 不知原因为何windows 上，加了这句后，shell不显颜色
;;     (setenv "SHELL" explicit-shell-file-name)
;;     (if (and (get-buffer shell-buffer-name)
;;              (buffer-live-p (get-buffer shell-buffer-name)))
;;         (cond
;;          ( (not (string= (buffer-name) shell-buffer-name))
;;            (switch-to-buffer-other-window shell-buffer-name))
;;          ((and (string= (buffer-name) shell-buffer-name)
;;                (> (length (window-list)) 1)
;;                (member last-command '(toggle-bash-cd toggle-bash toggle-zsh toggle-zsh-cd toggle-shell)))
;;           (delete-other-windows)
;;           )
;;          ((and (string= (buffer-name) shell-buffer-name)
;;                (> (length (window-list)) 1))
;;           (delete-window)
;;           )
;;          ((and
;;            (string= (buffer-name) shell-buffer-name)
;;            (equal (length (window-list)) 1))
;;           (bury-buffer)
;;           ))
;;       (let((old-window-config (current-window-configuration)))
;;         (shell shell-buffer-name)
;;         (sleep-for 1)
;;         (goto-char (point-max))
;;         ;; (comint-send-string (get-buffer-process (current-buffer)) "\n")
;;         ;; (comint-send-string (get-buffer-process (current-buffer)) (format "cd %s\n" dest-dir-cd))
;;         (insert (concat "cd " (concat "\"" (expand-file-name default-directory) "\""))) ;;make sure current directory is default-directory
;;         (comint-send-input)
;;         (set-window-configuration old-window-config)
;;         (switch-to-buffer-other-window shell-buffer-name)
;;         )
;;       )
;;     )
;;   )

;; (defvar shell-buffer-hist nil)

;; (defun toggle-shell-completing-read-buffer-name(arg &optional default-buffer-name-when-no-hist )
;;   (let* ((default-shell-buffer
;;            (if (and shell-buffer-hist (listp shell-buffer-hist) (car shell-buffer-hist))
;;                (car shell-buffer-hist) default-buffer-name-when-no-hist ))
;;          (buffer-name default-shell-buffer))
;;     (when arg
;;       (setq buffer-name (completing-read (concat "shell buffer name(default:"
;;                                                  (if (string-match "^\\*" default-shell-buffer)
;;                                                      default-shell-buffer
;;                                                    (concat "*"  default-shell-buffer "*"))
;;                                                  "):")
;;                                          shell-buffer-hist nil nil nil nil default-shell-buffer ))
;;       (unless (string-match "^\\*" buffer-name)
;;         (setq buffer-name (concat "*"  buffer-name "*"))) )
;;     (setq shell-buffer-hist (delete buffer-name shell-buffer-hist))
;;     (push buffer-name shell-buffer-hist)
;;     buffer-name
;;     ))

;; ;;;###autoload
;; (defun toggle-bash-cd(&optional arg dir)
;;   (interactive "P")
;;   (let ((dest-dir-cd (expand-file-name (or dir default-directory)))
;;         (shell-buffer-name (toggle-shell-completing-read-buffer-name arg "*bash*")))
;;     (toggle-shell "bash" shell-buffer-name)
;;     (with-current-buffer shell-buffer-name
;;       (goto-char (point-max))
;;       ;; (comint-send-string (get-buffer-process (current-buffer)) "\n")
;;       ;; (comint-send-string (get-buffer-process (current-buffer)) (format "cd %s\n" dest-dir-cd))
;;       (cd dest-dir-cd)
;;       (insert (concat "cd \"" dest-dir-cd "\""))
;;       (comint-send-input))))

;; ;;;###autoload
;; (defun toggle-bash(&optional arg dir)
;;   (interactive "P")
;;   (toggle-shell "bash"  (toggle-shell-completing-read-buffer-name arg "*bash*")))

;; ;;;###autoload
;; (defun toggle-zsh-cd(&optional arg dir)
;;   (interactive "P")
;;   (let ((dest-dir-cd (expand-file-name (or dir default-directory)))
;;         (shell-buffer-name (toggle-shell-completing-read-buffer-name arg "*zsh*")))
;;     (toggle-shell "zsh" shell-buffer-name)
;;     (with-current-buffer shell-buffer-name
;;       (goto-char (point-max))
;;       ;; (comint-send-string (get-buffer-process (current-buffer)) "\n")
;;       ;; (comint-send-string (get-buffer-process (current-buffer)) (format "cd %s\n" dest-dir-cd))
;;       (cd dest-dir-cd)
;;       (insert (concat "cd \"" dest-dir-cd "\""))
;;       (comint-send-input)))
;;   )

;; ;;;###autoload
;; (defun toggle-zsh(&optional arg dir)
;;   (interactive "P")
;;   (toggle-shell "zsh"  (toggle-shell-completing-read-buffer-name arg "*zsh*")))

;; ;; ;;;###autoload
;; ;; (defun set-shell-bash()
;; ;;   "Enable on-the-fly switching between the bash shell and DOS."
;; ;;   (interactive)
;; ;;   (setq comint-scroll-show-maximum-output 'this)

;; ;;   (setq shell-file-name "bash")
;; ;;   (setq shell-command-switch "-c")      ; SHOULD IT BE (setq shell-command-switch "-ic")?

;; ;;   (setq explicit-shell-file-name "bash") ;;term.el
;; ;;   (setenv "SHELL" explicit-shell-file-name)
;; ;;   (setq explicit-bash-args '("-login" "-i"))

;; ;;   (make-variable-buffer-local 'comint-completion-addsuffix)
;; ;;   (setq comint-completion-addsuffix t);;目录补全时,在末尾加一个"/"字符
;; ;;   (setq comint-eol-on-send t)
;; ;;   (setq comint-file-name-quote-list '(?\  ?\")) ;;当文件名中有这些(空格引号)特殊字符时会把这些特殊字符用"\"转义
;; ;;   (setq w32-quote-process-args ?\")  ;;再给程序传递参数的时候,使用这个字符将参数括起来
;; ;;   (eval-after-load 'ediff-diff '(progn (setq ediff-shell shell-file-name))) ;;Ediff shell
;; ;;   (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m nil t)
;; ;;   ;; Unfortunately, when you visit a DOS text file within an
;; ;;   ;; encoded file, you'll see CRs (^Ms) in the buffer.
;; ;;   ;; If `binary-process-output' is set to `nil', this problem goes
;; ;;   ;; away, which is fine for files of type `.gz'.
;; ;;   (setq binary-process-input t)
;; ;;   (setq binary-process-output nil)
;; ;;   )

(provide 'joseph-shell-toggle)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-shell-toggle.el ends here
