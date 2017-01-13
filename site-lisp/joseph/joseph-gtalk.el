;;; joseph-gtalk.el --- gtalk jabberEL   -*- coding:utf-8 -*-

;; Description: gtalk jabberEL
;; Created: 2011-11-10 01:17
;; Last Updated: 纪秀峰 2012-12-02 19:46:47 星期日
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
;; (set-keymap-parent ctl-w-map helm-command-map)
(eval-when-compile (require 'joseph-keybinding))
(setq-default jabber-account-list '(
                            ("jixiuf@gmail.com"
                             ;; (:password. "zhao2170")
                             (:network-server . "talk.google.com")
                             (:port . 443)
                             (:connection-type . ssl))
                            ("hackjixf@gmail.com"
                             ;; (:password. "zhao2170")
                             (:network-server . "talk.google.com")
                             (:port . 443)
                             (:connection-type . ssl))
                            ))
(autoload 'jabber-connect "jabber" "Connect to the Jabber server and start a Jabber XML stream.\nWith prefix argument, register a new account.\nWith double prefix argument, specify more connection details." t)
(define-key ctl-wj-map (kbd "C-c") 'jabber-connect) ;C-wC-jC-c
(eval-after-load 'jabber '(require 'joseph-gtalk-lazy))

(provide 'joseph-gtalk)
;;; joseph-gtalk.el ends here
