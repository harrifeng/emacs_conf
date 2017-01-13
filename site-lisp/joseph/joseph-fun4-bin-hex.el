;;; joseph-fun4-bin-hex.el --- 处理二进制、十六进制的一些函数    -*- coding:utf-8 -*-

;; Description: 处理二进制、十六进制的一些函数
;; Created: 2011-10-31 09:47
;; Last Updated: 纪秀峰 2013-12-07 11:34:00 
;; Author: 纪秀峰  jixiuf@gmail.com
;; Maintainer:  纪秀峰  jixiuf@gmail.com
;; Keywords: hex
;; URL: http://www.emacswiki.org/emacs/joseph-fun4-bin-hex.el

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
;; 可以用calc 的功能
;; 如计算1+2 : 1 enter 2 enter +,即先输入数，再输入运算符，+-*/^
;; d2 将当前int 转为二进制
;; d6 转为16进制
;; d8 转为8进制
;; d0 转为十进制
;; 当我们只是想简单的对一系列数字进行代数运算时，使用逆波兰表达式不是很直观，因此， calc 提供了一个更加直接的指令：
;; ' （就是分号旁边的那个按键）
;; 比如，在 calc 中按“'”，然后输入算式：
;; (3^2 + 4^2) ^ 0.5

;; 二进制数的输入方法
;; 2#01010101
;; 8#131324123
;;
;; 另外，与二进制处理相关的函数绑定在以b开头的键上
;; 如bL,br 左移右移
;; ba bo bn  ,and or not

;;; Commands:
;;
;; Below are complete command list:
;;
;;  `decimal++'
;;    Increment the number forward from point by 'arg'.
;;  `hexadecimal++'
;;    Increment the number forward from point by 'arg'.
;;  `binary++'
;;    Increment the number forward from point by 'arg'.
;;  `hexadecimal-2-int'
;;    打印光标下十六进制的值.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Code:
;; ;;;###autoload
;; (defun decimal++ (&optional arg)
;;   "Increment the number forward from point by 'arg'."
;;   (interactive "p*")
;;   (save-excursion
;;     (save-match-data
;;       (let (inc-by field-width answer)
;;         (setq inc-by (if arg arg 1))
;;         (skip-chars-backward "0123456789")
;;         (when (re-search-forward "[0-9]+" nil t)
;;           (setq field-width (- (match-end 0) (match-beginning 0)))
;;           (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
;;           (when (< answer 0)
;;             (setq answer (+ (expt 10 field-width) answer)))
;;           (replace-match (format (concat "%0" (int-to-string field-width) "d")
;;                                  answer)))))))

;; ;;;###autoload
;; (defalias 'int++ 'decimal++)

;; ;;;###autoload
;; (defun hexadecimal++ (&optional arg)
;;   "Increment the number forward from point by 'arg'."
;;   (interactive "p*")
;;   (save-excursion
;;     (save-match-data
;;       (let (inc-by field-width answer hex-format)
;;         (setq inc-by (if arg arg 2))
;;         (skip-chars-backward "0123456789abcdefABCDEF")
;;         (when (re-search-forward "[0-9a-fA-F]+" nil t)
;;           (setq field-width (- (match-end 0) (match-beginning 0)))
;;           (setq answer (+ (string-to-number (match-string 0) 16) inc-by))
;;           (when (< answer 0)
;;             (setq answer (+ (expt 16 field-width) answer)))
;;           (if (equal (match-string 0) (upcase (match-string 0)))
;;               (setq hex-format "X")
;;             (setq hex-format "x"))
;;           (replace-match (format (concat "%0" (int-to-string field-width)
;;                                          hex-format)
;;                                  answer)))))))
;; ;;;###autoload
;; (defun binary++ (&optional arg)
;;   "Increment the number forward from point by 'arg'."
;;   (interactive "p*")
;;   (save-excursion
;;     (save-match-data
;;       (let (inc-by field-width answer)
;;         (setq inc-by (if arg arg 1))
;;         (skip-chars-backward "01")
;;         (when (re-search-forward "[0-1]+" nil t)
;;           (setq field-width (- (match-end 0) (match-beginning 0)))
;;           (setq answer (+ (string-to-number (match-string 0) 2) inc-by))
;;           (when (< answer 0)
;;             (setq answer (+ (expt 2 field-width) answer)))
;;           (replace-match (format-bin answer field-width)))))))
;; aaaaaa
;; (defun hexadecimal-2-int ()
;;   "打印光标下十六进制的值.
;; Prints the decimal value of a hexadecimal string under cursor.
;; Samples of valid input:

;;   ffff
;;   0xffff
;;   #xffff
;;   FFFF
;;   0xFFFF
;;   #xFFFF

;; Test cases
;;   64*0xc8+#x12c 190*0x1f4+#x258
;;   100 200 300   400 500 600"
;;   (interactive )

;;   (let (inputStr tempStr p1 p2 )
;;     (save-excursion
;;       (search-backward-regexp "[^0-9A-Fa-fx#]" nil t)
;;       (forward-char)
;;       (setq p1 (point) )
;;       (search-forward-regexp "[^0-9A-Fa-fx#]" nil t)
;;       (backward-char)
;;       (setq p2 (point) ) )

;;     (setq inputStr (buffer-substring-no-properties p1 p2) )

;;     (let ((case-fold-search nil) )
;;       (setq tempStr (replace-regexp-in-string "^0x" "" inputStr )) ; C, Perl, …
;;       (setq tempStr (replace-regexp-in-string "^#x" "" tempStr )) ; elisp …
;;       (setq tempStr (replace-regexp-in-string "^#" "" tempStr ))  ; CSS …
;;       )

;;     (message "Hex %s is %d" tempStr (string-to-number tempStr 16 ) )
;;     ))

;; ;;;###autoload
;; (defun hex-to-int (hexstring)
;;   "for example:`(hex-to-int \"af\")'"
;;   (car (read-from-string (concat "#x" hexstring))))

;; (defun int-2-binary-1 (val width)
;;   "Convert a number to a binary string.
;; eq:.(format-bin 12 16)"
;;   (let (result)
;;     (while (> width 0)
;;       (if (equal (mod val 2) 1)
;;           (setq result (concat "1" result))
;;         (setq result (concat "0" result)))
;;       (setq val (/ val 2))
;;       (setq width (1- width)))
;;     result))

;; ;;;###autoload
;; (defun int-2-binary()
;;   (interactive)
;;   (insert " "   (int-2-binary-1 (string-to-number (thing-at-point 'symbol)) 32) " "))

;; ;;;###autoload
;; (defalias 'decimal-2-binary 'int-2-binary)

(provide 'joseph-fun4-bin-hex)
;;; joseph-fun4-bin-hex.el ends here
