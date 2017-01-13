;;; Code:
(autoload 'eim-use-package "eim" "Another emacs input method")
;; Tooltip 暂时还不好用
(setq eim-use-tooltip t)
(setq-default eim-page-length 5)

(register-input-method
 "eim-wb" "euc-cn" 'eim-use-package
 "五笔" "汉字五笔输入法" "wb.txt")

;; (register-input-method
;;  "eim-wb" "euc-cn" 'eim-use-package
;;  "五笔拼音" "五笔拼音输入法" "wbpy.txt")

;; (register-input-method
;;  "eim-py" "euc-cn" 'eim-use-package
;;  "拼音" "汉字拼音输入法" "py.txt")

;; 用 ; 暂时输入英文
;; (require 'eim-extra)
;; (global-set-key ";" 'eim-insert-ascii)

(setq-default default-input-method "eim-wb")

(provide 'joseph-eim)

;; evil-mode 本身就支持 ，在非insert state下 ，不启用input method
;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-eim.el ends here
