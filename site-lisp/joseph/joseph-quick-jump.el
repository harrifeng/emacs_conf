;;; Code:
(setq-default
 bm-recenter nil
 bm-highlight-style 'bm-highlight-line-and-fringe
 bm-cycle-all-buffers t
 bm-in-lifo-order t)
;; (setq-default bm-buffer-persistence t)
;; (setq-default bm-restore-repository-on-load t)
;; (require 'bm)
;; (add-hook' after-init-hook 'bm-repository-load)
;; (add-hook 'find-file-hooks 'bm-buffer-restore)
;; (add-hook 'kill-buffer-hook 'bm-buffer-save)
;; (add-hook 'kill-emacs-hook '(lambda nil
;;                               (bm-buffer-save-all)
;;                               (bm-repository-save)))

;; (add-hook 'after-revert-hook 'bm-buffer-restore)

;; (global-set-key (kbd "C-.") 'bm-toggle)
;; (global-set-key (kbd "C-,")   'bm-next)

;; (global-set-key (kbd "M-.") 'bm-toggle)
;; (global-set-key (kbd "M-/")   'bm-next)
;; (global-set-key (kbd "M-,") 'bm-previous)

(define-key global-map (kbd "M-*") 'helm-bm)

(with-eval-after-load 'bm
  (defadvice keyboard-quit (before rm-bm-bookmark activate)
    "rm bm bookmark "
    (bm-bookmark-remove))
  ;; (add-hook 'post-command-hook
  ;;           #'(lambda()
  ;;               (unless (equal this-command 'bm-toggle)
  ;;                 (bm-bookmark-remove))))
  )


(provide 'joseph-quick-jump)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-quick-jump.el ends here
