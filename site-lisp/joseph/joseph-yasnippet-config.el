;; -*- coding:utf-8 -*-
;;; jospeh-yasnippet-config.el --- config for yasnippet
;;; Code:
(setq-default yas-snippet-dirs '("~/.emacs.d/snippets"))

;; (require 'yasnippet) ;;
(autoload 'yas-global-mode "yasnippet")
(with-eval-after-load 'yasnippet
  (yas-global-mode 1)
  (require 'joseph-yasnippet-lazy)
  (setq-default yas-prompt-functions '(yas-completing-prompt))
  ;; (setq-default helm-c-yas-space-match-any-greedy t) ;[default: nil]
  ;; (add-hook 'find-file-hook 'joseph-find-yasnippets-file)

  (define-key yas-keymap (kbd "<return>") 'yas-exit-all-snippets)
  ;; (define-key yas-minor-mode-map " " 'yas-expand)

  (define-key yas-keymap (kbd "C-e") 'yas/goto-end-of-active-field)
  (define-key yas-keymap (kbd "C-a") 'yas/goto-start-of-active-field))


;; (autoload 'helm-c-yas-complete "helm-c-yasnippet" "List of yasnippet snippets using `helm' interface.")
;; (global-set-key (kbd "C-c y") 'helm-c-yas-complete)


(provide 'joseph-yasnippet-config)
;;; jospeh-yasnippet-config.el ends here
