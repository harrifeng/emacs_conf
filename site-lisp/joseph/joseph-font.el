;; https://raw.github.com/baohaojun/system-config/master/.emacs_d/lisp/bhj-fonts.el
;; http://zhuoqiang.me/torture-emacs.html
;; C-uC-x= 可以查看光标下字符的相关信息(如属于哪个字符集，使用了什么字体)

;; 如果配置好了， 下面20个汉字与40个英文字母应该等长
;; here are 20 hanzi and 40 english chars, see if they are the same width
;;
;; aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa|
;; 你你你你你你你你你你你你你你你你你你你你|
;; ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,|
;; 。。。。。。。。。。。。。。。。。。。。|
;; 1111111111111111111111111111111111111111|
;; 東東東東東東東東東東東東東東東東東東東東|
;; ここここここここここここここここここここ|
;; ｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺ|
;; 까까까까까까까까까까까까까까까까까까까까|

;; 把你想要的字体(英文  中文) 分别在 get-my-favorate-english-font get-my-favorate-zh-font
;; 两个函数里加入，（越靠前越优先),
;; 然后(eval-buffer )

;; 设置是调大调小字体大小时使用此种字体的字按怎样的比例来调整 C-xC- C-xC= C-xC
;; 这样调整大小时 中英文同比例调整

(require 'cl-lib)
;; (declare-function cl-find-if "cl-seq")

(setq face-font-rescale-alist
      (append face-font-rescale-alist
              '(("Microsoft Yahei" . 1.2)
                ("新宋体" . 1.2)
                ("微软雅黑" . 1.2)
                ("宋体" . 1.2)
                ("仿宋" . 1.2)
                ("黑体" . 1.2)
                ("SimSun" . 1.2)
                ("SimSun-ExtB" . 1.2)
                ("WenQuanYi Zen Hei" . 1.2))))


(defvar my-defalut-english-fontsize 12.5)

(defun get-my-favorate-english-font()
  (my-make-font-string (cl-find-if
                        #'my-font-existsp
                        '( "Menlo" "Courier New" "Consolas" ;mac
                           "Courier New"      ;mac and w32
                           "Monospace" "DejaVu Sans Mono"
                           "Monaco"))
                       my-defalut-english-fontsize))

(defun get-my-favorate-zh-font()
  (font-spec :family (cl-find-if
                      #'my-font-existsp
                      '( "新宋体" "Microsoft Yahei"
                         "微软雅黑" "黑体"  "宋体"
                         "文泉驿等宽微米黑"))))

(defun my-font-existsp (font)
  (if (null (x-list-fonts font))
      nil t))

(defun my-make-font-string (font-name font-size)
  (if (and (stringp font-size)
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s-%s" font-name font-size)))

(defun my-set-font-func(&optional frame)
  (set-face-attribute 'default nil :font (get-my-favorate-english-font)) ;englisth font
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font t charset (get-my-favorate-zh-font))))


(when (display-graphic-p)  (my-set-font-func))

(add-hook 'after-make-frame-functions 'my-set-font-func t)

(setq font-encoding-alist
      (append '(("MuleTibetan-0" (tibetan . 0))
                ("GB2312" (chinese-gb2312 . 0))
                ("JISX0208" (japanese-jisx0208 . 0))
                ("JISX0212" (japanese-jisx0212 . 0))
                ("VISCII" (vietnamese-viscii-lower . 0))
                ("KSC5601" (korean-ksc5601 . 0))
                ("MuleArabic-0" (arabic-digit . 0))
                ("MuleArabic-1" (arabic-1-column . 0))
                ("MuleArabic-2" (arabic-2-column . 0)))
              font-encoding-alist))


;; (defvar bhj-english-font-size-steps '(10.5 11 11.5 12 12.5 13 13.5 14 15 16 17 18 22))
;; (defvar bhj-english-font-size-steps-dec (reverse bhj-english-font-size-steps))

;; (defun bhj-step-frame-font-size (step)
;;   (let ((steps bhj-english-font-size-steps)
;;         next-size)
;;     (if (< step 0)
;;         (setq steps bhj-english-font-size-steps-dec))
;;     (setq next-size
;;           (cadr (member my-defalut-english-fontsize steps)))
;;     (when next-size
;;         ;; (message  "Your font size is set to %.1f" next-size)
;;         (setq my-defalut-english-fontsize next-size)
;;         (set-face-attribute 'default nil :font (get-my-favorate-english-font))
;;         next-size)))

;; (global-set-key [(control x) (meta -)]
;;                 (lambda ()
;;                   (interactive)
;;                   (with-easy-repeat (bhj-step-frame-font-size -1))))

;; (global-set-key [(control x) (meta =)]
;;                 (lambda () (interactive)
;;                   (with-easy-repeat (bhj-step-frame-font-size 1))))

(provide 'joseph-font)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-font.el ends here
