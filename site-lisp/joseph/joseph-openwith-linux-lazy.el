;;默认情况下，return 即可以用`open-with'对特定后缀的文件使用相应的程序或
;;emacs mode打开，但有时候想提供第二种打开的方式 。比如默认对于html文件，我
;;会用emacs中的nxml-mode打开，但有时也想在firefox中浏览它，于是return 使用
;;nxml-mode，而C-RET则使用firefox进行打开
;;注意，我这里对html做了特殊处理，当打开html时，焦点自动切换到firefox上。使用了
;; Awesome 窗口管理器的特性。所以未必适合你，仅做参考。
;;;###autoload
(defun open-with-2-on-linux()
  "in dired mode ,`C-RET' open file with ..."
  (interactive)
  (let ((file-name (if (equal major-mode 'dired-mode )  (dired-get-filename) (buffer-file-name)))
        (openwith-associations
         '(("\\.pdf$" "acroread" (file)) ("\\.mp3$" "mpg123" (file) )
           ("\\.vob\\|\\.VOB\\|\\.wmv\\|\\.RM$\\|\\.RMVB$\\|\\.avi$\\|\\.AVI$\\|\\.flv$\\|\\.mp4\\|\\.mkv$\\|\\.rmvb$" "mplayer" (file) )
           ("\\.jpe?g$\\|\\.png$\\|\\.bmp\\|\\.gif$" "gpicview" (file))
           ("\\.wav" "aplay" (file))
           ("\\.CHM$\\|\\.chm$" "chmsee"  (file) ))))
    (if (string-match "\\.html?$" file-name)
        (if (> (string-to-number (shell-command-to-string "pgrep firefox | wc -l")) 0)
            (progn
              (start-process-shell-command "firefox" nil (format "echo ' show_matched_client({class=\"Firefox\" ,instance=\"Navigator\"},\"www\",\"/usr/bin/firefox %s  \" ,nil)' |awesome-client " file-name))
              (start-process "firefox-file" nil "firefox" file-name))
          (start-process-shell-command "firefox" nil (format "echo ' show_matched_client({class=\"Firefox\" ,instance=\"Navigator\"},\"www\",\"/usr/bin/firefox %s  \" ,nil)' |awesome-client " file-name)))
      (if (equal major-mode 'dired-mode)
          (dired-find-file)
        (find-file file-name)))))

;;; linux `C-M-RET' 用pcmanfm文件管理器打开当前目录
;;;###autoload
(defun open-directory-with-pcmanfm()
  (interactive)
  (start-process "pcmanfm"  nil "pcmanfm" (expand-file-name  default-directory)))


(provide 'joseph-openwith-linux-lazy)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-openwith-linux-lazy.el ends here
