;;; joseph-kill-emacs.el --- kill emacs hook   -*- coding:utf-8 -*-

;; Description: kill emacs hook
;; Time-stamp: <Joseph 2011-09-12 19:41:14 星期一>
;; Created: 2011-09-12 19:16
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords: kill emacs
;; URL: http://www.emacswiki.org/emacs/joseph-kill-emacs.el

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
(eval-when-compile
  (require 'joseph_byte_compile_include)
  (require 'helm-adaptive)
  (require 'auto-complete)
  (require 'savehist)
  (require 'recentf)
  (require 'ido)
  (require 'ob)
  (require 'saveplace)
  )
;; "这里面的内容本来为`kill-emacs-hook'中的函数，但在在linux emacs --daemon
;; 模式下，似乎`kill-emacs-hook'没有运行。故移到`delete-frame-functions'中"
(defun save-emacs-session(&optional frame)
  (when (member 'helm-adaptive-save-history kill-emacs-hook)
    (helm-adaptive-save-history))
  (when (member 'ac-comphist-save kill-emacs-hook)
    (ac-comphist-save))
  (when (member 'recentf-save-list kill-emacs-hook)
    (recentf-cleanup)
    (recentf-save-list))
  (when (member 'org-babel-remove-temporary-directory kill-emacs-hook)
    (org-babel-remove-temporary-directory))
  (when (member 'savehist-autosave kill-emacs-hook)
    (savehist-autosave))
  (when (member 'ido-kill-emacs-hook kill-emacs-hook)
    (ido-kill-emacs-hook))
  (when (member 'save-place-kill-emacs-hook kill-emacs-hook)
    (save-place-kill-emacs-hook))
  )

;; (add-hook 'delete-frame-functions 'save-emacs-session)

;; (defvar save-emacs-session-interval (* 60  5));;10*60s
(run-with-idle-timer 300 t 'save-emacs-session) ;idle 300=5*60s

;; (run-at-time t  save-emacs-session-interval 'save-emacs-session)


(provide 'joseph-kill-emacs)
;;; joseph-kill-emacs.el ends here间隔
