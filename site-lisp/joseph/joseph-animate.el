;; (defun hello ()
;;   "say bye-bye !"
;;   (interactive)
;;   ;; Make a suitable buffer to display the birthday present in.
;;   (switch-to-buffer (get-buffer-create "*bye*"))
;;   (erase-buffer)
;;   ;; Display the empty buffer.
;;   (sit-for 0)
;;   (animate-string " Emacs是什么?" 9)
;;   )
;;;###autoload
(defun hello()
  (interactive)
  (if (buffer-live-p (get-buffer  "*hello*"))
      (site-buffer-line-by-line)
    (switch-to-buffer (get-buffer-create "*hello*"))
    (insert "在*hello* 中插入内容，然后再调用此函数.")
    ))

(defvar animate-line-num 0)

;; (defun animate-get-line()
;;   (if (=  animate-line-num 25 )
;;       (setq animate-line-num 0)
;;     (setq animate-line-num (1+ animate-line-num))
;;     )
;;   )


(defun site-buffer-line-by-line ()
  "show content in *hello* buffer line by line "
  (interactive)
  (let (lines line-num
        (default-font (frame-parameter nil  'font)))
    (if (equal system-type 'gnu/linux)
        (set-frame-font "DejaVu Sans Mono:pixelsize=20")
      (set-frame-font "宋体:pixelsize=20")
        )
    (with-current-buffer "*hello*"
      (goto-char (point-min))
      (while (< (line-number-at-pos (point)) (count-lines (point-min) (point-max)))
        (add-to-list 'lines (buffer-substring-no-properties (point-at-bol) (point-at-eol)) t)
        (forward-line)
        )
      (add-to-list 'lines (buffer-substring-no-properties (point-at-bol) (point-at-eol)) t)
      )
    (switch-to-buffer (get-buffer-create "*hello-result*"))
    (setq animate-line-num 0)
    (erase-buffer)
    ;; Display the empty buffer.
    (sit-for 0)
    (dolist (line lines)
      (setq line-num (1+ animate-line-num))
      (when (= line-num 1) (erase-buffer))
      (unless (string-match "^[ \t]*$" line)
        (sit-for 1.0))
      (animate-string  line line-num 10)
      ;; (if (> (length line) 60)
      ;;     (progn
      ;;       (sit-for 1.0)
      ;;       (animate-string  (substring line  0 60) line-num 10)
      ;;       (sit-for 1.0)
      ;;       (animate-string  (substring line  60) line-num 10)
      ;;       )


      ;;   )
      )
;;    (set-frame-font default-font) ;;reset
    )
  )


