;; -*- coding:utf-8 -*-
;;; joseph-oracle.el --- setup for using oracle sql

;; Copyright (C) 2010 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords: oracle sql

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
;;  `oracle-mode'
;;    start oracle in sqlplus-mode
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:
;;;_ oracle
;;这个包通过C-RET执行当前行的sql语句，将结果显示在另一个buffer，并进行非常好
;;的格式化

;;  (require 'plsql)
;;  (setq auto-mode-alist
;;    (append '(("\\.pls\\'" . plsql-mode) ("\\.pkg\\'" . plsql-mode)
;; 		("\\.pks\\'" . plsql-mode) ("\\.pkb\\'" . plsql-mode)
;; 		("\\.sql\\'" . plsql-mode) ("\\.PLS\\'" . plsql-mode)
;; 		("\\.PKG\\'" . plsql-mode) ("\\.PKS\\'" . plsql-mode)
;; 		("\\.PKB\\'" . plsql-mode) ("\\.SQL\\'" . plsql-mode)
;; 		("\\.prc\\'" . plsql-mode) ("\\.fnc\\'" . plsql-mode)
;; 		("\\.trg\\'" . plsql-mode) ("\\.vw\\'" . plsql-mode)
;; 		("\\.PRC\\'" . plsql-mode) ("\\.FNC\\'" . plsql-mode)
;; 		("\\.TRG\\'" . plsql-mode) ("\\.VW\\'" . plsql-mode))
;; 	      auto-mode-alist ))
;;
;;  M-x sqlplus will start new SQL*Plus session.
;;
;;  C-RET   execute command under point
;;  S-C-RET execute command under point and show result table in HTML
;;          buffer
;;  M-RET   explain execution plan for command under point
;;  M-. or C-mouse-1: find database object definition (table, view
;;          index, synonym, trigger, procedure, function, package)
;;          in filesystem
;;  C-cC-s  show database object definition (retrieved from database)
;;
(require 'sql)
(require 'sqlplus)
(require 'sqlparser-oracle-complete)




;;;###autoload
(defun oracle-mode()
  "start oracle in sqlplus-mode"
  (interactive)
  (setq sql-user "scott")
  (setq sql-database "scott")
  (setq sql-server "localhost")
  (eval-after-load 'sqlplus '(progn (setq sqlplus-html-output-encoding "utf-8")))
  (sqlplus-mode)
  (oracle-complete-minor-mode)
  (message ";;  C-RET   execute command under point
  S-C-RET execute command under point and show result table in HTML
          buffer
  M-RET   explain execution plan for command under point
  M-. or C-mouse-1: find database object definition (table, view
          index, synonym, trigger, procedure, function, package)
          in filesystem
  C-cC-s  show database object definition (retrieved from database)
"))

(provide 'joseph-oracle)
;;; joseph-oracle.el ends here
