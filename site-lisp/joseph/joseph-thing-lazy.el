
;;; Code:

;; (defun thingp (thing)
;;   (or (get thing 'bounds-of-thing-at-point)
;;       (get thing 'forward-op)
;;       (get thing 'beginning-op)
;;       (get thing 'end-op)
;;       (fboundp (intern-soft (concat "forward-" (symbol-name thing))))))

;; (defun list-thing ()
;;   (let (things)
;;     (mapatoms
;;      (lambda (atom)
;;        (if (thingp atom)
;;            (push atom things))))
;;     things))
;; (print (list-thing))

;; email sexp filename url
(defun mark-thing (thing)
  (if (stringp thing)
      (setq thing (intern thing)))
  (let ((bounds (bounds-of-thing-at-point thing)))
    (when bounds
      (goto-char (car bounds))
      (push-mark (cdr bounds) t transient-mark-mode)
      (setq deactivate-mark nil))))

;;;###autoload
(defun mark-email()
  (mark-thing 'email))

;;;###autoload
(defun mark-filename()
  (mark-thing 'filename))

;;;###autoload
(defun mark-url()
  (mark-thing 'url))

(provide 'joseph-thing-lazy)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-thing-lazy.el ends here
