;; ;; -*- coding:utf-8 -*-
;; (eval-when-compile
;;   (require 'shell)
;;   (require 'pcomplete)
;;   )
;; ;; 当初选择shell而非eshell是因， 可以用zsh bash 里的alias,否则 ，需要为zsh  eshell配两次
;; ;; 现在看来 ，好像没那么重要
;; (eval-after-load 'comint '(progn
;;                             (setq comint-input-sender 'n-shell-simple-send)
;;                             (setenv "EMACS" "emacs") ;comint.el里将setenv EMACS=t, 但是一些makefile里 使用到EMACS变量
;;                             ))

;; ;;当退出时自动关闭当前buffer及窗口
;; (add-hook 'shell-mode-hook 'shell-kill-buffer-when-exit-func)
;;  ;; (setq process-coding-system-alist (cons '("bash" . undecided-unix) process-coding-system-alist))


;; ;;有一些回显程序如echo.exe 默认情况下也会显示你执行的命令,这个hook
;; ;;可以使它仅显示它应该显示的部分
;; ;;如 $echo a
;; ;;默认会显示为
;; ;;echo a
;; ;;a
;; ;;有此后只显示a
;; ;; (defun joseph-comint-init () (setq comint-process-echoes t))
;; ;; (add-hook 'comint-mode-hook 'joseph-comint-init)
;; ;;如果还不能关闭回显,可以用这个方法
;; ;;(setq explicit-cmd.exe-args '("/q"));;在使用cmd 时,使用/q 参数, 注意变量名里的cmd.exe ,
;; ;;;;如果$SHELL =bash ,相应 的变量名是explicit-bash-args ,

;; (when (equal system-type 'windows-nt)
;;   (eval-after-load 'shell
;;     '(add-to-list 'shell-dynamic-complete-functions 'shell-msys-path-complete-as-command)))




;; ;;shell mode  binding
;; ;; emacs24.1之后，shell mode 也使用pcompletion
;; ;; http://www.masteringemacs.org/articles/2012/01/16/pcomplete-context-sensitive-completion-emacs/
;; ;; 故，这样绑定应该无问题
;; (eval-after-load 'shell
;;   '(progn
;;      (add-hook 'shell-mode-hook 'pcomplete-shell-setup)
;;      (define-key shell-mode-map (kbd "TAB") 'helm-shell-pcomplete )))


(provide 'joseph-shell)
