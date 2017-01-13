;;; joseph-nxml.el --- Description   -*- coding:utf-8 -*-

;; Description: Description
;; Time-stamp: <Joseph 2011-10-19 14:07:33 星期三>
;; Created: 2010-08-29 14:37
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords:
;; URL:http://www.emacswiki.org/emacs/joseph-nxml.el

;; Copyright (C) 2010, 纪秀峰, all rights reserved.

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
;;  `indent-xml-region'
;;    Pretty format XML markup in region. You need to have nxml-mode
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;


(eval-when-compile (require 'nxml-mode) )

;; (require 'nxml-mode)
(autoload 'nxml-complete "nxml-mode" "nxml-complete." t)

(setq magic-mode-alist (cons '("<\\?xml " . nxml-mode) magic-mode-alist))

(fset 'xml-mode 'nxml-mode)
;; 默认使用的schemas.xml 在 /usr/share/emacs/23.3/etc/schema/schemas.xml中,
(eval-after-load 'rng-loc
  '(progn
     (add-to-list 'rng-schema-locating-files (expand-file-name "~/.emacs.d/script/nxml/schemas.xml"))
     ))

(defun nxml-mode-hook-fun ()
  ;;默认绑定的键是`C-cC-sC-a' ,将当前编辑的文件与特定的rnc 文件进行关联,只有
  ;;关联后的xml 才可以解析其语法规则进行补全
  (require 'rng-valid)
  (rng-auto-set-schema-and-validate)
  ;; (auto-fill-mode)
  ;; (hs-minor-mode 1)
  (when (string-match "\\.xaml$" (buffer-name)) (auto-revert-mode))
  )
(add-hook 'nxml-mode-hook 'nxml-mode-hook-fun)

;; <typeId id="XSLT" uri="xslt.rnc"/>
;; <typeId id="XSLT_alias" typeId="XSLT"/>
;; 对于定义了一个typeId 后可以在nxml-mode中
;; 使用 `C-cC-sC-t' 列出所有的typeId ,以便使当前buffer用特定的typeId进行解析
;; 使用 `C-cC-sC-w' 在minibuffer中显示你当前使用哪个schema进行解析,若没用任务schema
;; 则显示 :“Using vacuous schema”.
;; 使用 `C-cC-sC-f'让你选择使用哪一个schema文件对其进行解析
;; 使用 `C-cC-sC-a' 当你当前编辑的xml 的根元素存在,它会根据根元素到你的schemas.xml
;; 文件中寻找你所有配置的通过根元素进行匹配的规则来自动选择schema对当前文件进行解析
;; `C-cC-sC-l' Add a rule to the local schema locator file schemas.xml that
;; connects the current document to its schema.

;; 如果一个xml与schema进行了关联可以用
;; `C-cC-n' 跳到下一次不合法的地方
;; `C-cC-v' urn validation on or off


;;C-c C-x 插入<?xml version="1.0" encoding="utf-8"?>
;;Set the schema for this buffer automatically and turn on `rng-validate-mode'.
;;C-c C-s C-a (rng-auto-set-schema-and-validate)
;;根据当前文件的内容决定用哪一个schema 进行补全验证等,
;;C-return  nxml-complete
;; (define-key nxml-mode-map "\t" 'nxml-complete)
(define-key nxml-mode-map  [(meta) (return)] 'nxml-finish-element)
;;C-c C-b 在下一行补齐 end tag  ,如 <head 时输入
;;C-c TAB  在同一行关闭end tag
;;C-c C-f 关闭最近的未关闭的tag ,好像与C-c TAB 有点类似
;;树形导航
;;C-M-u 上一层元素
;;C-M-d 下一层元素
(setq-default nxml-auto-insert-xml-declaration-flag nil)
(setq-default nxml-attribute-indent 2)
(setq-default nxml-bind-meta-tab-to-complete-flag t)
(setq-default nxml-slash-auto-complete-flag t);;"</" 自动补全
;;<h1 > hello,-|- world </h1>  (-|-代表光标) C-c RET会分之为
;;<h1>hello,</h1> <h1>world</h1>
;;C-c RET (nxml-split-element)

;;; hideshow for nxml
(eval-after-load 'hideshow
  (add-to-list 'hs-special-modes-alist
               '(nxml-mode
                 "\\|<[^/>]&>\\|<[^/][^>]*[^/]>"
                 ""
                 nil)))


;;; xml indent format code
(define-key nxml-mode-map "\C-\M-\\" 'indent-xml-region)
(defun indent-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this. The function inserts linebreaks to separate tags that have
nothing but whitespace between them. It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n")
      )
    (mark-whole-buffer)
    (indent-region begin end)
                                        ;(indent-region point-min point-max)
    )
  (message "Ah, much better!"))

(provide 'joseph-nxml)
;;; joseph-nxml.el ends here
