;;; joseph-as-lazy.el --- Description

;; Description: Description
;; Created: 2012-10-16 00:26
;; Last Updated: 纪秀峰 2013-01-16 10:16:03 星期三
;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords:
;; URL: http://www.emacswiki.org/emacs/download/joseph-as-lazy.el

;; Copyright (C) 2012, 纪秀峰, all rights reserved.

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

;;; Code:

;;;; Useful functions -------------------------------------------------------------
(eval-when-compile
  (require 'cl)
  (require 'actionscript-mode)
  )


(defun string-char-replace(string oldchar newchar)
	"Return a new string where all occurrences of oldchar
have been replaced with newchar."
	(let ((new-string (copy-sequence string)))
		(do ((i 0 (1+ i)))
				((= i (length new-string)) nil)
			(let ((x (aref new-string i)))
				(when (char-equal x oldchar)
					(setf (aref new-string i) newchar))))
		new-string))


(defun as-get-package()
	"Based on the file path to the current buffer, returns the package string."
	(let* ((wholePath buffer-file-name)
				 (filename (file-name-nondirectory wholePath))
				 (className (file-name-sans-extension filename))
				 (package-regexp (concat "^.*/as/\\(.*?\\)/" filename)))
			;; We use a regexp to grab everything in the path between the as (root) directory and this file.
			;; We'll break this apart to get a list of package names.
			(when (string-match package-regexp wholePath)
				(let ((modified-path (match-string 1 wholePath)))
					(string-char-replace modified-path ?/ ?.)))))

(defun as-get-classname()
	"Based on the buffer's filename, return the classname for this buffer."
	(file-name-sans-extension (file-name-nondirectory buffer-file-name)))
;;;###autoload
(defun insert-flash-boilerplate()
	"When we open a new AS file, automatically insert some boilerplate
code. This function expects that your AS root starts
with a directory named 'as' from which it builds package names."
	(when (string= (file-name-extension (buffer-file-name)) "as")
		(let ((className (as-get-classname))
					(package-string (as-get-package)))
			(insert (concat "package " package-string "{\n\n  public class " className "{\n\n    public function " className "(){\n\n    }\n\n    public function toString():String{\n      return \"<< " className " >>\";\n    }\n  }\n}\n")))))

;;;###autoload
(defun as-print-func-info()
	"Insert a print statement immediately after the nearest function definition before point."
	(interactive)
	(save-excursion
		(re-search-backward as-function-re)
		(goto-char (match-end 0))
		(let ((modifier1 (match-string 1))
					(modifier2 (match-string 2))
					(function (match-string 3))
					(args (match-string 4))
					(return-type (match-string 5))
					(debug-msg "")
					(first-part "\"")
					(arg-trace "\""))

			;; Check if we should add "this."
			(unless (or (string= modifier1 "static")
									(string= modifier2 "static"))
					(setf first-part "this + \"."))

			;; Parse arguments.
			(when (> (length args) 0)

				(let ((arg-string (mapconcat (function (lambda (x)
																			 ;; chop off any type info
																			 (car (split-string x ":"))))
																		 (split-string args ",")
																		 " +\", \"+ ")))

					(setf arg-trace (concat " : \" + " arg-string))))

			;;now, print out our debug statement after the function start
			(setf debug-msg (concat "trace(" first-part function "(" args ")" arg-trace ");"))
			(insert (concat "\n" debug-msg))
			(indent-according-to-mode)
			(message debug-msg))))
;;;###autoload
(defun as-insert-trace ()
	"Insert an empty trace call at point. If we are over a word, then trace that word on the next line"
	(interactive)
	(let ((trace-cmd "trace")
				(cw (current-word)))
		(cond
			((or (null cw)
					 (string= cw ""))
			 ;; point is not over a word.
			 (indent-according-to-mode)
			 (insert (format "%s(\"\");" trace-cmd))
			 (backward-char 3))
			(t
			 ;; point is over a word.
			 (end-of-line)
			 (insert (format "\n%s(\"%s: \" + %s);" trace-cmd cw cw))
			 (indent-according-to-mode)))))

(provide 'joseph-as-lazy)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-as-lazy.el ends here
