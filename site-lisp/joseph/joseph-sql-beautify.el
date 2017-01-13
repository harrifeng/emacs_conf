;; -*- coding:utf-8 -*-
;;; joseph-sql-beautify.el --- sql beautify config

;; Copyright (C) 2011 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords:sql beautify format code

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
;;  `sql-beautify'
;;    Beautify SQL. in region or current sql sentence.
;;  `mark-sql-at-point'
;;    select current sql at point.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:
;;;sql beautify 将，sql 语句更容易阅读，
;;http://www.emacswiki.org/emacs/SqlBeautify
;;后端需要java的支持.
(define-key sql-mode-map "\C-\M-\\" 'sql-beautify)
(define-key sql-interactive-mode-map "\C-\M-\\" 'sql-beautify)
(eval-after-load 'sqlplus
  '(progn (define-key sqlplus-mode-map  "\C-\M-\\" 'sql-beautify)))

(defun sql-beautify()
  "Beautify SQL. in region or current sql sentence."
  (interactive)
  (unless mark-active
    (let ((sql-bounds (bounds-of-sql-at-point) ))
      (set-mark (car  sql-bounds))
      (goto-char (cdr sql-bounds))))
  (sql-beautify-region (region-beginning) (region-end)))

(defun sql-beautify-region (beg end)
  "Beautify SQL in region between beg and END."
  ;;  (interactive "r")
  (if (equal system-type 'windows-nt)
      (setenv "CLASSPATH" (concat (getenv "CLASSPATH") ";" "d:\\.emacs.d\\script\\sqlbeautify\\blancosqlformatter-0.1.1.jar"))
    (setenv "CLASSPATH" (concat (getenv "CLASSPATH") ":" (getenv "HOME") "/.emacs.d/script/sqlbeautify/blancosqlformatter-0.1.1.jar")))
  (let ((beautified-sql)
        (old-dir default-directory)
        (win-config(current-window-configuration))
        )
    (cd "~/.emacs.d/script/sqlbeautify/")
    (shell-command-on-region beg end "java SqlBeautify" "*sqlbeautify*" nil)
    (with-current-buffer  "*sqlbeautify*"
      (goto-char (point-min))
      (while (search-forward "\^M" nil t) ;;delete ^m
        (replace-match "" nil nil))
      (setq beautified-sql (buffer-string)))
    (goto-char beg)
    (kill-region beg end)
    (insert beautified-sql)
    (kill-buffer "*sqlbeautify*")
    (cd old-dir)
    (set-window-configuration win-config)
    )
  nil)

(defun bounds-of-sql-at-point()
  "get start and end point of current sql."
  (let ((pt (point))begin end empty-line-p
        empty-line-p next-line-included tail-p)
    (when (and
           (looking-at "[ \t]*\\(\n\\|\\'\\)")
           (looking-back "[ \t]*;[ \t]*" (beginning-of-line)))
      (search-backward-regexp "[ \t]*;[ \t]*" (beginning-of-line) t)
      )
    (save-excursion
      (skip-chars-forward " \t\n\r")
      (re-search-backward ";[ \t\n\r]*\\|\\`\\|\n[\r\t ]*\n[^ \t]" nil t)
      (setq begin (point)))
    (save-excursion
      (skip-chars-forward " \t\n\r")
      (re-search-forward "\n[\r\t ]*\n[^ \t]\\|\\'\\|[ \t\n\r]*;" nil t)
      (unless (zerop (length (match-string 0)))
        (backward-char 1))
      (skip-syntax-backward "-")
      (setq end   (point)))
    (goto-char pt)
    (cons begin end)
    )
  )

;;;_ select sql sentence at point .
(defun mark-sql-at-point()
  "select current sql at point."
  (interactive)
  (unless mark-active
    (let ((sql-bounds (bounds-of-sql-at-point) ))
      (set-mark (car  sql-bounds))
      (goto-char (cdr sql-bounds))))
  )
(provide 'joseph-sql-beautify)
;;; joseph-sql-beautify.el ends here
