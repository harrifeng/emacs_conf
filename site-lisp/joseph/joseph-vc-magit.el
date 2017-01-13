(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "C-w") nil)
  (define-key magit-mode-map (kbd "M-w") 'magit-copy-section-value)
  (define-key magit-mode-map "," '(lambda() (interactive)(magit-status-internal (magit-read-repository nil))))


  (define-key magit-mode-map "p" 'magit-push-popup)
  (define-key magit-mode-map "P" 'magit-section-backward)
  (magit-define-popup-action 'magit-push-popup ?p "Upstream" 'magit-push-current-to-upstream)
  (magit-define-popup-action 'magit-fetch-popup ?f "Pull" 'magit-pull-from-upstream)
  (magit-define-popup-action 'magit-rebase-popup ?g "Refresh" 'magit-refresh)
  (magit-define-popup-action 'magit-rebase-popup ?r "Refresh" 'magit-refresh)

  ;; (define-key magit-mode-map "\s" nil) ;space
  ;; (define-key magit-diff-mode-map "\s" nil) ;space
  ;; (define-key magit-diff-mode-map "j" nil)
)

;; (require 'magit-svn)

(defun magit-mode-hook-fun()
  ;; (magit-svn-mode)
  ;; (require 'magit-backup)
  ;; (magit-backup-mode -1)
  ;; (magit-auto-revert-mode -1)
  (let ((dir (magit-git-dir)))
    (when (file-remote-p dir)
      (add-to-list 'magit-repository-directories (expand-file-name ".." )))))

;; (eval-after-load 'git-commit-mode '(setq git-commit-setup-hook (delete 'git-commit-turn-on-flyspell git-commit-setup-hook)))
(add-hook 'magit-mode-hook 'magit-mode-hook-fun)


(setq-default
 ;; slow ,if t
 magit-diff-refine-hunk nil  ;'all, This is super useful when only a single identifier/word is changed all over the place
 magit-diff-show-diffstat nil
 magit-diff-highlight-hunk-body nil
 magit-diff-section-arguments '("--ignore-space-at-eol" "--ignore-blank-lines" "--no-ext-diff") ;do not set this ;use  toggle-diff-whitespace-eol to toggle
 magit-section-highlight-hook nil       ;不必hightlight,光标移动的时候，默认会显示当前section区域
 magit-section-unhighlight-hook nil
 )                         ;

;;;###autoload
(defun toggle-diff-whitespace-eol()
  (interactive)
  (if  (equal vc-git-diff-switches t)
      (progn
        (setq vc-git-diff-switches '("--ignore-space-at-eol" "--ignore-blank-lines"))
        (setq magit-diff-section-arguments '("--ignore-space-at-eol" "--ignore-blank-lines" "--no-ext-diff")))
    (setq vc-git-diff-switches t)
    (setq magit-diff-section-arguments '("--no-ext-diff")))
  (if  (equal vc-svn-diff-switches t)
      (setq vc-svn-diff-switches '("-x --ignore-eol-style"  ))
    (setq vc-svn-diff-switches t))
  (cond
   ((equal major-mode 'diff-mode)
    (revert-buffer))
   ((equal major-mode 'magit-status-mode)
    (magit-refresh)))
  (message "toggle diff show whitespace at end of line"))
;; (setq-default magit-log-format-graph-function 'magit-log-format-unicode-graph)

(unless magit-repository-directories
  (setq magit-repository-directories (list (expand-file-name "~/.emacs.d")
                              (expand-file-name "~/dotfiles")
                              (expand-file-name "~/documents/org/src"))))




;; (defun magit-get-section-files(section-title)
;;   "get file path in section `section-title' ,`section-title' maybe
;; `staged' ,`unstaged' ,`untracked',`unpushed'"
;;   (save-excursion
;;     (let (section files-struct files)
;;       (magit-goto-section-at-path (list section-title))
;;       (setq section (magit-current-section))
;;       (when section
;;         (setq files-struct (magit-section-children section))
;;         (dolist (magit-section-struct files-struct)
;;           (add-to-list 'files (magit-section-title magit-section-struct))))
;;       files)))

;; (defun magit-log-edit-auto-insert-files()
;;   "提交代码时日志中自动插入staged的文件."
;;   (let ((files (with-current-buffer magit-buffer-internal (magit-get-section-files 'staged))))
;;     (when files
;;       (save-excursion
;;         (goto-char (point-min))
;;         (when (search-forward "\n受影响的文件:" (point-max) t)
;;           (delete-region (match-beginning 0) (point-max)))
;;         (goto-char (point-max))
;;         (insert "\n受影响的文件:\n    "
;;                 (mapconcat 'identity files "\n    "))))))

;; (defun magit-log-edit-auto-insert-author()
;;   (save-excursion
;;     (goto-char (point-min))
;;     (if (search-forward magit-log-header-end (point-max) t) ;skip magit log header -end
;;         (goto-char (match-end 0))
;;       (goto-char (point-min)))
;;     (delete-horizontal-space)
;;     ;; (goto-char (point-at-eol))
;;     (let ((sign (format  "[%s]:" user-full-name)))
;;       (unless (looking-at (regexp-quote sign))
;;         (insert sign)))))

;; (defadvice magit-log-edit-commit (around auto-insert-author preactivate activate compile)
;;   (magit-log-edit-auto-insert-author)
;;   (magit-log-edit-auto-insert-files)
;;   ad-do-it)

;; 在magit buffer里，C-xvL 依然可以使用,
;; (defadvice vc-deduce-backend (around magit-support  preactivate activate compile)
;;   (let (backend)
;;     ad-do-it
;;     (setq backend ad-return-value)
;;     (unless backend
;;       (cond
;;        ((derived-mode-p 'magit-mode)
;;         (setq backend 'Git)
;;         )
;;        (t nil)))
;;     (setq ad-return-value backend)
;;     ))

(provide 'joseph-vc-magit)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-vc-magit.el ends here
