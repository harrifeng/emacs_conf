;; ;;; Commentary:

;; ;;

;; ;;; Code:

;; ;;; 自动处理msys路径
;; ;;;###autoload
;; (defun shell-msys-path-complete-as-command ()
;;   "replace /d/ with d:/ on windows when you press `TAB'in shell mode."
;;   (let* ((filename (comint-match-partial-filename))
;;          filename-beg filename-end driver-char (return-value nil))
;;     (when (equal system-type 'windows-nt)
;;       (cond
;;        ((and filename (string-match  "^/tm?p?/?" filename) (looking-back "/tm?p?/?")) ; replace "/tmp" with "d:/tmp/"
;;         (setq filename-beg (match-beginning 0))
;;         (setq filename-end (match-end 0))
;;         (goto-char filename-beg)
;;         (delete-region filename-beg filename-end)
;;         (when (and (not (file-exists-p "d:/tmp/")))(make-directory "d:/tmp/"))
;;         (insert "d:/tmp/")
;;         (if (string-match  "/$" filename) (setq return-value nil )(setq return-value t));;根据是否又/结果决定是否继续进行其他补全。
;;         )
;;        ((and filename (string-equal  "/" filename) (looking-back "/")) ; replace "/" with root directory
;;         (setq filename-beg (match-beginning 0))
;;         (setq filename-end (match-end 0))
;;         (goto-char filename-beg)
;;         (delete-region filename-beg filename-end)
;;         (insert (substring (expand-file-name default-directory)  0 3))
;;         )
;;        ((and filename (string-match "^/\\([a-zA-Z]\\)" filename)) ; replace "/d" with "d:/"
;;         (setq driver-char (match-string 1 filename))
;;         (when (looking-back (regexp-quote filename))
;;           (setq filename-beg (match-beginning 0))
;;           (setq filename-end (match-end 0))
;;           (goto-char filename-beg)
;;           (delete-region filename-beg filename-end)
;;           (insert (replace-regexp-in-string "^/\\([a-zA-Z]\\)/?" (concat driver-char ":/") filename))))
;;        ))return-value))

;; ;;; exit and man and clear command in shell mode
;; ;; ;; From: http://www.dotfiles.com/files/6/235_.emacs
;; ;;;###autoload
;; (defun n-shell-simple-send (proc command)
;;   "shell对于clear ,exit ,man 某些特殊的命令,做特殊处理
;;  clear ,清屏，exit ,后关闭窗口"
;;   (cond
;;    ;; Checking for clear command and execute it.
;;    ((string-match "^[ \t]*vi[ \t]+\\(.*\\)$" command);;vi means open files
;;     (let ((origin-buf(current-buffer)))
;;       (erase-buffer)
;;       (comint-send-string proc "\n")
;;       (find-file (match-string  1 command))
;;       (delete-other-windows)
;;       (set-buffer origin-buf)))

;;    ((string-match "^[ \t]*clear[ \t]*$" command) ;;clear screen
;;     (erase-buffer)
;;     (comint-send-string proc "\n")
;;     (recenter-top-bottom))
;;    ((string-match "^[ \t]*\\.\\.[ \t]*$" command) ;;..
;;     (comint-simple-send proc "cd ..")
;;     ;; (comint-send-string proc "cd ..\n")
;;     (setq default-directory (expand-file-name ".."))
;;     )
;;    ((string-match "^[ \t]*\\.\\.\\.[ \t]*$" command) ;;...
;;     (comint-simple-send proc "cd ../..")
;;     (setq default-directory (expand-file-name  ".." (expand-file-name "..")))
;;     )

;;    ((string-match "^[ \t]*man[ \t]+" command);;man ,call woman
;;     (comint-send-string proc "\n")
;;     (setq command (replace-regexp-in-string "^[ \t]*man[ \t]*" "" command))
;;     (setq command (replace-regexp-in-string "[ \t]+$" "" command))
;;     ;;(message (format "command %s command" command))
;;     (when command (funcall 'woman command)(delete-other-windows)))

;;    ((string-match "^[ \t]*git[ \t]+log[ \t]*$" command);;git log
;;     (comint-simple-send proc "")
;;     (vc-print-root-log)
;;     )
;;    ((string-match "^[ \t]*git[ \t]+diff[ \t]*$" command);;git diff
;;     (comint-simple-send proc " ")
;;     (let ((default-win-cfg (current-window-configuration))
;;           vc-dired-buf diff-buf)
;;       (vc-dir default-directory)
;;       (setq vc-dired-buf (current-buffer))
;;       (call-interactively 'vc-diff)
;;       (setq diff-buf (current-buffer))
;;       (set-window-configuration default-win-cfg)
;;       (bury-buffer vc-dired-buf)
;;       (pop-to-buffer diff-buf)
;;       )
;;     )
;;    ((string-match "^[ \t]*git[ \t]+diff[ \t]*\\(.+?\\)[ \t]*$" command);;git diff file
;;     (comint-simple-send proc " ")
;;     (let ((default-win-cfg (current-window-configuration))
;;           (diff-file (match-string  1 command))
;;           buf diff-buf )
;;       (if (file-exists-p (expand-file-name diff-file))
;;         (progn
;;           (unless (setq buf  (get-file-buffer (expand-file-name diff-file)))
;;             (setq buf (find-file-noselect  (expand-file-name diff-file)))
;;             )
;;           (with-current-buffer buf
;;             (call-interactively 'vc-diff)
;;           (setq diff-buf (current-buffer))  )

;;           (set-window-configuration default-win-cfg)
;;           (pop-to-buffer diff-buf)
;;           )
;;         ;; if not 'git diff onlyonefile'
;;         (shell-command command)
;;         )
;;       )
;;     )


;;    ;; Send other commands to the default handler.
;;    (t (comint-simple-send proc command))
;;    ))
;; ;;;###autoload
;; (defun shell-kill-buffer-when-exit-func()
;;   (set-process-query-on-exit-flag (get-buffer-process (current-buffer)) nil)
;;   (set-process-sentinel
;;    (get-buffer-process (current-buffer))
;;    (lambda (process state) "DOCSTRING"
;;      (when (string-match "exited abnormally with code.*\\|finished\\|exited" state)
;;        (message "shell exit!")
;;        (if (and (not (minibufferp))
;;                 (< 1 (length (window-list)))
;;                 (get-buffer-window (process-buffer process) 'visible)
;;                 )
;;            (kill-buffer-and-window)
;;          (kill-buffer (current-buffer)))))))

;; ;;;###autoload
;; (defun cmdproxy()
;;   "Set shell to `cmdproxy'."
;;   (interactive)
;;   (let((shell-file-name "cmdproxy")
;;        (explicit-shell-file-name "cmdproxy")
;;        )
;;     (shell "cmd")
;;     )
;;   ;; (setenv "SHELL" explicit-shell-file-name)
;;   )

;; ;; ;;; auto close *Completeion* after `TAB' complete 这部分好像用了helm 后不需了
;; ;; (defun comint-close-completions ()
;; ;;   "Close the comint completions buffer.
;; ;; Used in advice to various comint functions to automatically close
;; ;; the completions buffer as soon as I'm done with it. Based on
;; ;; Dmitriy Igrishin's patched version of comint.el."
;; ;;   (if comint-dynamic-list-completions-config
;; ;;       (progn
;; ;;         (set-window-configuration comint-dynamic-list-completions-config)
;; ;;         (setq comint-dynamic-list-completions-config nil))))

;; ;; (defadvice comint-send-input (after close-completions activate)
;; ;;   (comint-close-completions))

;; ;; (defadvice comint-dynamic-complete-as-filename (after close-completions activate)
;; ;;   (if ad-return-value (comint-close-completions)))

;; ;; (defadvice comint-dynamic-simple-complete (after close-completions activate)
;; ;;   (if (member ad-return-value '('sole 'shortest 'partial))
;; ;;       (comint-close-completions)))

;; ;; (defadvice comint-dynamic-list-completions (after close-completions activate)
;; ;;   (comint-close-completions)
;; ;;   (if (not unread-command-events)
;; ;;       ;; comint's "Type space to flush" swallows space. put it back in.
;; ;;       (setq unread-command-events (listify-key-sequence " "))))


(provide 'joseph-shell-lazy)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-shell-lazy.el ends here
