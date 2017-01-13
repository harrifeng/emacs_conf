;;; joseph-android.el --- android mode   -*- coding:utf-8 -*-

;; Description: android mode
;; Created: 2011-10-14 21:26
;; Last Updated: 纪秀峰 2014-05-28 17:35:44
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords: android
;; URL: http://www.emacswiki.org/emacs/joseph-android.el

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

;;

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

;; android mode gn dired 进行了整合,当进行dired 时,如果发现目录下有AndroidManifest.xml
;; 则启用android mode
;;另外android 命令可以帮助创建一个简单的工程
;; /java/java/android-sdk-linux_86/tools/android create project -n helloworld -t 7 -p ./ -k org.example.helloworld -a helloworld
;; 注：-t后面跟什么id与安装的platform有关，可用命令android list targets查看
;; 比如我的 -t 7 为创建android-8 平台的程序
;;参考 http://hi.baidu.com/jiyeqian/blog/item/1d6f3fea003527ddd439c980.html
;; 不需要自已写build.xml
;; 用
;; /java/java/android-sdk-linux_86/tools/android create project -n helloworld -t 7 -p ./ -k org.example.helloworld -a helloworld
;; 创建完工程后,
;;运行`C-wae'  运行 android-start-emulator启动模拟器(这个过程很慢,可能导致ant install失败,需耐心)
;;运行`C-wai'  运行 android-ant-install 将helloworld程序发布到emulator上
;; 另外,android-mode 会在根目录下生成TAGS文件,所以可以结合helm-etags+.el使用
(autoload 'android-root "android-mode")
(autoload 'android-mode "android-mode" "android mode." t)
(add-hook 'dired-mode-hook (lambda () (when (android-root) (android-mode t))))
(add-hook 'find-file-hook (lambda () (when (android-root) (android-mode t))))

(eval-after-load 'android-mode
  '(progn
     ;; 模拟器的名字 用这个命令启动之     emulator -avd test
     (setq-default android-mode-avd "test")
     ;; (defconst android-mode-keys
     ;;   '(("d" . android-start-ddms)
     ;;     ("e" . android-start-emulator)
     ;;     ("l" . android-logcat)
     ;;     ("C" . android-ant-clean)
     ;;     ("c" . android-ant-compile)
     ;;     ("i" . android-ant-install)
     ;;     ("r" . android-ant-reinstall)
     ;;     ("u" . android-ant-uninstall)))
     ;; (setq-default android-mode-key-prefix "\C-wa")
     (when (equal system-type 'gnu/linux)
       (setq android-mode-sdk-dir "/java/java/android-sdk-linux_86/")
       )
     (when (equal system-type 'darwin)
       (setq android-mode-sdk-dir (getenv "ANDROID_HOME")))
     ))

(provide 'joseph-android)
;;; joseph-android.el ends here
