;;; joseph-mew-retrieve-all.el --- Description

;;; Commentary:

;; 接收所有指定邮箱的邮件

;;; Code:

;;; utils to retrieve all accounts mails.
;;指定从哪些邮箱中一次性接收邮件
(defvar my-mew-cases '("default"  ))
(defvar my-mew-orig-case "default")
(defvar my-mew-current-caselist my-mew-cases)
(defun my-mew-summary-set-case (case)
  "Set the case."
  (setq mew-case case)
  (let ((case mew-case)) ;; side effect
    (save-excursion
      (dolist (buf mew-buffers)
        (when (get-buffer buf)
          (set-buffer buf)
          (cond
            ((mew-summary-p)
             (mew-summary-mode-name mew-mode-name-summary))
            ((mew-virtual-p)
             (mew-summary-mode-name mew-mode-name-virtual))))))
    (when mew-visit-inbox-after-setting-case
      (let ((inbox (mew-case-folder
                    case
                    (mew-proto-inbox-folder (mew-proto case) case))))
        (mew-summary-visit-folder inbox)))))
;;;###autoload
(defun my-mew-summary-retrieve-all ()
  (interactive)
  (setq my-mew-orig-case mew-case)
  (my-mew-summary-set-case (car my-mew-cases))
  (setq my-mew-current-caselist (cdr my-mew-cases))
  (mew-summary-retrieve))
(defadvice mew-net-disp-info-display (after my-cache-save-postfix-action)
  (sleep-for 2)
  (cond (my-mew-current-caselist
         (my-mew-summary-set-case (car my-mew-current-caselist))
         (setq my-mew-current-caselist (cdr my-mew-current-caselist))
         (mew-summary-retrieve))
        (my-mew-orig-case
         (sleep-for 2)
         (message "retrieve all accounts done.")
         (my-mew-summary-set-case my-mew-orig-case)
         (setq my-mew-orig-case nil))))
(ad-activate 'mew-net-disp-info-display)
(provide 'joseph-mew-retrieve-all)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-mew-retrieve-all.el ends here
