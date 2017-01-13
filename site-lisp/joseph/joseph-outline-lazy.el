;; ;;; joseph-outline.el --- outline-mode outline-minor-mode ;; -*- coding:utf-8 -*-

;; ;; Copyright (C) 2011 纪秀峰

;; ;; Author: 纪秀峰  jixiuf@gmail.com
;; ;; Keywords: outline folding

;; ;; This program is free software; you can redistribute it and/or modify
;; ;; it under the terms of the GNU General Public License as published by
;; ;; the Free Software Foundation, either version 3 of the License, or
;; ;; (at your option) any later version.

;; ;; This program is distributed in the hope that it will be useful,
;; ;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; ;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; ;; GNU General Public License for more details.

;; ;; You should have received a copy of the GNU General Public License
;; ;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; ;;; Commentary:

;; ;;

;; ;;; Commands:
;; ;;
;; ;; Below are complete command list:
;; ;;
;; ;;
;; ;;; Customizable Options:
;; ;;
;; ;; Below are customizable option list:
;; ;;

;; ;;; Code:
;; (declare-function outline-minor-mode "outline")

;; (eval-after-load 'outline
;;   '(progn
;; ;;;; 命令以此`M-c'为前缀
;;      (add-hook 'outline-minor-mode-hook
;;                (lambda () (local-set-key "\M-c"
;;                                          outline-mode-prefix-map)))



;; ;;;; 键绑定后缀
;;      (setq-default outline-mode-prefix-map
;;                    (let ((map (make-sparse-keymap)))
;;                      (define-key map "\M-c" 'outline-toggle-children);;这个好用

;;                      (define-key map "\M-h" 'hide-entry);这两一对 显隐当前标题
;;                      (define-key map "\M-j" 'show-entry)


;;                      (define-key map "\M-q" 'hide-sublevels);只显示第一级标题
;;                      (define-key map "\M-t" 'hide-body);这两一对与hide-sublevels 显示所有标题，包括子标题
;;                      (define-key map "\M-a" 'show-all)


;;                      (define-key map "\M-s" 'show-subtree) ;这两一对
;;                      (define-key map "\M-d" 'hide-subtree)
;;                      (define-key map "\M-k" 'show-branches)

;;                      (define-key map "@" 'outline-mark-subtree)

;;                      (define-key map "\M-n" 'outline-next-visible-heading)
;;                      (define-key map "\M-p" 'outline-previous-visible-heading)
;;                      (define-key map "\M-f" 'outline-forward-same-level)
;;                      (define-key map "\M-b" 'outline-backward-same-level)

;;                      (define-key map "\M-u" 'outline-up-heading) ;;移动到上层标题

;;                      (define-key map "\M-^" 'outline-move-subtree-up)
;;                      (define-key map "\M-v" 'outline-move-subtree-down)

;;                      (define-key map "\M-i" 'show-children)
;;                      (define-key map "\M-l" 'hide-leaves)

;;                      (define-key map "\M-o" 'hide-other);;隐藏当前标题以外的所有
;;                      (define-key map [(control ?<)] 'outline-promote)
;;                      (define-key map [(control ?>)] 'outline-demote)
;;                      (define-key map "\C-m" 'outline-insert-heading)
;;                      ;; Where to bind outline-cycle ?
;;                      map))

;;      ))
;; ;; (require 'outline)


;; ;;;###autoload
;; (defun el-outline-mode-hook()
;;     (make-local-variable 'outline-regexp)
;; ;;  (setq outline-regexp ";;;\\(;* [^ \t\n]\\|###autoload\\)\\|(defun\\|(defvar\\|(defmacs\\|(defcustom")
;; ;;  (setq outline-regexp ";;;\\(;* [^ \t\n]\\|###autoload\\)\\|(defun\\|(defmacs\\|(defadvice\\|(defvar\\|(defcustom\\|(defmacro")
;;     (setq outline-regexp ";;;\\(;* [^ \t\n]\\)")
;;   (outline-minor-mode 1)
;;   )
;; ;;;###autoload
;; (defun java-outline-mode-hook()
;;   (make-local-variable 'outline-regexp)
;;   ;;ok class  (setq outline-regexp "[ \t]*.*\\(class\\|interface\\)[ \t]+[a-zA-Z0-9_]+[ \t\n]*\\({\\|extends\\|implements\\)")
;;   ;; ok member  (setq outline-regexp "[ \t]*\\(public\\|private\\|static\\|final\\|native\\|synchronized\\|transient\\|volatile\\|strictfp\\| \\|\t\\)*[ \t]+\\(\\([a-zA-Z0-9_]\\|\\( *\t*< *\t*\\)\\|\\( *\t*> *\t*\\)\\|\\( *\t*, *\t*\\)\\|\\( *\t*\\[ *\t*\\)\\|\\(]\\)\\)+\\)[ \t]+[a-zA-Z0-9_]+[ \t]*(\\(.*\\))[ \t]*\\(throws[ \t]+\\([a-zA-Z0-9_, \t\n]*\\)\\)?[ \t\n]*{")
;;   ;;ok class+member (setq outline-regexp "\\(?:\\([ \t]*.*\\(class\\|interface\\)[ \t]+[a-zA-Z0-9_]+[ \t\n]*\\({\\|extends\\|implements\\)\\)\\|[ \t]*\\(public\\|private\\|static\\|final\\|native\\|synchronized\\|transient\\|volatile\\|strictfp\\| \\|\t\\)*[ \t]+\\(\\([a-zA-Z0-9_]\\|\\( *\t*< *\t*\\)\\|\\( *\t*> *\t*\\)\\|\\( *\t*, *\t*\\)\\|\\( *\t*\\[ *\t*\\)\\|\\(]\\)\\)+\\)[ \t]+[a-zA-Z0-9_]+[ \t]*(\\(.*\\))[ \t]*\\(throws[ \t]+\\([a-zA-Z0-9_, \t\n]*\\)\\)?[ \t\n]*{\\)" )
;;   (setq outline-regexp "\\(?:\\([ \t]*.*\\(class\\|interface\\)[ \t]+[a-zA-Z0-9_]+[ \t\n]*\\({\\|extends\\|implements\\)\\)\\|[ \t]*\\(public\\|private\\|static\\|final\\|native\\|synchronized\\|transient\\|volatile\\|strictfp\\| \\|\t\\)*[ \t]+\\(\\([a-zA-Z0-9_]\\|\\( *\t*< *\t*\\)\\|\\( *\t*> *\t*\\)\\|\\( *\t*, *\t*\\)\\|\\( *\t*\\[ *\t*\\)\\|\\(]\\)\\)+\\)[ \t]+[a-zA-Z0-9_]+[ \t]*(\\(.*\\))[ \t]*\\(throws[ \t]+\\([a-zA-Z0-9_, \t\n]*\\)\\)?[ \t\n]*{\\)" )
;;   (defun java-outline-level ()
;;     (looking-at outline-regexp)
;;     (let ((match (match-string 0)))
;;       (cond
;;        ((string-match "[ \t]*.*\\(class\\|interface\\)[ \t]+[a-zA-Z0-9_]+[ \t\n]*\\({\\|extends\\|implements\\)" match ) 1)
;;        (t 2))))
;;   (setq outline-level        'java-outline-level)
;;   (outline-minor-mode 1)
;;   )
;; ;;;###autoload
;; (defun erlang-outline-mode-hook()
;;   (make-local-variable 'outline-regexp)
;;   (setq outline-regexp "[ \t]*%%%\\(%* [^ \t\n]\\)")
;;   (outline-minor-mode 1)
;;   )



(provide 'joseph-outline-lazy)


;;; joseph-outline.el ends here
