;;
(autoload 'er/expand-region  "expand-region-core" "" t nil)

;; (autoload 'er/contract-region "expand-region-core" "" t nil)
;; (define-key global-map (kbd "M-o") 'er/contract-region)
(setq er/try-expand-list (append
                          er/try-expand-list
                          '(mark-email mark-filename mark-url)))



;; (eval-after-load "clojure-mode" '(require 'clojure-mode-expansions))
(eval-after-load "css-mode"     '(require 'css-mode-expansions))
(eval-after-load "erlang-mode"  '(require 'erlang-mode-expansions))
;; (eval-after-load "feature-mode" '(require 'feature-mode-expansions))
;; (eval-after-load "sgml-mode"    '(require 'html-mode-expansions)) ;; html-mode is defined in sgml-mode.el
;; (eval-after-load "rhtml-mode"   '(require 'html-mode-expansions))
(eval-after-load "nxhtml-mode"  '(require 'html-mode-expansions))
(eval-after-load "js2-mode"     '(require 'js-mode-expansions))
(eval-after-load "js2-mode"     '(require 'js2-mode-expansions))
;; (eval-after-load "js3-mode"     '(require 'js-mode-expansions))
;; (eval-after-load "LaTeX-mode"   '(require 'latex-mode-expansions))
(eval-after-load "nxml-mode"    '(require 'nxml-mode-expansions))
;; (eval-after-load "python"       '(require 'python-mode-expansions))
;; (eval-after-load "python-mode"  '(require 'python-mode-expansions))
;; (eval-after-load "ruby-mode"    '(require 'ruby-mode-expansions))
(eval-after-load "org-mode"     '(require 'org-mode-expansions))


(provide 'joseph-thing)
;;; joseph-thing.el ends here
