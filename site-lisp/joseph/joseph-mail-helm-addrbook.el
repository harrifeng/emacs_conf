
;;; Commentary:

;;; Code:
(defvar joseph-mail-addrbook-candidates nil)
(defvar mail-addrbook-file nil)

(defun joseph-mail-addrbook-candidates()
  (if joseph-mail-addrbook-candidates
      joseph-mail-addrbook-candidates
    (with-current-buffer (find-file-noselect mail-addrbook-file)
      (goto-char (point-min))
      (let (line prefix comment tokens short mail real)
        (while (not (eobp))
          (setq line (buffer-substring (point-at-bol) (point-at-eol)))
          (setq tokens (split-string line "#"))
          (setq prefix (car tokens))
          (setq comment (nth 1 tokens))
          (setq tokens (split-string prefix "[: \t]" t))
          (setq short (car tokens))
          (setq mail (nth 1 tokens))
          (setq real (concat short "<" mail ">,"))
          (add-to-list 'joseph-mail-addrbook-candidates (cons (concat short comment) real))
          (forward-line)))
      (kill-buffer))))

(defvar helm-c-source-mail-addrbook
  '((name . "Insert Email:")
    (init . joseph-mail-addrbook-candidates)
    (candidates . joseph-mail-addrbook-candidates)
    (action . (("Insert Email:" . (lambda(candidate)
                                    (let ((region (bounds-of-thing-at-point 'sexp))
                                          start end)
                                      (when region
                                        (setq start (car region))
                                        (setq end (cdr region))
                                        (delete-region start end)))
                                    (insert candidate)))))))

;;;###autoload
(defun helm-mail-addrbook-complete()
  "complete mail address book"
  (interactive)
  (let ((helm-execute-action-at-once-if-one t)
        (helm-quit-if-no-candidate
         (lambda () (message "No addrbook record."))))
    (helm '(helm-c-source-mail-addrbook)
              ;; Initialize input with current symbol
             (thing-at-point 'sexp)  nil nil "\t")))

(provide 'joseph-mail-helm-addrbook)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-mail-lazy.el ends here
