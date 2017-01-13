;;; joseph-ace.el --- ace   -*- coding:utf-8 -*-

;; Description: ace
;; Created: 2011-10-11 22:49
;; Last Updated: 纪秀峰 2013-12-12 11:03:07 
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords: quick jump to special positin
;; URL: http://www.emacswiki.org/emacs/joseph-ace.el

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

;; 类似fast-nav.el 的一个模式
;;  the default sequence is
;; '(ace-jump-word-mode
;;   ace-jump-char-mode
;;   ace-jump-line-mode)
;; M-m           ==> ace-jump-word-mode
;; C-u M-m       ==> ace-jump-char-mode
;; C-u C-u M-m   ==> ace-jump-line-mode
;;比如 :`M-m' 之后,等侯你按下一个字母(比如a),然后它会用另外一组红色face的字母 标出
;;所有以此字母(a)开头的单词,可以多次操作,直到光标定位到你想要的位置
;; (defvar ace-jump-mode-submode-list
;;   '(ace-jump-char-mode
;;     ace-jump-word-mode
;;     ace-jump-line-mode)
;;   )


(provide 'joseph-ace)
;;; joseph-ace.el ends here
