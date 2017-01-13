;;; -*- coding:utf-8 -*-
;;; openwith ,外部程序

;;直接用正常的方式打开相应的文件,openwith会自动做处理
;;`C-xC-f'即可
(eval-when-compile
    (require 'joseph-util)
    (require 'dired))

(require 'openwith)
(openwith-mode t)

;;windows 上使用w32-shell-execute 调用系统的相应程序打开
(setq openwith-associations
      '(("\\.pdf$" "open" (file))
        ("\\.mov\\|\\.RM$\\|\\.RMVB$\\|\\.avi$\\|\\.AVI$\\|\\.flv$\\|\\.mp4\\|\\.mkv$\\|\\.rmvb$" "open" (file) )
        ;;       ("\\.jpe?g$\\|\\.png$\\|\\.bmp\\|\\.gif$" "open" (file))
        ("\\.bmp$" "open" (file))
        ("\\.mp3$" "mpg123" (file))
        ("\\.wav" "open" (file))
        ("\\.CHM$\\|\\.chm$" "open"  (file) )
        )
      )

(define-key  global-map "\C-\M-j" 'open-with-C-RET-on-w32)

;;C-M-<RET> 用资源管理器打开当前文件所处目录
(define-key-lazy dired-mode-map (quote [C-M-return]) 'explorer-open)
(global-set-key (quote [C-M-return]) 'explorer-open)

(provide 'joseph-openwith-w32)
;;; joseph-open-w32.el ends here
