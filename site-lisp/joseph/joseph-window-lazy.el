
;;; C-x2 ,C-x3 更好的分隔窗口
;;----------------------------------------------------------------------------
;; When splitting window, show (other-buffer) in the new window
;;----------------------------------------------------------------------------
(defvar split-window-status nil)
;;;###autoload
(defun split-window-func-with-other-buffer-horizontally()
  (interactive)
  (split-window-horizontally)
  (setq split-window-status 'horizontally)
  (set-window-buffer (next-window) (other-buffer))
  )
;;;###autoload
(defun split-window-func-with-other-buffer-vertically()
  (interactive)
  (split-window-vertically)
  (setq split-window-status 'vertically)
  (set-window-buffer (next-window) (other-buffer))
  )


;;----------------------------------------------------------------------------
;; Rearrange split windows
;;----------------------------------------------------------------------------
;;;###autoload
(defun toggle-split-window-horizontally-vertically()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (if (equal split-window-status 'horizontally)
        (split-window-func-with-other-buffer-vertically)
      (split-window-func-with-other-buffer-horizontally)
      )
    ))

;;;###autoload
(defun gui-frame-cnt()
  (let ((gui-frame-cnt 0))
    (dolist (frame (visible-frame-list))
      (with-selected-frame frame
        (when (frame-parameter frame 'window-id)
          (setq gui-frame-cnt (1+ gui-frame-cnt)))))
    gui-frame-cnt))


(provide 'joseph-window-lazy)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-window-lazy.el ends here
