;;; joseph-company.el --- Description

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords:
;; URL:

;; Copyright (C) 2016, 纪秀峰, all rights reserved.

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

;;; Code:


;; (setq company-backends '(company-clang
;;                          company-capf
;;                          company-c-headers
;;                          company-jedi))
(with-eval-after-load 'company
  (setq company-idle-delay 0.08)
  (setq company-minimum-prefix-length 2 )
  (define-key company-mode-map (kbd "C-[ [ a h") 'company-other-backend) ;iterm map to C-i
  (define-key company-active-map (kbd "C-e") #'company-other-backend)
  (define-key company-active-map (kbd "C-s") #'ecompany-filter-candidates)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  ;; (define-key company-mode-map (kbd "C-:") 'helm-company)
  ;; (define-key company-active-map (kbd "C-:") 'helm-company)

  )

(provide 'joseph-company)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-company.el ends here
