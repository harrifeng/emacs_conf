;; (autoload 'actionscript-mode "actionscript-mode"  "Major mode for editing Actionscript files." t)
;; Automatically use hideshow with actionscript files.
;; (add-hook 'actionscript-mode-hook 'hs-minor-mode)

(add-hook 'find-file-not-found-hooks 'insert-flash-boilerplate)
;; Keybindings
(define-key-lazy actionscript-mode-map "\C-c\C-f" 'as-print-func-info)
(define-key-lazy actionscript-mode-map "\C-c\C-t" 'as-insert-trace)

(provide 'joseph-as)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-as.el ends here
