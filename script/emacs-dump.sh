#!/bin/bash
#运行这个文件会在/tmp下生成一个
#emacs-dump的可执行文件，它是将某一状态的emacs 保存
#以后直接运行这个可执行文件，启动速度会快许多
MYEMACS=/tmp/emacs-dump
EMACS=/usr/bin/emacs
cat > /tmp/dump-emacs.el <<EOF
(load "/home/jixiuf/.emacs.d/init.el")
(require 'dired)
(icy-mode)
(load "~/.emacs.d/site-lisp/dired-filetype-face/dired-filetype-face.el")
(global-font-lock-mode 1)
(dump-emacs "$MYEMACS" "$EMACS")
EOF

OLD_VASPACE=`sudo sysctl kernel.randomize_va_space|tr -d " "`
sudo sysctl -w kernel.randomize_va_space=0
$EMACS --batch --load /tmp/dump-emacs.el
sudo sysctl -w "$OLD_VASPACE"
