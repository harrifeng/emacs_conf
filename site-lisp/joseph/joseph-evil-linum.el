;;; linum-relative - makes Evil behave like:
;;; https://github.com/myusuf3/numbers.vim
;;; https://github.com/coldnew/linum-relative
(setq-default
 linum-relative-format "%3s|"
 linum-format 'linum-non-relative
 ;; show >> on line where cursor is
 linum-relative-current-symbol ">>"
 linum-relative-plusp-offset 0 ;
 )



(require 'linum-relative) ;
(defface linum-relative-face
  '((t :inherit linum :foreground "green"))
  "Face for displaying current line."
  :group 'linum-relative)

(defun linum-non-relative (line-number)
  "Linum formatter that copies the format"
  (propertize (format linum-relative-format line-number)
              'face 'linum-relative-face))

(defun linum-relative-formatting ()
  "Turn on relative formatting"
  (setq-local linum-format 'linum-relative))

(defun linum-normal-formatting ()
  "Turn on non-relative formatting"
  (setq-local linum-format 'linum-non-relative))

;; in Normal mode, use relative numbering
(add-hook 'evil-normal-state-entry-hook 'linum-relative-formatting)
;; in Insert mode, use normal line numbering
(add-hook 'evil-insert-state-entry-hook 'linum-normal-formatting)
;; copy linum face so it doesn't look weird
(defun enable-linum-mode-frame-hook(&optional frame)
  (with-selected-frame frame
    (global-linum-mode 1)))

(if (daemonp)
    (add-hook 'after-make-frame-functions 'enable-linum-mode-frame-hook t)
  (global-linum-mode))

(defun linum-off() (linum-mode -1))
(add-hook 'magit-status-mode-hook 'linum-off)


(provide 'joseph-evil-linum)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-evil-linum.el ends here
