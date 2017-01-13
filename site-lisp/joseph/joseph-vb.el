;;; joseph-vb.el --- Visual Bisic Mode   -*- coding:utf-8 -*-

;; Description: Visual Bisic Mode
;; Created: 2012-01-09 14:59
;; Last Updated: Joseph 2012-01-15 11:58:32 星期日
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords:vb windows
;; URL: http://www.emacswiki.org/emacs/joseph-vb.el

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

;;;###autoload
(defun run-vb()
  (interactive)
  ;; call autohotkey script ,to active Microsoft Visual Basic IDE
  (clipboard-kill-ring-save (point-min) (point-max))
  (shell-command "active-vb-ide.ahk")   ;in ~/.emacs.d/bin/
  )
(setq-default visual-basic-mode-indent 4)
(provide 'joseph-vb)
;;; joseph-vb.el ends here
