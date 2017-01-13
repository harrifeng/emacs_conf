;;; -*- coding:utf-8 -*-
;;{{{  openwith ,外部程序

;;直接用正常的方式打开相应的文件,openwith会自动做处理
(require 'openwith)
(openwith-mode t)
(setq openwith-associations
        '(("\\.pdf$" "open" (file))
          ("\\.mp3$" "open" (file) )
          ("\\.vob\\|\\.VOB\\|\\.wmv\\|\\.mov$\\|\\.RM$\\|\\.RMVB$\\|\\.avi$\\|\\.AVI$\\|\\.flv$\\|\\.mp4\\|\\.mkv$\\|\\.rmvb$" "open" (file) )
          ("\\.wav" "open" (file) )
          ;;          ("\\.jpe?g$\\|\\.png$\\|\\.bmp\\|\\.gif$" "gpicview" (file))
          ("\\.CHM$\\|\\.chm$" "open"  (file) )
          ("\\.docx?$" "open" ( "-a" "Pages" file))
          ("\\.xlsx$" "open"  (file) )
          ))


(defun open-with-2-on-mac()
  "in dired mode ,`C-RET' open file with ..."
  (interactive)
  (let ((file-name (if (equal major-mode 'dired-mode )  (dired-get-filename) (buffer-file-name)))
        (openwith-associations
         '(("\\.pdf$" "open" (file))
           ("\\.mp3$" "open" (file) )
           ("\\.vob\\|\\.VOB\\|\\.wmv\\|\\.RM$\\|\\.RMVB$\\|\\.avi$\\|\\.AVI$\\|\\.flv$\\|\\.mp4\\|\\.mkv$\\|\\.rmvb$" "open" (file) )
           ("\\.jpe?g$\\|\\.png$\\|\\.bmp\\|\\.gif$" "open" (file))
           ("\\.wav" "open" (file))
           ("\\.html?$" "open" (file))
           ("\\.xlsx?$" "open" ( "-a" "Microsoft Excel.app" file))
           ("\\.docx?$" "open" ( "-a" "Microsoft Word.app" file))
           )))
    (if (equal major-mode 'dired-mode)
        (dired-find-file)
      (find-file file-name))
    )
  )

;; 第二种打开方式
(define-key-lazy  global-map "\C-\M-j" 'open-with-2-on-mac)
(define-key-lazy  dired-mode-map "\C-\M-j" 'open-with-2-on-mac)


;;;###autoload
(defun reveal-in-osx-finder ()
  "Reveal the file associated with the current buffer in the OS X Finder.
In a dired buffer, it will open the current directory."
  (interactive)
  (let* ((path (buffer-file-name)) ; The full file path associated with the buffer.
	 (filename-at-point (dired-file-name-at-point)) ; effective in dired only
	 ;; Create a full path if filename-at-point is non-nil
	 (filename-at-point (if filename-at-point
				(expand-file-name filename-at-point) ; full path
			      nil)) ; if nil, return nil
	 dir file)		   ; let* definition part ends here.

    ;; Conditionals: The first one that is non-nil is executed.
    (cond (path
	   ;; If path is non-nil,
	   (setq dir  (file-name-directory    path))
	   (setq file (file-name-nondirectory path)))

	  (filename-at-point
	   ;; If filename-at-point is available from dired,
	   (setq dir  (file-name-directory    filename-at-point))
	   (setq file (file-name-nondirectory filename-at-point)))

	  (t
	   ;; Otherwise,
	   (setq dir  (expand-file-name default-directory))))

    ;; Pass dir and file to the helper function.
    ;; (message (concat "dir:" dir " ; file:" file " ; path:" path " ; fap:" filename-at-point)) ; for debugging
    (reveal-in-osx-finder-as dir file) ; These variables are  passed to the helper function.
    ))


;; AppleScript helper function. Thanks milkeypostman for suggestions.
;; Use let* to reuse revealpath in defining script.
(defun reveal-in-osx-finder-as (dir file)
  "A helper function for reveal-in-osx-finder.
This function runs the actual AppleScript."
  (let* ((revealpath (if file		   ; Define revealpath local variable.
			 (concat dir file) ; dir/file if file name available.
		       dir))		   ; dir only if not.
	 (script			   ; Define script variable using revealpath and text.
	  (concat
	   "set thePath to POSIX file \"" revealpath "\"\n"
	   "tell application \"Finder\"\n"
	   " set frontmost to true\n"
	   " reveal thePath \n"
	   "end tell\n")))		   ; let* definition part ends here.
    ;; (message script)			   ; Check the text output.
    (start-process "osascript-getinfo" nil "osascript" "-e" script) ; Run AppleScript.
    ))


;; (defun open-directory-mac-finder()
;;   (interactive)
;;   (start-process "finder"  nil "open" (expand-file-name  default-directory)))
;;; linux `C-M-RET' 用pcmanfm文件管理器打开当前目录
(define-key-lazy dired-mode-map (quote [C-M-return]) 'reveal-in-osx-finder)
(global-set-key (quote [C-M-return]) (quote reveal-in-osx-finder))

(evil-leader/set-key "<RET><RET>" 'reveal-in-osx-finder) ;
(provide 'joseph-openwith-mac)
