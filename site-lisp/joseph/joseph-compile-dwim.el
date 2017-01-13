(setq compilation-read-command nil)
(setq compilation-always-kill t)

(defun root-of-makefile ()
  "Look for Makefile file to find project root of erlang application.
if found return the directory or nil
"
  (let ((root (locate-dominating-file default-directory "Makefile")))
    (if root
        (expand-file-name root)
      (setq root (locate-dominating-file default-directory "makefile"))
      (if root
          (expand-file-name root)
        nil
        ))))
(defun make-at-root-dir()
  (let ((project-root (root-of-makefile))
        (compile-command compile-command))
    (when project-root
      (setq compile-command (concat "make --directory=" project-root)))
    (call-interactively 'compile)))

(setq-default compile-dwim-alist
      `((mxml (or (name . "\\.mxml$"))
                      ;; "mxmlc %f"
              (make-at-root-dir)
                      "firefox %n.swf")
        (objc (mode . objc-mode)
                      xcode:build
                      xcode:build-and-run
                      )
        (lua (or (name . "\\.lua$")
                          (mode . lua-mode))
                      "lua %n.lua"
                      ;; "mxmlc %f"
                      "lua %n.lua")
        (go (name . "_test\\.go$")
                      "go test"
                      "go test -test.run")

        (go (or (name . "\\.go$")
                          (mode . go-mode))
                      (make-at-root-dir)
                      "go run %n.go")

        (as (or (name . "\\.as$")
                          (mode . actionscript-mode))
                      (make-at-root-dir)
                      "firefox %n.swf")
        (visual-basic (or (name . "\\.\\(frm\\|bas\\|cls\\|vba\\)$")
                          (mode . visual-basic-mode))
                      (run-vb) (run-vb))
        (asm (or (name . "\\.s$")
                  (mode . asm-mode))
                "as -o %n.o %f;ld -o %n %n.o " "./%n")
        (erlang (or (name . "\\.erl$")
                  (mode . erlang-mode))
                (erlang-dired-emake) "erl  \"%f\"")
        (perl (or (name . "\\.pl$")
                  (mode . cperl-mode))
              "%i -wc \"%f\"" "%i \"%f\"")
        (csharp    (or (name . "\\.cs$")
                       (mode . csharp-mode))
                   "csc %f"
                   "%n")
        (c    (or (name . "\\.c$")
                  (mode . c-mode))
              "gcc -o %n %f"
              ,(if (equal system-type 'windows-nt) "%n" "./%n"))
        ;; (c    (or (name . "\\.c$")
        ;;           (mode . c-mode))
        ;;       ("gcc -o %n %f" "gcc -g -o %n %f") ("./%n" "cint %f") "%n")
        (c++  (or (name . "\\.cpp$")
                  (mode . c++-mode))
              ("g++ -o %n %f" "g++ -g -o %n %f")
              ,(if (equal system-type 'windows-nt) "%n" "./%n") "%n")
        (java (or (name . "\\.java$")
                  (mode . java-mode))
              "javac %f" "java %n" "%n.class")
        (python (or (name . "\\.py$")
                    (mode . python-mode))
                "python %f" "python %f")
        (javascript (or (name . "\\.js$")
                        (mode . javascript-mode))
                    "smjs -f %f" "smjs -f %f")
        (tex   (or (name . "\\.tex$")
                   (name . "\\.ltx$")
                   (mode . tex-mode)
                   (mode . latex-mode))
               "latex %f" "latex %f" "%n.dvi")
        (texinfo (name . "\\.texi$")
                 (makeinfo-buffer) (makeinfo-buffer) "%.info")
        (sh    (or (name . "\\.sh$")
                   (mode . sh-mode))
               "%i ./%f" "%i ./%f")
        (f99   (name . "\\.f90$")
               "f90 %f -o %n" "./%n" "%n")
        (f77   (name . "\\.[Ff]$")
               "f77 %f -o %n" "./%n" "%n")
        (php   (or (name . "\\.php$")
                   (mode . php-mode))
               "php %f" "php %f")
        (elisp (or (name . "\\.el$")
                   (mode . emacs-lisp-mode)
                   (mode . lisp-interaction-mode))
               (joseph_compile_current_el_outside)
               (emacs-lisp-byte-compile) "%fc"))
      );;;; eval-after-load compile-dwim


(provide 'joseph-compile-dwim)
;;; joseph-compile-dwim.el ends here
