;;; joseph-gtalk.el --- gtalk jabberEL   -*- coding:utf-8 -*-

;; Description: gtalk jabberEL
;; Created: 2011-11-10 01:17
;; Last Updated: 纪秀峰 2013-12-11 10:32:41 
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords: gtalk
;; URL: http://www.emacswiki.org/emacs/joseph-gtalk.el

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
  (require 'joseph-keybinding)
  )
;;; doc
;; 我配成C-wC-j 作为jabber的前缀
;;C-wC-jC-jC-h 列出可用的键

;;C-wC-jC-j进行连接
;;C-wC-jC-r转到gtalk主界面
;;C-wC-jC-j选择要交谈的好友

;; 在roster-buffer的绑定
;; (define-key map "\C-c\C-c" 'jabber-popup-chat-menu)
;; (define-key map "\C-c\C-r" 'jabber-popup-roster-menu)
;; (define-key map "\C-c\C-i" 'jabber-popup-info-menu)
;; (define-key map "\C-c\C-m" 'jabber-popup-muc-menu)
;; (define-key map "\C-c\C-s" 'jabber-popup-service-menu)

;;; config
(require 'jabber-autoloads nil t)
(setq-default jabber-default-status "http://jixiuf.github.com/links.html http://code.google.com/p/screencast-repos/downloads/list  http://www.emacswiki.org/emacs/Joseph")
(setq-default jabber-avatar-cache-directory "~/.emacs.d/cache/jabber-avatars/")

(define-key ctl-w-map "\C-j" jabber-global-keymap)
(define-key ctl-x-map "\C-j" 'dired-jump) ;恢愎 C-xC-j 为dired-jump
(define-key jabber-global-keymap "\C-c" 'jabber-connect )
(eval-after-load 'jabber-keymap '(progn (define-key ctl-x-map "\C-j" 'dired-jump )));恢愎 C-xC-j 为dired-jump

(setq-default jabber-alert-info-wave (expand-file-name "~/.emacs.d/resource/ding.wav"))
(setq-default jabber-alert-message-wave  (expand-file-name "~/.emacs.d/resource/ding.wav")) ;消息来
;; (setq-default jabber-alert-message-hooks (quote (jabber-message-awesome jabber-message-wave jabber-message-echo jabber-message-switch jabber-message-scroll)))
;; (setq jabber-alert-muc-wave  (expand-file-name "~/.emacs.d/resource/ding.wav"))
(setq-default jabber-alert-presence-wave (expand-file-name "~/.emacs.d/resource/horse.wav")) ;有请求加好友,好友状态变化
;; (setq-default jabber-alert-presence-hooks (quote (jabber-presence-awesome jabber-presence-wave jabber-presence-echo)))

(defun tooltip-msg (msg &optional title )
  (tooltip-show
   (format "%s\n\n%s\n" (or title "") msg )))
(eval-after-load 'jabber-alert
  '(progn (define-jabber-alert tooltip "using tooltip show message " 'tooltip-msg)))

;; (setq-default jabber-alert-message-hooks (quote (jabber-message-tooltip jabber-message-wave jabber-message-echo jabber-message-switch jabber-message-scroll)))
(setq-default jabber-alert-message-hooks (quote ( jabber-message-wave jabber-message-echo jabber-message-switch jabber-message-scroll)))
(setq-default jabber-alert-presence-hooks (quote (jabber-presence-echo)))




(provide 'joseph-gtalk-lazy)
;;; joseph-gtalk.el ends here
