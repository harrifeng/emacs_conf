;;; joseph-outline.el --- outline-mode outline-minor-mode ;; -*- coding:utf-8 -*-

;; Copyright (C) 2011 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords: outline folding

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
    (require 'joseph-outline-lazy)
  )

;;;; 不同major mode 下启用outline-minor-mode 的hook
(add-hook 'c++-mode-hook 'el-outline-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'el-outline-mode-hook)
(add-hook 'lisp-interaction-mode-hook 'el-outline-mode-hook)
(add-hook 'java-mode-hook 'java-outline-mode-hook)

;; (add-hook 'outline-minor-mode-hook 'hide-body) ;
(add-hook 'erlang-mode-hook 'erlang-outline-mode-hook)

;; (require 'fold-dwim)
;; (define-prefix-command 'M-c-map)
;; (global-set-key (kbd "M-c") 'M-c-map)
;; (global-set-key  "\M-c\M-c" 'fold-dwim-toggle)

;;(global-set-key (kbd "<M-f7>")    'fold-dwim-hide-all)
;;(global-set-key (kbd "<S-M-f7>")  'fold-dwim-show-all)

(provide 'joseph-outline)


;;; joseph-outline.el ends here
