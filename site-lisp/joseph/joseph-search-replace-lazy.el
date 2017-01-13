;;; joseph-search-replace.el --- search and replace custom   -*- coding:utf-8 -*-
(eval-when-compile (require 'compile))
;; Last Updated: 纪秀峰 2013-12-11 10:41:19 
;; Created: 2011-09-08 00:42
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords:isearch
;; URL: http://www.emacswiki.org/emacs/joseph-isearch.el

;; Copyright (C) 2011, 纪秀峰, all rights reserved.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Commands:
;;
;; Below are complete command list:
;;
;;  `joseph-forward-symbol'
;;    直接搜索当前`symbol',并跳到相应位置
;;  `joseph-backward-symbol'
;;    直接搜索当前`symbol',并跳到相应位置(反向)
;;  `joseph-forward-symbol-or-isearch-regexp-forward'
;;    `C-s' call `isearch-forward-regexp'
;;  `joseph-backward-symbol-or-isearch-regexp-backward'
;;    `C-s' call `joseph-backward-symbol'
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;
;;  `joseph-highlight-delay'
;;    *How long to highlight the tag.
;;    default = 0.3

;;; Code:

(eval-when-compile
  (require 'joseph_byte_compile_include)
  (require 'thingatpt)
  (require 'helm))

;;;; 渐近搜索注释
;;进入搜索模式之后，几个好用的按键
;;`C-w' 把光标下的word作为搜索关键字，可多次按下`C-w'
;;`M-y' 将`king-ring'中的内容取出作为搜索关键字
;;`M-e'光标跳到minibuffer，编辑关键字
;;`M-%' 改为用query-replace替换
;;`C-M-%' 改为用query-regex-replace替换
;;`M-r' 在正则与非正则之切换
;;`M-c' 是否忽略大小写

;;;; 停留在匹配字串的开端
;;Emacs下c-s对应渐进搜索。不过我们更多的时候需要搜索某种模式，所以用得最多的
;;还是渐进式的正则表达式搜索。正则表达式搜索有个烦人的问题：搜索结束时光标不
;;一定停留在匹配字串的开端。幸好这个问题容易解决：头两行重新绑定标准搜索键
;;c-s和c-r，把isearch换成regex-isearch。后面三行加入定制函数。关键的语句是
;;(goto-char isearch-other-end)，保证光标停留在匹配字串的开头，而不是缺省的末
;;尾。
;; ;;;###autoload
;; (defun my-goto-match-beginning ()
;;   (when isearch-forward  (goto-char (or isearch-other-end (point)))))

;; ;; Always end searches at the beginning of the matching expression.

;; ;;; vim like # and *
;; ;; 其操作基本等同于: M-b C-s C-w C-s.
;; ;; (defcustom joseph-highlight-delay 0.3
;; ;;   "*How long to highlight the tag.
;; ;;   (borrowed from etags-select.el)"
;; ;;   :type 'number
;; ;;     :group 'convenience
;; ;;   )

;; ;; (defface joseph-highlight-region-face
;; ;;   '((t (:foreground "white" :background "cadetblue4" :bold t)))
;; ;;   "Font Lock mode face used to highlight tags.
;; ;;   (borrowed from etags-select.el)"
;; ;;   :group 'faces
;; ;;   )

;; ;; (defun pulse-momentary-highlight-region (beg end)
;; ;;   "Highlight a region temporarily.
;; ;;    (borrowed from etags-select.el)"
;; ;;   (if (featurep 'xemacs)
;; ;;       (let ((extent (make-extent beg end)))
;; ;;         (set-extent-property extent 'face 'joseph-highlight-region-face)
;; ;;         (sit-for joseph-highlight-delay)
;; ;;         (delete-extent extent))
;; ;;     (let ((ov (make-overlay beg end)))
;; ;;       (overlay-put ov 'face 'joseph-highlight-region-face)
;; ;;       (sit-for joseph-highlight-delay)
;; ;;       (delete-overlay ov))))

;; (autoload 'pulse-momentary-highlight-region "pulse")


;; ;;;###autoload
;; (defun joseph-forward-symbol(&optional symbol)
;;   "直接搜索当前`symbol',并跳到相应位置"
;;   (interactive)
;;   (let* ((current-symbol (or symbol  (thing-at-point 'symbol)))
;;          (re-current-symbol)
;;          (case-fold-search nil) )
;;     (if (not  current-symbol)
;;         (isearch-mode t t) ;;when no symbol here ,use isearch
;;       (setq re-current-symbol (concat "\\_<" (regexp-quote current-symbol) "\\_>"))
;;       (forward-char) ;;skip current word
;;       (if (re-search-forward re-current-symbol nil t)
;;           (progn
;;             (pulse-momentary-highlight-region (match-beginning 0) (match-end 0))
;;             (goto-char (match-beginning 0))
;;             (isearch-update-ring current-symbol t)
;;             )
;;         (goto-char (point-min))
;;         (if (re-search-forward re-current-symbol nil t)
;;             (progn
;;               (pulse-momentary-highlight-region (match-beginning 0) (match-end 0))
;;               (goto-char (match-beginning 0))
;;               (isearch-update-ring current-symbol t))
;;           (message " Not found"))
;;         ))))

;; ;;;###autoload
;; (defun joseph-backward-symbol (&optional symbol)
;;   "直接搜索当前`symbol',并跳到相应位置(反向)"
;;   (interactive)
;;   (let* ((current-symbol (or symbol (thing-at-point 'symbol)))
;;          (re-current-symbol)
;;          (case-fold-search nil))
;;     (if (not current-symbol)
;;         (isearch-mode nil t) ;;when no symbol here ,use isearch
;;       (setq re-current-symbol (concat "\\_<" (regexp-quote current-symbol) "\\_>"))
;;       (forward-char)
;;       (if (re-search-backward re-current-symbol nil t)
;;           (progn
;;             (goto-char (match-beginning 0))
;;             (pulse-momentary-highlight-region (match-beginning 0) (match-end 0))
;;             (isearch-update-ring current-symbol t)
;;             )
;;         (goto-char (point-max))
;;         (if (re-search-backward re-current-symbol nil t)
;;             (progn (goto-char (match-beginning 0))
;;                    (pulse-momentary-highlight-region (match-beginning 0) (match-end 0))
;;                    (isearch-update-ring current-symbol t)
;;                    )
;;           (message "Not found")))
;;       )))

;; ;;;###autoload
;; (defun  joseph-forward-symbol-or-isearch-regexp-forward(&optional param)
;;   "`C-s' call `isearch-forward-regexp'
;; `C-uC-s' call `joseph-forward-symbol'
;; when `mark-active' then use selected text as keyword
;; `C-s' call `joseph-forward-symbol'
;; `C-uC-s' call `isearch-forward-regexp'"
;;   (interactive "P")
;;   (if (not  mark-active)
;;       (if param
;;           (isearch-forward-regexp)
;;         (call-interactively  'joseph-forward-symbol))
;;     (let ((keyword  (buffer-substring (region-beginning) (region-end))))
;;       (setq mark-active nil)
;;       (if param
;;           (joseph-forward-symbol keyword)
;;         (isearch-mode t t)
;;         (isearch-yank-string keyword)
;;         (isearch-search-and-update)
;;         )
;;       )))

;; ;;;###autoload
;; (defun  joseph-backward-symbol-or-isearch-regexp-backward(&optional param)
;;   "`C-s' call `joseph-backward-symbol'
;; `C-uC-s' call `isearch-backward-regexp'
;; when `mark-active' then use selected text as keyword
;; `C-s' call `isearch-backward-regexp'
;; `C-uC-s' call  `joseph-backward-symbol'"
;;   (interactive "P")
;;   (if (not  mark-active)
;;       (if param
;;           (isearch-backward-regexp)
;;         (call-interactively  'joseph-backward-symbol))
;;     (let ((keyword  (buffer-substring (region-beginning) (region-end))))
;;       (setq mark-active nil)
;;       (if  param
;;           (joseph-backward-symbol keyword)
;;         (isearch-mode nil t)
;;         (isearch-yank-string keyword)
;;         (isearch-search-and-update)
;;         ))))
;; ;;wgrep
;; ;;;###autoload
;; (defun grep-mode-fun()
;;   ;; grep-mode 继承自 compile-mode
;;   (set (make-local-variable 'compilation-auto-jump-to-first-error) nil);;
;;   (set (make-local-variable 'compilation-scroll-output) t))

(provide 'joseph-search-replace)
;;; joseph-isearch.el ends here
