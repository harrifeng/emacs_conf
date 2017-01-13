;;; Code:
(setenv "PATH" (concat "/usr/texbin:/usr/local/bin:" (getenv "PATH")))
(setq exec-path (append '("/usr/texbin" ) exec-path))


(setq-default TeX-PDF-mode t)
;; (setq-default TeX-master t)    ;t means this file as master
(setq-default TeX-auto-save t)
(setq-default TeX-save-query nil)
(setq-default TeX-parse-self t)
(setq-default reftex-plug-into-AUCTeX t)
(setq-default TeX-auto-untabify t     ; remove all tabs before saving
                      ;; 现在 TeX 对于中文的处理基本有两种方案，CJK 宏包和 xetex
                      ;; 本文也建议你设置 'TeX-engine' 变量为 xetex 替代 latex作为 tex 文件的默认排版引擎。
                      TeX-engine 'xetex       ; use xelatex default
                      TeX-show-compilation t)

(setq-default TeX-view-program-list
              '(("Open" "open %o")
                ("Firefox" "firefox %o")))
(setq-default TeX-view-program-selection
              '((output-pdf "Open")
                (output-dvi "Open")))


(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)


;; (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;   (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

 (add-hook 'LaTeX-mode-hook
              (lambda ()
                (turn-on-reftex)
                (imenu-add-menubar-index)
                ;; (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)
                ))
(provide 'joseph-auctex)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-auctex.el ends here
