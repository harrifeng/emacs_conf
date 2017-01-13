(eval-when-compile (require 'evil))
;; 我会把此文件编译后的elc commit ,因为它几乎不会变化
;; http://vimcdoc.sourceforge.net/doc/motion.html
;; vim 里的 w 对单词进行操作，  此处定义一个o 对 symbol 进行操作
;; w  dw yw yaw daw
;; o  do yo yao dao
;; o光标移到下一个symbol的开头
;; O光标移到上一个symbol的开头


(evil-define-motion evil-forward-symbol-begin(count)
  "Move to the end of the COUNT-th next symbol."
  ;; :jump t
  :type exclusive
  (evil-signal-at-bob-or-eob count)
  (evil-forward-beginning 'evil-symbol count)
  (let ((sym (thing-at-point 'evil-symbol)))
    (while (and sym (not (string-match "\\<" sym)))
      (evil-forward-beginning 'evil-symbol 1)
      (setq sym (thing-at-point 'evil-symbol))
      )
    )
  )

(evil-define-motion evil-backward-symbol-begin(count)
  "Move to the end of the COUNT-th next symbol."
  ;; :jump t
  :type exclusive
  ;; (evil-signal-at-bob-or-eob count)
  ;; (forward-evil-symbol count)
  (evil-backward-beginning 'evil-symbol count)
  (let ((sym (thing-at-point 'evil-symbol)))
    (while (and sym (not (string-match "\\<" sym)))
      (evil-backward-beginning 'evil-symbol 1)
      (setq sym (thing-at-point 'evil-symbol)))))


(evil-define-motion evil-forward-symbol-end(count)
  "Move to the end of the COUNT-th next symbol."
  ;; :jump t
  :type exclusive
  (evil-signal-at-bob-or-eob count)
  (forward-evil-symbol count)

  ;; (let ((sym (thing-at-point 'evil-symbol)))
  ;;   (while (and sym (not (string-match "^\\<" sym)))
  ;;     (evil-forward-end 'evil-symbol 1)
  ;;     (setq sym (thing-at-point 'evil-symbol))
  ;;     )
  ;;   )
  )

(evil-define-motion evil-backward-symbol-end(count)
  "Move to the end of the COUNT-th next symbol."
  ;; :jump t
  :type exclusive
  (evil-signal-at-bob-or-eob count)
  (evil-backward-end 'symbol count)
  (let ((sym (thing-at-point 'evil-symbol)))
    (while (and sym (not (string-match "\\<" sym)))
      (evil-backward-end 'evil-symbol 1)
      (setq sym (thing-at-point 'evil-symbol))
      )
    )
)
;; 快速定义text-object的方法
;; ; between dollar signs:
;; (define-and-bind-text-object "$" "\\$" "\\$")
;; ; between pipe characters:
;; (define-and-bind-text-object "|" "|" "|")
;; ; from regex "b" up to regex "c", bound to k (invoke with "vik" or "vak"):
;; (define-and-bind-text-object "k" "b" "c")

;; (defmacro define-and-bind-text-object (key start-regex end-regex)
;;   (let ((inner-name (make-symbol "inner-name"))
;;         (outer-name (make-symbol "outer-name")))
;;     `(progn
;;        (evil-define-text-object ,inner-name (count &optional beg end type)
;;          (evil-select-paren ,start-regex ,end-regex beg end type count nil))
;;        (evil-define-text-object ,outer-name (count &optional beg end type)
;;          (evil-select-paren ,start-regex ,end-regex beg end type count t))
;;        (define-key evil-inner-text-objects-map ,key (quote ,inner-name))
;;        (define-key evil-outer-text-objects-map ,key (quote ,outer-name)))))


(provide 'joseph-evil-symbol)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-evil-symbol.el ends here

