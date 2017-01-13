;;; mysql-table2record-4procedure.el --- mysql table2record for procedure

;; Description:mysql table2record for procedure
;; Last Updated: Joseph 2012-04-17 16:36:41 星期二
;; Created: 2012年04月03日 星期二 17时14分44秒
;; Author: 纪秀峰(Joseph)  jixiuf@gmail.com
;; Keywords: mysql procedure record
;; https://github.com/jixiuf/sqlparser
;;  call command : (mysql-table2record-4procedure-interactively)

;; Copyright (C) 2011~2012 纪秀峰(Joseph) all rights reserved.

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

;; require mysql-query.el
;;  call command :mysql-procedure-generate-records
;; it will connect to a mysql intance ,and export all the tables to procedure records

;;; Commands:
;;
;; Below are complete command list:
;;
;;  `mysql-procedure-generate-records'
;;    generate records from mysql tables
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:

(require 'mysql-query)
(require 'sql)
(defvar mysql-connection-4-mysql-procedure nil)

 ;; (mysql-procedure-query-all-tablename-in-db mysql-connection-4-mysql-procedure)
(defun mysql-procedure-query-all-tablename-in-db(mysql-connection-4-mysql-procedure)
  "query all table name from connected mysql `mysql-query.el'"
   (mysql-query
                (format "select table_name,table_comment from information_schema.tables where table_schema='%s'"
                        (cdr (assoc 'dbname mysql-connection-4-mysql-procedure)))
                mysql-connection-4-mysql-procedure)
  ;; (mapcar 'car)
   )

 ;; (mysql-procedure-query-table "user" mysql-connection-4-mysql-procedure)
(defun mysql-procedure-query-table (tablename mysql-connection-4-mysql-procedure)
  "query all column name and data type ."
  (mysql-query
   (format "SELECT column_name ,column_comment ,COLUMN_TYPE FROM information_schema.columns c WHERE c.table_schema = '%s' AND c.table_name = '%s' AND column_name NOT IN ( SELECT k.column_name FROM information_schema.KEY_COLUMN_USAGE k WHERE c.table_schema = k.table_schema AND c.table_name = k.table_name )"
    ;; "select column_name,column_comment,COLUMN_TYPE from information_schema.columns where table_schema ='%s' and  table_name='%s' and column_key !='PRI'"
           (cdr (assoc 'dbname mysql-connection-4-mysql-procedure)) tablename)
   mysql-connection-4-mysql-procedure)
)
(defun mapcar-head (fn-head fn-rest list)
  "Like MAPCAR, but applies a different function to the first element."
  (if list
      (cons (funcall fn-head (car list)) (mapcar fn-rest (cdr list)))))

;; (mysql-procedure-generate "user" mysql-connection-4-mysql-procedure)
(defun mysql-procedure-generate(tablename-tablecomment mysql-connection-4-mysql-procedure)
  "generate all setter getter of `tablename'"
  (let* (
         (col-type-alist (mysql-procedure-query-table (car tablename-tablecomment) mysql-connection-4-mysql-procedure))
         (procedure-name (car tablename-tablecomment))
         field-name
         )
    (with-temp-buffer
      (insert "DELIMITER $$\n")
      (insert "\n")
      (insert (format " drop procedure if exists `%s`$$\n" procedure-name))
      (insert "\n")
      (insert (format "create procedure `%s`(\n" procedure-name))
      (dolist (col-type-ele (cdr col-type-alist))
        (let ( (column-name (car col-type-ele))
               (column-comment (nth 1 col-type-ele))
               (column-type (nth 2 col-type-ele))
               )
          (insert (format "IN in%s %s,/*%s*/\n" column-name column-type column-comment))
          )
        )
      (let ( (column-name (car (car col-type-alist)))
             (column-comment (nth 1 (car col-type-alist)))
             (column-type (nth 2 (car col-type-alist)))
             )
        (insert (format "IN in%s %s /*%s*/\n" column-name column-type column-comment)))
      (insert ")\n")
      (insert "BEGIN\n")
      (insert (format "insert into `%s`(\n" (car tablename-tablecomment)))
      (dolist (col-type-ele (cdr col-type-alist))
        (let ( (column-name (car col-type-ele))
               (column-comment (nth 1 col-type-ele))
               (column-type (nth 2 col-type-ele))
               )
          (insert (format "`%s`, /*%s*/\n" column-name  column-comment))
          )
        )
      (let ( (column-name (car (car col-type-alist)))
             (column-comment (nth 1 (car col-type-alist)))
             (column-type (nth 2 (car col-type-alist)))
             )
        (insert (format "`%s` /*%s*/\n" column-name column-comment)))
      (insert ") values(\n")
      (dolist (col-type-ele (cdr col-type-alist))
        (let ( (column-name (car col-type-ele))
               (column-comment (nth 1 col-type-ele))
               (column-type (nth 2 col-type-ele))
               )
          (insert (format "in%s,/*%s*/\n" column-name column-comment))
          )
        )
      (let ( (column-name (car (car col-type-alist)))
             (column-comment (nth 1 (car col-type-alist)))
             (column-type (nth 2 (car col-type-alist)))
             )
        (insert (format " in%s /*%s*/\n" column-name column-comment)))
      (insert ");\n")
      (insert "END$$\n")
      (insert "DELIMITER ;\n")
      (buffer-string)
      )
    )
  )

;;;###autoload
(defun mysql-procedure-generate-records()
  "generate records from mysql tables"
  (interactive)
  (let ((mysql-connection-4-mysql-procedure (call-interactively 'mysql-query-create-connection)))
    (switch-to-buffer  "*mysql-procedures*")
    (with-current-buffer "*mysql-procedures*"
      (erase-buffer)
      (sql-mode)
      (dolist (tablname-table-comment   (mysql-procedure-query-all-tablename-in-db mysql-connection-4-mysql-procedure))
        (insert (mysql-procedure-generate tablname-table-comment mysql-connection-4-mysql-procedure))
        )
      ;; (indent-region (point-min) (point-max))
      )
    ))

(provide 'mysql-table2record-procedure)

;; Local Variables:
;; coding: utf-8
;; End:

;;; mysql-table2record-procedure.el ends here
