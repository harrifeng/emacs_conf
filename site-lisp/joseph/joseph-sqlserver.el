;; -*- coding:utf-8 -*-
;;; joseph-sqlserver.el --- setup for MS SQL SERVER

;; Copyright (C) 2010 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords: sql server ms

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
;;  `sqlserver-mode'
;;    sqlserver mode
;;  `sqlserver-send-current-sql'
;;    send selected region or current sql.
;;  `sqlserver-create-table'
;;    做项目的时候用到的自动将excel表格格式的，创建成建表语句。region的格式如上面注释，注意顶格写
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:
;;;; byte compile
(eval-when-compile
  (require 'joseph_byte_compile_include)
  )
;;;; require
(require 'sql)
(require 'joseph-sql)
(require 'sqlparser-sqlserver-complete)

;;;; sqlserver-mode
(defvar sqlserver-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map sql-mode-map)
    (define-key map "\C-c\C-c" 'sqlserver-send-current-sql)
    (define-key map "\C-c\C-e" 'sqlserver-send-go)
    map))

;;;###autoload
(define-derived-mode sqlserver-mode sql-mode "MSSQL"
  "sqlserver mode"
  (sqlserver-complete-minor-mode))

(defun sqlserver-send-current-sql()
  "send selected region or current sql."
  (interactive)
  (if mark-active
      (sql-send-region (region-beginning) (region-end))
    (let((sql-bounds (bounds-of-sql-at-point-4-sqlserver)))
      (sql-send-region (car sql-bounds) (cdr sql-bounds))))
  (sql-send-string "go")
  )
(defun sqlserver-send-go()
   (interactive)
  (sql-send-string "go"))

;;;; sql-ms defadvice
;;;###autoload
(defadvice sql-ms (around start-sqlserver-complete-minor-mode activate)
  "enable `sqlserver-complete-minor-mode' minor mode."
  ad-do-it
  (sqlserver-complete-minor-mode))




;;;; sqlserver-create-table()
;;  sqlserver-create-table 会根据格式如下的一段内容，自动生成sql语句，创建这样一张表
;; STOCK_ID									IDENTITY
;; SEMIFINISHER_ID									INT
;; STOCK_WEIGHT									DECIMAL					18,2
;; STOCK_YEAR_MONTH									DATATIME
;; START_WEIGHT									DECIMAL					18,2
;; CREATE_DATETIME									DATETIME
;; CREATER_ID									NVARCHAR					20
;; UPDATE_DATETIME									DATETIME
;; UPDATER_ID									NVARCHAR					20
;; DELETE_FLG									NVARCHAR					1
;;;###autoload
(defun sqlserver-create-table (region-begin region-end)
  "做项目的时候用到的自动将excel表格格式的，创建成建表语句。region的格式如上面注释，注意顶格写"
  (interactive "r")
  (let ( (tablename (read-string "tablename:"))
         (region-string (buffer-substring-no-properties region-begin region-end))
         (case-fold-search t)
         column-scripts script)
    (with-temp-buffer
      (insert region-string)
      (insert "\n  ")
      (while (search-forward "datatime"  nil t)
        (replace-match "datetime" nil t))
      (goto-char (point-min))
      (while (<  (line-number-at-pos )(count-lines (point-min)(point-max) ))
        (beginning-of-line)
        (forward-sexp 2)
        (when (thing-at-point 'word)
          (if (string-match "nvarchar"  (thing-at-point 'word))
              (progn
                (forward-sexp)
                (backward-sexp)
                (insert "(")
                (forward-sexp)
                (insert ") not null,")
                )
            (if (string-match "int"  (thing-at-point 'word))
                (progn
                  (insert " not null,")
                  )
              (if (string-match "datetime"  (thing-at-point 'word))
                  (progn
                    (insert " not null,")
                    )
                (if (string-match "DECIMAL"  (thing-at-point 'word))
                    (progn
                      (forward-sexp)
                      (backward-sexp)
                      (insert "(")
                      (forward-sexp 2)
                      (insert ") not null,")
                      )
                  (if (string-match "identity"  (thing-at-point 'word))
                      (progn
                        (backward-sexp )
                        (insert " int ")
                        (forward-sexp)
                        (insert "(1, 1) NOT NULL,")
                        )
                    )
                  )

                )
              )
            )
          )
        (forward-line)(end-of-line)
        )
      (setq column-scripts (buffer-substring-no-properties (point-min) (point-max)))
      )
    (with-temp-buffer
      (insert (format "USE [HAIHUA_SMART];
       GO
       SET ANSI_NULLS ON;
       GO
       SET QUOTED_IDENTIFIER ON;
       GO
       CREATE TABLE [dbo].[%s] ( \n" tablename))

      (insert column-scripts "\n")
      (insert " )
       ON [PRIMARY];
       GO ")
      (setq script (buffer-substring-no-properties (point-min) (point-max)))
      )
    (let ((buf (make-temp-name "*sql-temp-sqlserver-create-table")))
      (switch-to-buffer buf)
      (with-current-buffer buf
        (sql-mode)
        (insert script)
        (indent-region (point-min) (point-max))
        )
      )


    )
  )
;;osql -U haihua -P hh  -S 172.20.68.10 -d HAIHUA_SMART -q "select * from sysobjects"

(provide 'joseph-sqlserver)
;;; joseph-sqlserver.el ends here
