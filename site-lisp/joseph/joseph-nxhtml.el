;;; Code:

;; (unless (featurep 'nxhtml-autostart) (load "autostart"))
;; ;;nhtml
;; ;;;###autoload
;; (define-derived-mode joseph-nxhtml-mode nxhtml-mode "nXhtml"
;;   "an autoloaded  empty function")

;; ;; (eval-after-load 'popcmp '(setq popcmp-completion-style (quote anything)))

;; ;; Workaround the annoying warnings:
;; ;;    Warning (mumamo-per-buffer-local-vars):
;; ;;    Already 'permanent-local t: buffer-file-name
;; (when (and (equal emacs-major-version 24)
;;            ;; (equal emacs-minor-version 2)
;;            )
;;   (eval-after-load "mumamo"
;;     '(setq mumamo-per-buffer-local-vars
;;            (delq 'buffer-file-name mumamo-per-buffer-local-vars))))



(provide 'joseph-nxhtml)
;;; joseph-nxhtml.el ends here
