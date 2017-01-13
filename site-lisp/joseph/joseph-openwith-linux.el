;;; -*- coding:utf-8 -*-
;;{{{  openwith ,外部程序

;;直接用正常的方式打开相应的文件,openwith会自动做处理
(eval-when-compile
    (require 'joseph-util)
    (require 'dired))

(require 'openwith)
(openwith-mode t)
(when (eq system-type 'gnu/linux)
  (setq openwith-associations
        '(("\\.pdf$" "acroread" (file)) ("\\.mp3$" "mpg123" (file) )
          ("\\.vob\\|\\.VOB\\|\\.wmv\\|\\.mov\\|\\.RM$\\|\\.RMVB$\\|\\.avi$\\|\\.AVI$\\|\\.flv$\\|\\.mp4\\|\\.mkv$\\|\\.rmvb$" "mplayer" (file) )
          ("\\.wav" "aplay" (file) )
          ;;          ("\\.jpe?g$\\|\\.png$\\|\\.bmp\\|\\.gif$" "gpicview" (file))
          ("\\.CHM$\\|\\.chm$" "chmsee"  (file) )
          )))
;; 第二种打开方式
(define-key-lazy  global-map "\C-\M-j" 'open-with-2-on-linux)
(define-key-lazy  dired-mode-map "\C-\M-j" 'open-with-2-on-linux)

;;; linux `C-M-RET' 用pcmanfm文件管理器打开当前目录
(define-key-lazy dired-mode-map (quote [C-M-return]) 'open-directory-with-pcmanfm)
(global-set-key (quote [C-M-return]) (quote open-directory-with-pcmanfm))

(provide 'joseph-openwith-linux)
