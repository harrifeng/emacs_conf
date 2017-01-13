 ;; -*-no-byte-compile: t; coding:utf-8  -*-
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/submodules/joseph-file-util/"))
(require 'joseph-file-util)
(defvar user-load-path (all-subdir-under-dir-recursively
                        (expand-file-name "~/.emacs.d/site-lisp/") nil nil
                        "\\.git\\|\\.svn\\|RCS\\|rcs\\|CVS\\|cvs\\|doc\\|syntax\\|templates\\|tests\\|icons\\|testing\\|etc\\|script$\\|snippets\\|yasnippet/extras\\|/test/\\|org-mode-git/contrib/scripts\\|/doc/\\|/docs/\\|nxhtml/html-chklnk/PerlLib" t))
(dolist (path user-load-path) (add-to-list 'load-path path))
(defvar user-load-path2 (all-subdir-under-dir-recursively
                        (expand-file-name "~/.emacs.d/elpa/") nil nil
                        "\\.git\\|\\.svn\\|RCS\\|rcs\\|CVS\\|cvs\\|doc\\|syntax\\|templates\\|tests\\|icons\\|testing\\|etc\\|script$\\|snippets\\|yasnippet/extras\\|/test/\\|org-mode-git/contrib/scripts\\|/doc/\\|/docs/\\|nxhtml/html-chklnk/PerlLib" t))
(dolist (path user-load-path2) (add-to-list 'load-path path))

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/"))

(provide 'joseph_byte_compile_include)
