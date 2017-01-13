
;; (defun joseph-find-yasnippets-file ()
;;   (when (string-match "/snippets/" buffer-file-name)
;;     (snippet-mode )))
;; ;; Jump to end of snippet definition

;; Inter-field navigation
(defun yas/goto-end-of-active-field ()
  (interactive)
  (let* ((snippet (car (yas--snippets-at-point)))
        (position (yas--field-end (yas--snippet-active-field snippet))))
    (if (= (point) position)
        (move-end-of-line 1)
      (goto-char position))))

(defun yas/goto-start-of-active-field ()
  (interactive)
  (let* ((snippet (car (yas--snippets-at-point)))
        (position (yas--field-start (yas--snippet-active-field snippet))))
    (if (= (point) position)
        (move-beginning-of-line 1)
      (goto-char position))))

(provide 'joseph-yasnippet-lazy)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-yasnippet-lazy.el ends here
