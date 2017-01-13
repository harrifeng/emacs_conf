(require 'undo-tree)
(global-undo-tree-mode)
(defadvice undo-tree-visualizer-mode (after undo-tree-face activate)
  (buffer-face-mode))
(define-key undo-tree-map (kbd "C-?") nil)
(define-key undo-tree-map (kbd "C-x /") 'undo-tree-redo)
(provide 'joseph-undo)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-undo.el ends here
