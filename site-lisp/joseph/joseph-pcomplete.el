;;; joseph-pcomplete.el --- config for pcomplete

;; Description: config for pcompletion
;; Created: 2012-03-17 22:14
;; Last Updated: Joseph 2012-03-19 12:01:20 星期一
;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords: pcomplete shell completion
;; URL: http://www.emacswiki.org/emacs/download/joseph-pcomplete.el

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

;;shell mode ，eshell mode 的补全从emacs24.1之后都使用pcompletin进行补全，
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

(require 'pcomplete)
;;;; git
;; http://www.masteringemacs.org/articles/2012/01/16/pcomplete-context-sensitive-completion-emacs/
;; 使用 pcomplete 的地方，在git 命令之后可补全的内容
(defconst pcmpl-git-commands
  '("add" "bisect" "branch" "checkout" "clone"
    "commit" "diff" "fetch" "grep"
    "init" "log" "merge" "mv" "pull" "push" "rebase"
    "reset" "rm" "show" "status" "tag" )
  "List of `git' commands")

(defvar pcmpl-git-ref-list-cmd "git for-each-ref refs/ --format='%(refname)'"
  "The `git' command to run to get a list of refs")

(defun pcmpl-git-get-refs (type)
  "Return a list of `git' refs filtered by TYPE"
  (with-temp-buffer
    (insert (shell-command-to-string pcmpl-git-ref-list-cmd))
    (goto-char (point-min))
    (let ((ref-list))
      (while (re-search-forward (concat "^refs/" type "/\\(.+\\)$") nil t)
        (add-to-list 'ref-list (match-string 1)))
      ref-list)))
;; 这个命令会在输入git 时，运行
(defun pcomplete/git ()
  "Completion for `git'"
  ;; Completion for the command argument.
  (pcomplete-here* pcmpl-git-commands)  ;git 命令后可跟的子命令在pcmpl-git-commands列表中
  ;; complete files/dirs forever if the command is `add' or `rm'
  (cond
   ((pcomplete-match (regexp-opt '("add" "rm")) 1) ;;在add ,与rm 命令后，补全文件名
    (while (pcomplete-here (pcomplete-entries))))
   ;; provide branch completion for the command `checkout'.
   ((pcomplete-match  (regexp-opt '("checkout"  "co"))  1) ;在checkout co 命令之后，提示，有哪些branch ,tag 等
    (pcomplete-here* (pcmpl-git-get-refs "heads")))))

;;;; 默认在ls 命令之后，好像不进行补全
(defun pcomplete/ls ()
  "Completion for `ls'"
  (pcomplete-here (pcomplete-dirs))
  )
(defun pcomplete/vi ()
  "Completion for `vi'"
  (pcomplete-here (pcomplete-entries))
  )
(provide 'joseph-pcomplete)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-pcomplete.el ends here
