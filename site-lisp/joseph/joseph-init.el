;; -*- Coding:utf-8;no-byte-compile: t; -*-
 ;; 一些与键绑定相关的配置
(require 'joseph-util)
(load "../lisp/joseph-loaddefs" )

;;(require 'joseph-command) ; autoload command
(require 'joseph-keybinding);
(require 'joseph-quick-jump);
(require 'joseph-common)
(require 'joseph-evil)
(eval-after-load 'dired '(require 'joseph-dired))

(when (equal system-type 'windows-nt)
  (require 'joseph-w32)
  (require 'joseph-openwith-w32))

(require 'joseph-kill-emacs)
(when (equal system-type 'gnu/linux)
    (require 'joseph_clipboard_and_encoding)
    (require 'joseph-openwith-linux)
    (require 'joseph-linux)
    )

(when (equal system-type 'darwin)
    (require 'joseph_clipboard_and_encoding)
    (require 'joseph-openwith-mac)
    (require 'joseph-mac)
    )
;; do not need this after require evil-mode
;; (require 'joseph_rect_angle); 所有关于矩形操作的配置都在joseph_rect_angle.el文件中
(require 'joseph-yasnippet-config)
(require 'joseph-auto-complete)
(require 'joseph-company)

(eval-after-load 'ibuffer '(require 'joseph-ibuffer))
;; (require 'joseph-nxhtml)
(eval-after-load 'nxml-mode '(require 'joseph-nxml))
(require 'joseph-tags);;需要在helm load之后 .tags
(require 'joseph-vc);;; VC
;; (require 'joseph-auto-document)
(require 'joseph-boring-buffer)
;; (require 'joseph-autopair-config)
;;粘贴时，对于粘贴进来的内容进行高亮显示,仅仅是高亮显示overlay ，并未选中
;; (require 'volatile-highlights)
;; 对于helm-show-kill-ring命令也支持高亮显示
;; (vhl/define-extension 'helm-yank 'helm-show-kill-ring)
;; (vhl/install-extension 'helm-yank)
;; (volatile-highlights-mode t)

(require 'joseph-helm);helm
(with-eval-after-load 'ido (require 'joseph-ido));ido
(require 'joseph-windows)
(require 'joseph-yasnippet-auto-insert)
;; (eval-after-load 'flymake '(require 'joseph-flymake));;;
(require 'joseph-program)
;; (run-with-idle-timer 10 nil '(lambda () (require 'joseph-cedet) (message "cedet is loaded")));;;  cedet
;; (eval-after-load 'shell '(require 'joseph-shell));;; shell
(eval-after-load 'eshell '(require 'joseph-pcomplete));;; pcomplete
(eval-after-load 'sql '(require 'joseph-sql));;; Sql
(eval-after-load 'cperl-mode '(require 'joseph-perl));;; perl
(eval-after-load 'erc '(require 'joseph-erc));;; erc ,irc
(eval-after-load 'css-mode '(require 'joseph-css));;;
(eval-after-load 'csharp-mode '(require 'joseph-csharp));;;
(eval-after-load 'python '(require 'joseph-python));;;
(eval-after-load 'js3-mode'(require 'joseph-js));;;
;; (require 'joseph-outline)  ;暂时不用outline
;; (require 'joseph-fast-nvg)
;; (require 'joseph-org-config)
;; (require 'joseph-vb)
;; (require 'joseph-android)
;; (require 'joseph-thing) autoload
;; (eval-after-load 'erlang '(require 'joseph-erlang))
;; (require 'joseph-gtalk)
;; (require 'joseph-mew)
(with-eval-after-load 'actionscript-mode (require 'joseph-as))

;; (eval-after-load 'undo-tree '(require 'joseph-undo))
;; (require 'joseph-linenum-config)

;; (require 'joseph-keep-buffer)
;; (require 'joseph-eim)



(provide 'joseph-init)
;;C-c return r ;重新加载当前文件
;;emacs -batch -f batch-byte-compile  filename
;; emacs  -batch    -l /home/jixiuf/emacsd/site-lisp/joseph/joseph_byte_compile_include.el  -f batch-byte-compile *.el

;;C-x C-e run current lisp
; ;; -*-no-byte-compile: t; -*-
;;
;;首先~/.emacs.d/site-lisp/lisp/josehp-loaddefs.el文件是
;;(joseph-update-directory-autoloads-recursively)函数自动生成的
;;这个文件中所有语句都是通过扫描~/.emacs.d/所有子目录下的el文件生成的autoload语句.
;;(joseph-update-directory-autoloads-recursively)
;;函数在joseph-autoload.el文件中定义，
;;而它也会被扫描进joseph-loaddefs.el,
