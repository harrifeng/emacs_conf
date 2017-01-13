;;; Code:
(eval-when-compile
  (require 'joseph_byte_compile_include)
  (require 'erlookup nil t))
;; (require 'bookmark-cycle)
(require 'bm)
(require 'find-func)
(require 'helm-gtags)

;;;###autoload
(defun goto-definition (&optional arg)
  "Make use of emacs' find-func and etags possibilities for finding definitions."
  (interactive "P")
  (let ((line (buffer-substring-no-properties
               (line-beginning-position) (line-end-position)))
        ;; (marker (point-marker))
        )
    (bm-bookmark-add line nil t)
    (case major-mode
      (emacs-lisp-mode
       (if (or (string-match "(\\brequire\\b" line) (string-match "(\\bprovide\\b" line))
           (find-file (find-library-name (symbol-name (symbol-at-point))))
         (condition-case nil
             (if  (or (functionp (symbol-at-point))(macrop (symbol-at-point)))
                 (find-function (symbol-at-point))
               (condition-case nil
                   (when (variable-at-point) (find-variable (symbol-at-point)))
                 (error (helm-gtags-find-tag-and-symbol))))
           )))
      (lisp-interaction-mode
       (if (or (string-match "(\\brequire\\b" line) (string-match "(\\bprovide\\b" line))
           (find-file (find-library-name (symbol-name (symbol-at-point))))
         (condition-case nil
             (if  (or (functionp (symbol-at-point))(macrop (symbol-at-point)))
                 (find-function (symbol-at-point))
               (condition-case nil
                   (when (variable-at-point) (find-variable (symbol-at-point)))
                 (error (helm-gtags-find-tag-and-symbol))))
           )))
      (erlang-mode (erl-find-source-under-point))
      (c++-mode
       (if (string-match "[ ]*#[ \t]*include[ \t]+[\"<]\\(.*\\)[\">]" line)
           ;; for c++-mode ,in current line contains #include ,then try to open the include file using helm-gtags
           (helm-gtags-find-files (match-string 1 line))
         (helm-gtags-find-tag-and-symbol)))
      (c-mode
       (if (string-match "[ ]*#[ \t]*include[ \t]+[\"<]\\(.*\\)[\">]" line)
           ;; for c-mode ,in current line contains #include ,then try to open the include file using helm-gtags
           (helm-gtags-find-files (match-string 1 line))
         (helm-gtags-find-tag-and-symbol)))
      (lua-mode
       (call-interactively 'helm-etags+-select)
       )
      (csharp-mode
       (call-interactively 'helm-etags+-select)
       )
      (js-mode
       (if (functionp 'tern-find-definition)
           (call-interactively 'tern-find-definition)
         (helm-gtags-find-tag-and-symbol)))
      (go-mode
       (call-interactively 'godef-jump)
       )
      (python-mode
       (call-interactively 'jedi:goto-definition)
       )
      (otherwise
       (helm-gtags-find-tag-and-symbol)))
    ;; (when (and (equal (point) (marker-position marker))
    ;;                (equal (current-buffer)(marker-buffer marker))
    ;;                )
    ;;   (bm-bookmark-remove))
    )
  (setq this-command 'goto-definition)
  )


(provide 'joseph-tag-lazy)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-tag-lazy.el ends here
