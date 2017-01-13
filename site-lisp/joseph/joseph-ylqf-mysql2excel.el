;;; joseph-ylqf-mysql2excel.el --- 将mysql数据库 导成excel xml 格式的表格

;; Description: Description
;; Created: 2012-04-09 11:23
;; Last Updated: Joseph 2012-08-15 00:44:59 星期三
;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords:
;; URL: http://www.emacswiki.org/emacs/download/joseph-ylqf-mysql2excel.el

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
;;  `erlang-mysql-excel-export'
;;    generate excel about mysql tables info.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:

(require 'mysql-query)
(require 'nxml-mode)

(defvar mysql-connection-4-mysql-erlang-excel nil)
(defvar row-count 0)

;;;###autoload
(defun erlang-mysql-excel-export()
  "generate excel about mysql tables info."
  (interactive)
  (read-excel-temp)
  )
 ;; (erlang-mysql-query-all-tablename-in-db mysql-connection-4-mysql-erlang-excel)
(defun erlang-mysql-query-all-tablename-in-db(mysql-connection-4-mysql-erlang-excel)
  "query all table name from connected mysql `mysql-query.el'"
  (mapcar 'car (mysql-query
                (format "select table_name from information_schema.tables where table_schema='%s'"
                        (cdr (assoc 'dbname mysql-connection-4-mysql-erlang-excel)))
                mysql-connection-4-mysql-erlang-excel)))

 ;; (erlang-mysql-query-column-info "user" mysql-connection-4-mysql-erlang-excel)
(defun erlang-mysql-query-column-info (tablename mysql-connection-4-mysql-erlang-excel)
  "query all column name and data type ."
  (mysql-query
   (format "select column_name,COLUMN_TYPE,COLUMN_COMMENT from information_schema.columns where table_schema ='%s' and  table_name='%s' "
           (cdr (assoc 'dbname mysql-connection-4-mysql-erlang-excel)) tablename)
   mysql-connection-4-mysql-erlang-excel)
  )

(defun read-excel-temp()
  (setq row-count 0)
  (with-temp-buffer
    (erase-buffer)
    (insert-file-contents (expand-file-name "~/.emacs.d/resource/mysql_table_to_excel_temple.xml"))
    (goto-char (point-min))
    (when (search-forward "$$$ROWS$$$" )
      (delete-region (match-beginning 0) (match-end 0))
      (let ((mysql-connection-4-mysql-erlang-excel (call-interactively 'mysql-query-create-connection)))
        (dolist (tablename  (erlang-mysql-query-all-tablename-in-db mysql-connection-4-mysql-erlang-excel))
          (insert-table-name-row tablename)
          (insert-table-header-row)
          (let (column-name column-type column-comment)
            (dolist (column-info (erlang-mysql-query-column-info tablename mysql-connection-4-mysql-erlang-excel))
              (setq column-name (car column-info))
              (setq column-type (nth 1 column-info))
              (setq column-comment (nth 2 column-info))
              (insert-table-column-data-row column-name column-type column-comment)
              )
            )
          (insert-tow-emply-line)
          )
        )
      )
    (goto-char (point-min))
    (when (search-forward "$$$rowcount$$$" )
      (delete-region (match-beginning 0) (match-end 0))
      (insert (format "%d" row-count))
      )
    (nxml-mode)
    (indent-region (point-min) (point-max))
    (let ((random-file  (expand-file-name (format "%d%s" (random 100000) "-mysql-excel.xml" ) temporary-file-directory)))
      (write-file random-file)
      (dired random-file)
      )
    )
  )

(defun insert-table-name-row(table-name)
    (insert "   <Row ss:AutoFitHeight=\"0\">\n")
    (insert "<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s63\"><Data ss:Type=\"String\">" table-name "</Data></Cell>\n")
    (insert "   </Row>\n")

  (setq row-count (1+ row-count))
  )
(defun insert-table-header-row( )
    (insert "   <Row ss:AutoFitHeight=\"0\">\n")
    (insert "    <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">字段</Data></Cell>\n")
    (insert "  <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">类型</Data></Cell>\n")
    (insert "    <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">注释</Data></Cell>\n")
    (insert " </Row>\n")

  (setq row-count (1+ row-count))
  )

(defun insert-table-column-data-row( mysql-column mysql-column-type mysql-column-comment)
    (insert "   <Row ss:AutoFitHeight=\"0\">\n")
    (insert "    <Cell><Data ss:Type=\"String\">" mysql-column "</Data></Cell>\n ")
    (insert "    <Cell><Data ss:Type=\"String\">" mysql-column-type "</Data></Cell>\n")
    (insert "    <Cell><Data ss:Type=\"String\">" mysql-column-comment "</Data></Cell>\n")
    (insert "   </Row>\n")

  (setq row-count (1+ row-count))
  )
(defun insert-tow-emply-line()
    (insert "     <Row ss:AutoFitHeight=\"0\">\n")
    (insert "    <Cell ss:MergeAcross=\"2\" ss:MergeDown=\"1\" ss:StyleID=\"s66\"/>\n")
    (insert "   </Row>\n")
    (insert "   <Row ss:AutoFitHeight=\"0\"/>\n")
  (setq row-count (+ 2 row-count))
  )

(provide 'joseph-ylqf-mysql2excel)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-ylqf-mysql2excel.el ends here
