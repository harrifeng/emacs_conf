;; ;; 对于c 语言 ，c++语言 要想启用flymake
;; ;; 需要使用Makefile
;; ;; 我已经使用auto-insert 为makefile 创建了一个模版
;; ;; 只需要在src目录下创建一个Makefile就可以flymake c
;; ;;; Code:

;; ;; 如果想不使用makefile 而直接flymake c++
;; (defvar flymake-cc-additional-compilation-flags nil) ;'("-I../" "-std=c++0x")
;; (put 'flymake-cc-additional-compilation-flags 'safe-local-variable 'listp)

;; ;; no need to arrange Makefile
;; (defun flymake-cc-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name)))
;;          (common-args (append (list "-Wall" "-W"  "-fsyntax-only" local-file)
;;                               flymake-cc-additional-compilation-flags)))
;;     (if (eq major-mode 'c++-mode)
;;         (list "g++" common-args)
;;       (list "gcc" common-args))))

;; (dolist (ext '("\\.c$" "\\.h$" "\\.C$" "\\.cc$" "\\.cpp$" "\\.hh$" "\\.H$"))
;;   (push `(,ext flymake-cc-init) flymake-allowed-file-name-masks))

;; (add-hook 'view-mode-hook 'flymake-mode-off)

;; (setq flymake-gui-warnings-enabled nil)
;; ;; kill 一个buffer 时，如果与此buffer 关联的进程是flymake ,则不必问，直接干掉
;; (defadvice flymake-start-syntax-check-process (after
;;                                                cheeso-advice-flymake-start-syntax-check-1
;;                                                (cmd args dir)
;;                                                activate compile)
;;   ;; set flag to allow exit without query on any
;;   ;;active flymake processes
;;   (set-process-query-on-exit-flag ad-return-value nil))



;; 光标移动到错误行， 1s后， 显error
;; (require 'flymake-cursor) autoloaded , need req
(provide 'joseph-flymake)
;;; joseph-flymake.el ends here
