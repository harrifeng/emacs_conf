;; -*- coding:utf-8 -*-
;;; joseph-mysql.el --- setup for mysql

;; Copyright (C) 2010 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords: mysql sql

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
;;  `mysql-mode'
;;    mysql mode
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:

(require 'sqlparser-mysql-complete)


;;;###autoload
(define-derived-mode mysql-mode sql-mode "Mysql"
  "mysql mode"
  (mysql-complete-minor-mode))

(defun mysql-mode-setup()
  "start mysql ."
  (setq sql-user "root")
  ;;  (setq sql-password "root")
  (setq  sql-database "test")
  (setq sql-server "localhost")
  (setq sql-port 3306)
  )

(mysql-mode-setup)

;;;###autoload
(defadvice sql-mysql (around start-mysql-complete-minor-mode activate)
  "enable `mysql-complete-minor-mode' minor mode."
  ad-do-it
  (mysql-complete-minor-mode))

(provide 'joseph-mysql)
;;; joseph-mysql.el ends here
