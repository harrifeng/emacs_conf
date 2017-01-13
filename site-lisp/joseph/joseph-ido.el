(setq-default ido-save-directory-list-file (convert-standard-filename "~/.emacs.d/cache/ido.last"))
(setq-default ido-use-virtual-buffers t)

;; (defun ido-ignore-dired-buffer (name)
;;   "ignore dired buffers."
;;   (if  (get-buffer name)
;;       (with-current-buffer (get-buffer name)
;;         (equal major-mode 'dired-mode))))

(setq-default ido-ignore-buffers
              '("\\` "
                "\\*helm" "\\*helm-mode"
                "\\*Echo Area" "\\*Minibuf"
                "\\*ac-mode-"
                "*Backtrace*"
                " *Warnings*"
                "\\*reg group-leader\\*"
                "\\*derl emacs@jf\\.org\\*"
                "\\*trace emacs"
                "\\*magit-process"
                "\\*magit-log"
                "\\*magit-diff"
                "\\*magit-rev"
                ;; "\\*magit"
                ;; "\\*scratch\\*"
                ;; echo area
                "\\*Completions\\*"
                "\\*Shell Command Output\\*"
                "\\*Async Shell Command\\*"
                "\\*zsh\\*"
                "\\*bash\*"
                "\\*vc\*"
                ;; "\\*compilation\\*"
                "\\*Compile-Log\\*"
                "\\*Ibuffer\\*"
                ;; "\\*Help\\*"
                ;; "\\*Messages\\*"
                ;; ido-ignore-dired-buffer
                ))


(ido-mode 'buffers)

(add-hook 'ido-setup-hook 'ido-my-keys)
(defun ido-my-keys ()
  (define-key (cdr ido-minor-mode-map-entry) [remap dired] nil) ;dired 不使用ido
  "Add my keybindings for ido."
  (define-key ido-completion-map (kbd "C-e") 'ido-exit-minibuffer) ;select or expand
  (define-key ido-completion-map [?\H-m] 'ido-exit-minibuffer) ;select or expand
  (define-key ido-completion-map (kbd "C-,") 'ido-up-directory)
  (define-key  ido-completion-map (kbd "C-l") 'ido-up-directory)
  (define-key  ido-file-dir-completion-map (kbd "C-l") 'ido-up-directory)

  
  (setq ido-enable-flex-matching t)
  )


(provide 'joseph-ido)
;;; joseph-ido.el ends here
