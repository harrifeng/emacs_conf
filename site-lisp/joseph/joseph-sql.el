;; -*- coding:utf-8 -*-
;;; joseph-sql.el --- sql config

;; Copyright (C) 2011 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords: sql sqlserver oracle mysql

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

(eval-when-compile (require 'sql))
(setq sql-input-ring-file-name "~/.emacs.d/cache/sql-cmd-hist")
(defun try-write-sql-hist()
  "kill-buffer方式退出时,不会自动写hist, 此处修复之."
  (when (equal major-mode 'sql-interactive-mode)
    (comint-write-input-ring)
    )
  )
(add-hook 'kill-buffer-hook 'try-write-sql-hist)
;;(setq comint-input-ring-size 500)

(setq sql-connection-alist
      `(("mysql-localhost-test"
         (sql-product 'mysql)
         (sql-user "root")
         (sql-server "localhost")
         (sql-database "test")
         (sql-port 3306))
        ("mysql-10-zaiko"
         (sql-product 'mysql)
         (sql-user "root")
         (sql-server "172.20.68.10")
         (sql-database "zaiko")
         (sql-port 3306))
        ("oracle"
         (sql-product 'oracle)
         (sql-user "scott")
         (sql-server "localhost")
         (sql-database "scott")
         ;; (sql-port 3306)
         )
        )
      )


;;; sqlserver custom
(setq sql-ms-options (quote ("-w" "65535" "-h" "20000" ))) ;长度设的长一点，免折行。分页20000行一页
(setq sql-ms-program "sqlcmd")                ; 不使用默认的osql.exe ,似乎sqlcmd 比osql快。,并且osql有被微软弃用的可能。
;; mysql optional
;; Make mysql not buffer sending stuff to the emacs-subprocess-pipes
;; -n unbuffered -B batch(tab separated) -f force(go on after error) -i ignore spaces -q no caching -t table format
;; (setq-default sql-mysql-options (quote ("-n" "-B" "-f" "-i" "-q" "-t")))
(setq sql-mysql-options '("-C" "-t" "-f" "-n")) ;; MS 上，mysql 不回显
;;; 在普通的sql mode 中以上命令的前提是当前buffer与*SQL* 进行了关联
;; `C-cC-b' send buffer content to *SQL* buffer中去执行。
;; `C-cC-r' send 选中区域到 *SQL* buffer中去执行。
;; `C-cC-c' (sql-send-paragraph)
;;下面这个hook，如果在启用*SQL* 时已经有sql-mode 的buffer了，则将其与*SQL* 进行关联
(add-hook 'sql-interactive-mode-hook 'my-sql-set-buffer)
(defun my-sql-set-buffer ()
  "Sets the SQLi buffer for all unconnected SQL buffers.
Called from `sql-interactive-mode-hook'."
  (let ((new-buffer (current-buffer)))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (unless (buffer-live-p sql-buffer)
          (setq sql-buffer new-buffer)
          (run-hooks 'sql-set-sqli-hook))))))

(defun sql-mode-hook-fun()
  (set (make-local-variable 'comment-start) "/* ")
  (set (make-local-variable 'comment-end) "*/")
  (setq comint-input-ignoredups t)      ;避免hist命令重复
  )
(add-hook 'sql-mode-hook 'sql-mode-hook-fun)
(add-hook 'sql-interactive-mode-hook 'sql-mode-hook-fun)



;;;; 将当前行的语句select 语句转化为update ,insert ,delete 等语名
;;`sql-to-update' `sql-to-insert' `sql-to-select' `sql-to-delete'
;; (require 'sql-transform)
;;;; sql beautify
(require 'joseph-sql-beautify)
;; (autoload 'mysql-mode "joseph-mysql" "mode for editing mysql script(fn &optional ARG)" t nil)
;; (autoload 'oracle-mode "joseph-oracle" " mode for editing oracle script(fn &optional ARG)" t nil)
;; (autoload 'sqlserver-mode "joseph-sqlserver" " mode for editing sqlserver script(fn &optional ARG)" t nil)


(provide 'joseph-sql)
;;; joseph-sql.el ends here
