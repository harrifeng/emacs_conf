;;; joseph-complete.el --- complete   -*- coding:utf-8 -*-

;; Description: complete
;; Created: 2011-10-07 13:49
;; Last Updated: 纪秀峰 2013-12-12 00:18:25 
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords: minibuffer complete
;; URL: http://www.emacswiki.org/emacs/joseph-complete.el

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
;;  `minibuffer-up-parent-dir'
;;    回到上一层目录.同时更新*Completions*
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:
;;;###autoload
(defun minibuffer-up-parent-dir()
  "回到上一层目录.同时更新*Completions*"
  (interactive)
  (goto-char (point-max))
  (let ((directoryp  (equal ?/ (char-before)))
        (bob         (minibuffer-prompt-end)))
    (while (and (> (point) bob) (not (equal ?/ (char-before))))  (delete-char -1))
    (when directoryp
      (delete-char -1)
      (while (and (> (point) bob) (not (equal ?/ (char-before))))  (delete-char -1)))))

;;;###autoload
;; (defun minibuf-define-key-func ()	;
;;   "`C-n' `C-p' 选择上下一个candidate"
;;   (define-key  minibuffer-local-completion-map (kbd "C-l") 'minibuffer-up-parent-dir)
;;   (define-key  minibuffer-local-map [?\H-m] 'exit-minibuffer)
;;   (define-key  minibuffer-local-map (kbd "C-v") 'yank)
;;   ;; (local-set-key (kbd "C-,") 'backward-kill-word)
;;   )



(provide 'joseph-minibuffer-lazy)
;;; joseph-complete.el ends here
