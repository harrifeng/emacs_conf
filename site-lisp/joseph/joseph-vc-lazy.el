;;; -*- coding:utf-8 -*-
;;;; byte compile
(eval-when-compile
  (require  'log-edit)
  (require  'log-view)
  (require 'vc-dir))

(declare-function ediff-vc-internal (rev1 rev2 &optional startup-hooks))

;;;###autoload
(defun log-view-ediff (beg end)
  "the ediff version of `log-view-diff'"
  (interactive
   (list (if mark-active (region-beginning) (point))
         (if mark-active (region-end) (point))))
  (let ((marked-entities (log-view-get-marked)) pos1 pos2)
    (when (= (length marked-entities) 2)
      (setq pos1 (progn (log-view-goto-rev (car marked-entities) ) (point) ))
      (setq pos2 (progn (log-view-goto-rev (nth 1 marked-entities) ) (point)))
      (setq beg  (if (< pos1 pos2 ) pos1 pos2))
      (setq end  (if (> pos1 pos2 ) pos1 pos2))
      ))
  (let ((fr (log-view-current-tag beg))
        (to (log-view-current-tag end)))
    (when (string-equal fr to)
      (save-excursion
        (goto-char end)
        (log-view-msg-next)
        (setq to (log-view-current-tag))))
    (require 'ediff-vers)
    (ediff-vc-internal to fr)))

;;;###autoload
(defun vc-command ()
  "run vc command"
  (interactive)
  (let* ((backend vc-dir-backend)
         (files (vc-dir-marked-files))
         (backend-cmd (symbol-value  (intern (concat "vc-" (downcase (symbol-name backend)) "-program"))))
         (readed-sub-cmd  (concat  (read-shell-command (concat "run " backend-cmd " command:") (concat backend-cmd " ")) ))
         (params-list (append  (split-string-and-unquote readed-sub-cmd) files))
         (process-buf (concat "*vc-" backend-cmd "-command-out*"))
         process)
    (message "%s"  (prin1-to-string params-list))
    (when (bufferp process-buf) (kill-buffer process-buf))
    (setq process
          (apply 'start-process ;;
                 (buffer-name (current-buffer)) process-buf
                 (car params-list) (cdr params-list)
                 ))
    (set-process-sentinel process
                          (lambda (proc change)
                            (when (string-match "\\(finished\\|exited\\)" change)
                              (let ((cur-buf (current-buffer) ))
                                (set-buffer   (process-buffer proc))
                                (setq major-mode 'vc-command-output-mode)
                                (local-set-key "\C-g" 'kill-buffer-and-window)
                                (local-set-key "g" 'kill-buffer-and-window)
                                (local-set-key "q" 'kill-buffer-and-window)
                                (set-buffer cur-buf)
                                )
                              (when (and (bufferp (get-buffer (process-name proc)))
                                         (buffer-live-p (get-buffer (process-name proc))))
                                (with-current-buffer (get-buffer (process-name proc))
                                  (vc-dir-unmark-all-files t)
                                  (revert-buffer t t t)
                                  ))
                              (if (> (buffer-size (process-buffer proc)) 200)
                                  (progn
                                    (with-current-buffer (process-buffer proc)
                                      (while (search-forward "\^M" nil t)
                                        (replace-match "\n" nil t)))
                                    (switch-to-buffer-other-window (process-buffer proc) t)
                                    )
                                (message "%s " (with-current-buffer  (process-buffer proc) (buffer-string)))
                                )
                              )
                            ;; (if (> (buffer-size (process-buffer proc)) 200)
                            ;;   (message "%s " (with-current-buffer  (process-buffer proc) (buffer-string)))
                            ;;   (kill-buffer  (process-buffer proc))
                            ;;   )
                            ))))

;; (defun vc-up-dir ()
;;   (interactive)
;;   (let ((vcs-up-dir (vc-call-backend vc-dir-backend 'responsible-p (expand-file-name ".." default-directory))))
;;     (if (stringp vcs-up-dir)
;;         (vc-dir  vcs-up-dir vc-dir-backend ))
;;     (message "up to root dir already!")
;;     )
;;   )
;; ;;;###autoload
;; (defun log-edit-auto-insert-filenames ()
;;   "Insert the list of files that are to be committed."
;;   (save-excursion
;;     (goto-char (point-min))
;;     (when (search-forward "\n受影响的文件:" (point-max) t)
;;       (delete-region (match-beginning 0) (point-max)))
;;     (goto-char (point-max))
;;     (insert "\n受影响的文件:\n    "
;;             (mapconcat 'identity  (log-edit-files) "\n    "))
;;     (goto-char (point-max))))

;; 暂时注掉
;; ;;;###autoload
;; (defun log-edit-auto-insert-author()
;;   (save-excursion
;;     (goto-char (point-min))
;;     (delete-horizontal-space)
;;     (goto-char (point-min))
;;     ;; (goto-char (point-at-eol))
;;     (let ((sign (format  "[%s]:" user-full-name)))
;;       (unless (looking-at (regexp-quote sign))
;;         (insert sign)))))

;; (autoload 'vc-jump "vc-jump" "vc jump")
;; (autoload 'magit-status "magit" "magit")
;; (eval-after-load 'vc-hooks '(setq vc-handled-backends (cons 'Git (delete 'Git  vc-handled-backends))))
;;;###autoload
;; (defun my-vc-jump()
;;   (interactive)
;;   "让Git 排在svn的前面,所以当目录下同时有.git .svn时, 优先选择git,
;;   同时C-xvd时又可以让Git排在svn后面."
;;   (let ((orig-vc-handled-backends (copy-alist vc-handled-backends)))
;;     (setq vc-handled-backends (cons 'Git (delete 'Git  vc-handled-backends)))
;;     (vc-jump)
;;     (setq vc-handled-backends orig-vc-handled-backends)
;;     ))

(provide 'joseph-vc-lazy)
