;; -*- coding:utf-8 -*-
;;; joseph-perl.el --- Description

;; Copyright (C) 2011 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords:

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
;;;; byte compile
(eval-when-compile
  (require 'joseph_byte_compile_include)
  ;; (require 'outline)
  (require 'joseph-util)
  )
;; (declare-function outline-minor-mode "outline")
;;;; cperl
(setq-default cperl-invalid-face  'off)   ;不要用下划代替空格
(require 'cperl-mode)

(setq cperl-hairy t) ;;几乎开启cperl 的所有功能
;; (setq cperl-electric-keywords t) ;; if while 关键字后按空格，会expand
;; (setq cperl-electric-lbrace-space nil)
;; (setq cperl-auto-newline t)
(define-key-lazy cperl-mode-map ";" 'joseph-append-semicolon-at-eol)

;; (add-hook 'cperl-mode-hook 'perl-mode-hook-fun)
;; (defun perl-mode-hook-fun()
;;   (outline-minor-mode 1)
;;   (hs-minor-mode 1)
;;   (abbrev-mode)
;;   )


;;;; outline minor mode
;; (add-hook 'cperl-mode-hook 'outline-minor-mode-4-cperl-customizations)
;; (defvar my-cperl-outline-regexp
;;       (concat
;;        "^"                              ; Start of line
;;        "[ \\t]*"                        ; Skip leading whitespace
;;        "\\("                            ; begin capture group \1
;;        (join "\\|"
;;              "=head[12]"                  ; POD header
;;              "package"                    ; package
;;              "=item"                      ; POD item
;;              "sub"                        ; subroutine definition
;;              )
;;        "\\)"                            ; end capture group \1
;;        "\\b"                            ; Word boundary
;;        ))


;; (defun outline-minor-mode-4-cperl-customizations ()
;;   "cperl-mode customizations that must be done after cperl-mode loads"
;;   (defun cperl-outline-level ()
;;     (looking-at outline-regexp)
;;     (let ((match (match-string 1)))
;;       (cond
;;        ((eq match "=head1" ) 1)
;;        ((eq match "package") 2)
;;        ((eq match "=head2" ) 3)
;;        ((eq match "=item"  ) 4)
;;        ((eq match "sub"    ) 5)
;;        (t 7)
;;        )))

;;   (setq cperl-outline-regexp  my-cperl-outline-regexp)
;;   (setq outline-regexp        cperl-outline-regexp)
;;   (setq outline-level        'cperl-outline-level)
;;   )

(provide 'joseph-perl)
;;; joseph-perl.el ends here
