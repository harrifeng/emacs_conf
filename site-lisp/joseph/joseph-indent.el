;;; joseph-indent.el --- indent    -*- coding:utf-8 -*-

;; Description: indent
;; Time-stamp: <Joseph 2011-08-29 19:12:54 星期一>
;; Created: 2011-08-29 19:09
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords:indent
;; URL: http://www.emacswiki.org/emacs/joseph-indent.el

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
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:

;; 粘贴的时候自动缩进
;; automatically indenting yanked text if in programming-modes
(defvar yank-indent-modes '(emacs-lisp-mode lisp-mode
                                            c-mode c++-mode js2-mode
                                            tcl-mode sql-mode
                                            perl-mode cperl-mode
                                            java-mode jde-mode
                                            lisp-interaction-mode
                                            LaTeX-mode TeX-mode
                                            scheme-mode clojure-mode)
  "Modes in which to indent regions that are yanked (or yank-popped)")

(defadvice yank (after indent-region activate)
  "If current mode is one of 'yank-indent-modes, indent yanked text (with prefix arg don't indent)."
  (if (member major-mode yank-indent-modes)
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil))))

(defadvice yank-pop (after indent-region activate)
  "If current mode is one of 'yank-indent-modes, indent yanked text (with prefix arg don't indent)."
  (if (member major-mode yank-indent-modes)
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil))))

;;
;; 按照等号对齐
;; Use M-x align-regexp (here, M-x align-regexp RET = RET). You can also add
;; an "alignment rule" to the variable align-rules-list, so that in future M-x
;; align will do it. See the documentation (C-h f align) for details.
;; int t=9;
;; Graphics g = new Graphics();
;; List<String> list = new List<String>();
;; 变
;; int          t    = 9;
;; Graphics     g    = new Graphics();
;; List<String> list = new List<String>();

(provide 'joseph-indent)
;;; joseph-indent.el ends here
