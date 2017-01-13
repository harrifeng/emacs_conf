;;; joseph-vc-git-mergetool.el --- Description

;; Description: Description
;; Created: 2012-12-02 16:35
;; Last Updated: 纪秀峰 2012-12-02 16:51:08 星期日
;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords:
;; URL: http://www.emacswiki.org/emacs/download/joseph-vc-git-mergetool.el

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

;;; Code:

;;;; git mergetool 使用ediff ,前提可以正常使用emacsclient ,并且Emacs已经启动。
;; ~/.gitconfig
;; [mergetool "ediff"]
;; cmd = emacsclient --eval \"(git-mergetool-emacsclient-ediff \\\"$LOCAL\\\" \\\"$REMOTE\\\" \\\"$BASE\\\" \\\"$MERGED\\\")\"
;; trustExitCode = false
;; [mergetool]
;; prompt = false
;; [merge]
;; tool = ediff
;;
;; Setup for ediff.
;;
(require 'ediff)
;; ediff-prepare-buffer-hook
(defvar ediff-after-quit-hooks nil
  "* Hooks to run after ediff or emerge is quit.")

(defadvice ediff-quit (after edit-after-quit-hooks activate compile)
  (run-hooks 'ediff-after-quit-hooks))

(defvar git-mergetool-emacsclient-ediff-active nil)
(defvar local-ediff-saved-frame-configuration nil)
(defvar local-ediff-saved-window-configuration nil)


;; (defun local-ediff-frame-maximize ()
;;   (when (boundp 'display-usable-bounds)
;;     (let* ((bounds (display-usable-bounds))
;;            (x (nth 0 bounds))
;;            (y (nth 1 bounds))
;;            (width (/ (nth 2 bounds) (frame-char-width)))
;;            (height (/ (nth 3 bounds) (frame-char-height))))
;;       (set-frame-width (selected-frame) width)
;;       (set-frame-height (selected-frame) height)
;;       (set-frame-position (selected-frame) x y))  )
;;   )
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

(defun local-ediff-before-setup-hook ()
  (setq local-ediff-saved-frame-configuration (current-frame-configuration))
  (setq local-ediff-saved-window-configuration (current-window-configuration))
  ;; (local-ediff-frame-maximize)
  (if git-mergetool-emacsclient-ediff-active
      (raise-frame)))

(defun local-ediff-quit-hook ()
  (set-frame-configuration local-ediff-saved-frame-configuration)
  (set-window-configuration local-ediff-saved-window-configuration))

(defun local-ediff-suspend-hook ()
  (set-frame-configuration local-ediff-saved-frame-configuration)
  (set-window-configuration local-ediff-saved-window-configuration))

(add-hook 'ediff-before-setup-hook 'local-ediff-before-setup-hook)
(add-hook 'ediff-quit-hook 'local-ediff-quit-hook 'append)
(add-hook 'ediff-suspend-hook 'local-ediff-suspend-hook 'append)

;; Useful for ediff merge from emacsclient.
;;;###autoload
(defun git-mergetool-emacsclient-ediff (local remote base merged)
  (setq git-mergetool-emacsclient-ediff-active t)
  (if (file-readable-p base)
      (ediff-merge-files-with-ancestor local remote base nil merged)
    (ediff-merge-files local remote nil merged))
  (recursive-edit))

(defun git-mergetool-emacsclient-ediff-after-quit-hook ()
  (exit-recursive-edit))

(add-hook 'ediff-after-quit-hooks 'git-mergetool-emacsclient-ediff-after-quit-hook 'append)

(provide 'joseph-vc-git-mergetool)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-vc-git-mergetool.el ends here
