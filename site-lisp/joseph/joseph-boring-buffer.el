;; -*- coding:utf-8 -*-
;;; joseph-boring-buffer.el --- 关于关闭某些讨厌的buffer

;; Copyright (C) 2011 纪秀峰

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords: buffer burery

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
;;  `my-clean-buffer-list'
;;    与`clean-buffer-list'不同处在
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:
;;;; bury some boring buffers,把讨厌的buffer移动到其他buffer之后


;; ;;;; 自动清除长久不访问的buffer
;; (require 'midnight)
;; (cancel-timer midnight-timer);;不使用midnight提供的那个timer
;; ;;kill buffers if they were last disabled more than this seconds ago
;; ;;如果一个buffer有3min没被访问了那么它会被自动关闭

;; (defun my-clean-buffer-list ()
;;   "与`clean-buffer-list'不同处在
;;   对于从来没有display过的buffer，如果又*开头，则认为可kill,否则不可kill"
;;   (interactive)
;;   (let ((tm (float-time)) bts (ts (format-time-string "%Y-%m-%d %T"))
;;         delay cbld bn)
;;     (dolist (buf (buffer-list))
;;       (when (buffer-live-p buf)
;;         (setq bts (midnight-buffer-display-time buf)
;;               bn (buffer-name buf)
;;               cbld (clean-buffer-list-delay bn))
;;         (setq delay (if bts (- tm bts);
;;                       (if (string-match "^\\*" (buffer-name buf)) (1+ cbld) 0)
;;                       ;; 对于从来没有display过的buffer，如果又*开头，则认为可kill,否则不可kill
;;                       ))
;;         ;; (message "[%s] `%s' [%s %d]" ts bn (if bts (round delay)) cbld)
;;         (unless (or (midnight-find bn clean-buffer-list-kill-never-regexps
;;                                    'string-match)
;;                     (midnight-find bn clean-buffer-list-kill-never-buffer-names
;;                                    'string-equal)
;;                     (get-buffer-process buf)
;;                     (and (buffer-file-name buf) (buffer-modified-p buf))
;;                     (get-buffer-window buf 'visible) (< delay cbld))
;;           ;; (message "[%s] killing `%s'" ts bn)
;;           (kill-buffer buf)))))

;;   (dolist (buf (buffer-list));;将所有又*开头的文件置为未modified,下次时kill之
;;     (when (and  (string-match "^\\*" (buffer-name buf))
;;                 (buffer-modified-p buf))
;;       (set-buffer buf)
;;       (set-buffer-modified-p nil)
;;       )
;;     )

;;   )

;; ;;自动清除某些buffer时,会输出一此很长的信息,我认为没用,暂时重新定义了`message'
;; ;; (defadvice clean-buffer-list (around no-message-output activate)
;; ;;   "Disable `message' when wrapping candidates."
;; ;;   ;; (flet ((message (&rest args)))
;; ;;   ;;   ad-do-it)
;; ;;   ad-do-it
;; ;;   )


;; ;;下面的buffer是例外,它们不会被auto kill
;; ;;这样的buffer不会被清除
;; ;; * currently displayed buffers
;; ;; * buffers attached to processes, and
;; ;; * internal buffers that were never displayed
;; ;; * buffers with files that are modified

;; (setq clean-buffer-list-kill-never-buffer-names
;;       '("*scratch*" "*Messages*" "*server*"))

;; (setq clean-buffer-list-kill-never-regexps
;;       '("^ \\*Minibuf-.*\\*$" "^\\*-jabber"))

;; ;; kill everything, clean-buffer-list is very intelligent at not killing
;; ;; unsaved buffer.
;; ;;这里设成匹配任何buffer,任何buffer都在auto kill之列,
;; ;;(setq clean-buffer-list-kill-regexps '("^"))
;; ;; (setq clean-buffer-list-kill-buffer-names
;; ;;       '("*Completions*" "*Apropos*"  "*Customize*"
;; ;;         "*desktop*" "*Async Shell Command"))
;; (setq clean-buffer-list-kill-regexps
;;       (list "^\\*" ;;所有又* 开头的buffer 在clean-buffer-list-delay-special秒后kill
;;             (cons "^ ?[^\\*]" (* 8 clean-buffer-list-delay-special));;所有不又*开头的buffer 在2*clean-buffer-list-delay-special秒后kill
;;             ))
;; ;; run clean-buffer-list every 60s
;; (setq clean-buffer-list-delay-special (* 60  5));;3*60s
;; (run-at-time t  clean-buffer-list-delay-special 'my-clean-buffer-list);;每60秒check一次


;; bury-boring-windows with `C-g'
(defvar boring-window-modes
  '(help-mode compilation-mode log-view-mode log-edit-mode ibuffer-mode)
  )

(defvar boring-window-bof-name-regexp
  (rx (or
       "\*Helm"
       "\*vc-diff\*"
       "*Completions*"
       "\*vc-change-log\*"
       "\*VC-log\*"
       "\*Async Shell Command\*"
       "\*Shell Command Output\*"
       "\*sdcv\*"
       "\*Messages\*"
       "\*joseph_compile_current_el\*"
       "\*Ido Completions\*")))


(defun bury-boring-windows(&optional bury-cur-win-if-boring)
  "close boring *Help* windows with `C-g'"
  (let ((opened-windows (window-list))
        (cur-buf-win (get-buffer-window)))
    (dolist (win opened-windows)
      (with-current-buffer (window-buffer win)
        (when (or (memq  major-mode boring-window-modes)
                  (string-match boring-window-bof-name-regexp (buffer-name)))
          (when (and (>  (length (window-list)) 1)
                     (or bury-cur-win-if-boring
                         (not (equal cur-buf-win win)))
                     (delete-window win))))))))


(defadvice keyboard-quit (before bury-boring-windows activate)
  (when (equal last-command 'keyboard-quit)
    (bury-boring-windows ))
  ;; (when (active-minibuffer-window)
  ;;   (helm-keyboard-quit))
  )
 
;; (defun  bury-boring-buffer()
;;   (let ((cur-buf-name (buffer-name (current-buffer)))
;;         (boring-buffers '("*Completions*" "*SPEEDBAR*" "*Help*" "*vc-log*")))
;;     (mapc #'(lambda(boring-buf)
;;               (unless (equal cur-buf-name boring-buf)
;;                 (when (buffer-live-p (get-buffer boring-buf))
;;                   (bury-buffer boring-buf))))
;;           boring-buffers)))
;; ;;尤其是使用icicle时,经常关闭一个buffer后,默认显示的buffer是*Completions*
;; ;;所以在kill-buffer时,把这些buffer放到最后
;; (add-hook 'kill-buffer-hook 'bury-boring-buffer)


;; ;; (push '(dired-mode :height 50) popwin:special-display-config)

;; ;; (setq-default popwin:popup-window-height 0.5)
;; (require 'popwin)
;; (setq display-buffer-function 'popwin:display-buffer)
;; (setq popwin:special-display-config
;;       '(;; Emacs
;;         help-mode
;;         (completion-list-mode :noselect t)
;;         (compilation-mode :noselect t)
;;         (grep-mode :noselect t)
;;         (occur-mode :noselect t)
;;         "*Shell Command Output*"
;;         "*Async Shell Command*"
;;         ;; VC
;;         ("*vc-diff*" :height 25)
;;         ("*vc-change-log*" :height 25)
;;         ;; ("\\*magit.*" :regexp t :height 30)
;;         ("^\\*helm.*\\*$" :regexp t :height 20)
;;         ;; ("*vc-diff*":position right :width 70 :stick t)
;;         ;; ("*vc-change-log*" :position right :width 70 :stick t)
;;         ("*vc-git.*" :noselect t :regexp t)
;;         ("*sdcv*")
;;         ;; ("*erlang.*" :regexp t :height 20 :stick t)
;;         ("*Messages*" :stick t)
;;         )
;;       )



(provide 'joseph-boring-buffer)
;;; joseph-boring-buffer.el ends here
