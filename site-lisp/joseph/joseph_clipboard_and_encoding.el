;;; -*- coding:utf-8 -*-
;;{{{ 关于utf-8编码 ,字符集的选用
  ;; For my language code setting (UTF-8)设置编码
  ;;(set-clipboard-coding-system 'chinese-iso-8bit) ;; 如果不设，在emacs 剪切的中文没法在其他程序中粘贴
(setq current-language-environment "UTF-8")
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(setq-default pathname-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


;;}}}
(provide 'joseph_clipboard_and_encoding)
