将blancosqlformat*.jar 加入到classpath 中
echo "select * from dual" | java SqlBeautify

(defun sql-beautify-region (beg end)
  "Beautify SQL in region between beg and END."
  ;;  (interactive "r")
  (if (equal system-type 'windows-nt)
      (setenv "CLASSPATH" (concat (getenv "CLASSPATH") ";" "d:\\.emacs.d\\script\\sqlbeautify\\blancosqlformatter-0.1.1.jar"))
    (setenv "CLASSPATH" (concat (getenv "CLASSPATH") ":" (getenv "HOME") "/.emacs.d/script/sqlbeautify/blancosqlformatter-0.1.1.jar")))
  (cd "~/.emacs.d/script/sqlbeautify/")
  (let ((beautified-sql))
    (shell-command-on-region beg end "java SqlBeautify" "*sqlbeautify*" nil)
    (with-current-buffer  "*sqlbeautify*"
      (goto-char (point-min))
      (while (search-forward "\^M" nil t) ;;delete ^m
        (replace-match "" nil nil))
      (setq beautified-sql (buffer-string)))
    (goto-char beg)
    (kill-region beg end)
    (insert beautified-sql)
    (kill-buffer"*sqlbeautify*")
    ))
