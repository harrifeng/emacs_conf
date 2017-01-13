;;; joseph-erc.el --- erc   -*- coding:utf-8 -*-

;; Description: erc
;; Time-stamp: <Joseph 2011-09-24 12:39:07 星期六>
;; Created: 2011-09-21 23:38
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords: erc irc
;; URL: http://www.emacswiki.org/emacs/joseph-erc.el

;; Copyright (C) 2011, 纪秀峰, all rights reserved.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 参考了emacs中文网上的配置：http://emacser.com/erc.htm
;;  基本命令
;; /list 列出所有聊天室
;; /join #room
;; /part 离开聊天室
;; /quit 退出
;;; Commands:
;;
;; Below are complete command list:
;;
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:
(eval-when-compile
    (require   'joseph_byte_compile_include)
    (require 'erc)
    (require 'erc-join)
    (require 'erc-match)
    )


(setq erc-nick "jixiuf"
      erc-user-full-name "纪秀峰")

(setq erc-echo-notices-in-minibuffer-flag t
      erc-server-coding-system '(utf-8 . utf-8)
      erc-encoding-coding-alist '(("#linuxfire" . chinese-iso-8bit))
      erc-kill-buffer-on-part t
      erc-auto-query t)
;; 连接erc 后，自动打开某些channel
(setq erc-autojoin-channels-alist
      '(("freenode.net"
         "#emacs"
         "#vim"
         "#linux-cn"
         "#guile"
         "#python"
         )))
(erc-autojoin-mode 1)


;; 4. 过滤信息
;; 如果你对某些消息或者某个人说的话特别感兴趣，我们可以通过关键字匹配对相关信息进行高亮。例如：
(erc-match-mode 1)
(setq erc-keywords '("emacs" "perl" "java" "csharp" "erlang" "memcached"))
;; (setq erc-pals '("rms")) ;这个不懂，comment 之


;; 相反地，如果你对某些消息不感兴趣，比如有人进来啦，有人出去啦，如此这般一下就不会看到了：
(setq erc-ignore-list nil)
(setq erc-hide-list
      '("JOIN" "PART" "QUIT" "MODE"))


;; 5. 新信息提醒
;; 信息一般可分为三种：
;; 1) 某人悄悄跟你说话(即所谓的 private message)，这会打开一个新小窗，即 buffer.
;; ERC>/msg NICK how are you doing
;; 2) 某人公开地跟你说话，即别的在 channel 里的人也能看到。一般来说，习惯用 nick加 `:’ 表示。
;; (要输入某人 nick 的时候，首字母加 TAB 就能帮你补全，一次不行，多 TAB 几次可以选择)
;; <xwl> ahei: 你可以 match regexp,
;; 3) 别的情形。
;; ERC 会通过 erc-modified-channels-object 来设置 mode line，提示有新消息，类似：
;; [#o: 38, #emacs-cn: 5]
;; 为什么要区分以上三种情形呢? 因为我们可以对不同信息，
;; 用不同的颜色在mode line 来提示，这样方便你决定是不是要及时地去查阅这条消息。




(provide 'joseph-erc)
;;; joseph-erc.el ends here
