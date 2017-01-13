;;; -*- coding:utf-8 -*-
;; (eval-when-compile
;;   (require 'joseph_byte_compile_include)
;;   (require 'org)
;;   ;; (require 'org-html nil t)
;;   (require 'ox-html nil t)
;;   (require 'yasnippet)
;;   (require 'joseph-outline-lazy))

;; (require 'org-publish nil t)
(require 'ox-publish nil t)
(require 'ox-org nil t)
(require 'ob-ditaa nil t)

;;; the following is only needed if you install org-page manually
(require 'org-page)
(setq op/site-main-title "一个人的狂欢")
(setq op/site-sub-title "")
(setq op/personal-github-link "http://github.com/jixiuf")
(setq op/repository-directory "~/Documents/org/")
(setq op/site-domain "http://jixiuf.github.io")
;;; for commenting, you can choose either disqus or duoshuo
(setq op/personal-disqus-shortname "jixiuf")
(setq op/personal-duoshuo-shortname "jixiuf")
(setq op/theme-root-directory "~/.emacs.d/org-page-themes")
(setq op/theme 'jixiuf_theme)
(setq op/highlight-render 'htmlize)
;;; the configuration below are optional
;; (setq op/personal-google-analytics-id "jixiuf")


;; (require 'org-exp-blocks nil t)           ;#+BEGIN_DITAA hello.png -r -S -E 要用到
(setq org-ditaa-jar-path (expand-file-name "~/.emacs.d/script/ditaa.jar"))
(with-eval-after-load 'org-exp-blocks  (add-to-list 'org-babel-load-languages '(ditaa . t)))

;; (declare-function org-publish "ox-publish")
;; (declare-function yas-global-mode "yasnippet")


;;;###autoload
(defun publish-my-note-recent(&optional n)
  "发布我的`note'笔记"
  (interactive "p")
  (when (zerop n) (setq n 1))
  (save-some-buffers)
  (dolist (b (buffer-list))
    (when (and (buffer-file-name b)
               (file-in-directory-p (buffer-file-name b) op/repository-directory))
      (kill-buffer b)))
  (op/do-publication nil (format "HEAD^%d" n) t nil)
  ;; (publish-single-project "note-src")
  ;; ;; (publish-my-note-html)
  ;; (publish-single-project "note-html")
  ;; (view-sitemap-html-in-brower)
  (dired op/repository-directory))

;;;###autoload
(defun publish-my-note-local-preview()
  "发布我的`note'笔记"
  (interactive)
  (save-some-buffers)
  (dolist (b (buffer-list))
    (when (and (buffer-file-name b)
               (file-in-directory-p (buffer-file-name b) op/repository-directory))
      (kill-buffer b)))
  (call-interactively 'op/do-publication-and-preview-site)
  (dired op/repository-directory))
;;;###autoload

(defun publish-my-note-all()
  "发布我的`note'笔记"
  (interactive)
  (save-some-buffers)
  (dolist (b (buffer-list))
    (when (and (buffer-file-name b)
               (file-in-directory-p (buffer-file-name b) op/repository-directory))
      (kill-buffer b)))
  (op/do-publication t nil t t)
  (dired op/repository-directory))



(setq op/category-ignore-list  '("themes" "assets" "daily" "style" "img" "js" "author" "download"
                                 "docker"
                                 "nginx" "cocos2dx" "mac"
                                 "Linux" "autohotkey" "c"   "emacs" "emacs_tutorial" "erlang" "git" "go" "java" "mysql"
                                 "oracle" "passhash.htm" "perl" "sqlserver"  "svn" "windows"))


(setq-default op/category-config-alist
  '(("blog" ;; this is the default configuration
    :show-meta t
    :show-comment t
    :uri-generator op/generate-uri
    :uri-template "/blog/%t/"
    :sort-by :date     ;; how to sort the posts
    :category-index t) ;; generate category index or not
   ("index"
    :show-meta nil
    :show-comment nil
    :uri-generator op/generate-uri
    :uri-template "/"
    :sort-by :date
    :category-index nil)
   ("about"
    :show-meta nil
    :show-comment nil
    :uri-generator op/generate-uri
    :uri-template "/about/"
    :sort-by :date
    :category-index nil)))


;; (add-to-list 'op/category-config-alist
;;              '("sitemap"
;;               :show-meta nil
;;               :show-comment nil
;;               :uri-generator op/generate-uri
;;               :uri-template "/blog/sitemap"
;;               :sort-by :date
;;               :category-index nil)
;;              )


(defun jixiuf-get-file-category (org-file)
  "Get org file category presented by ORG-FILE, return all categories if
ORG-FILE is nil. This is the default function used to get a file's category,
see `op/retrieve-category-function'. How to judge a file's category is based on
its name and its root folder name under `op/repository-directory'."
  (cond ((not org-file)
         (let ((cat-list '("index" "about" "blog"))) ;; 3 default categories
           (dolist (f (directory-files op/repository-directory))
             (when (and (not (equal f "."))
                        (not (equal f ".."))
                        (not (equal f ".git"))
                        (not (member f op/category-ignore-list))
                        (not (equal f "blog"))
                        (file-directory-p
                         (expand-file-name f op/repository-directory)))
               (setq cat-list (cons f cat-list))))
           cat-list))
        ((string= (expand-file-name "index.org" op/repository-directory)
                  (expand-file-name org-file)) "index")
        ;; ((string= (expand-file-name "sitemap.org" op/repository-directory)
        ;;           (expand-file-name org-file)) "sitemap")
        ((string= (expand-file-name "about.org" op/repository-directory)
                  (expand-file-name org-file)) "about")
        ((string= (file-name-directory (expand-file-name org-file))
                  op/repository-directory) "blog")

        (t "blog"                       ;changed by me ,默认都算到blog 下
           ;; (car (split-string (file-relative-name (expand-file-name org-file)
           ;;                                                   op/repository-directory)
           ;;                               "[/\\\\]+"))
           )))

(fset 'op/get-file-category 'jixiuf-get-file-category)
(setq op/retrieve-category-function 'jixiuf-get-file-category)


;;这个文件主要用到了Emacs 自带的org-publish.el文件的功能，
;;主要是将我写的org 文件，自动发布(根据org文件自动生成生成)成相应的html 文件（当然也可以发布成其他格式，如pdf），
;;而发布后的所有html文件 ,我会把它上传到网上我的一个免费php空间里，
;;也就是说，我要用Emacs 的org-publish.el 功能，管理我的个人空间
;;我的笔记的所有文件都在`note-root-dir'这个变量指定的目录里，
;;因为我会在linux ,与Windows 两个系统里同时使用，所以针对系统的不同设置不同的值，
;;假如 `note-root-dir' 的值为`d:/documents/org'
;;那么，它的目录结构会是
;; `d:/documents/org/'
;; `d:/documents/org/src'
;; `d:/documents/org/public_html'
;; `d:/documents/org/public_html/src'
;; `d:/documents/org/public_html/htmlized-src'
;;
;; `d:/documents/org/src'目录下是最原始的org文件，当然也可能包含jpg js,gif mp3 css 等其他格式的文件，
;; Emacs 的org-publish.el的功能就是根据这个目录里的文件自动生成相应的html文件（以发布为html 格式为例），
;; 而自动生成的文件会放到`d:/documents/org/public_html'目录下
;;注意这个目录结构是我自定议的，你完全可以把org 文件放在`c:/' ,而生成的`html'文件，放在任何你想放的目录
;;

;;注意如果你修改了这里的路径，需要保证目录名称后面一定要有"/"



;; ;;注意，这个alist 分成了三部分，`note-org' ,`note-static' `note'
;; ;;其中`note-org' 完成的功能是把`note-org-src-dir'目录下的所有org 文件，
;; ;; 转换生成html 文件，并放到`org-html-publish-to-html'目录中
;; (setq org-publish-project-alist
;;       `(
;;         ("note-html"
;;          :components ("base-note-org-html" "base-note-static" )
;;          :author "jixiuf at gmail dot com")
;;         ("note-src"  ;;这个发布org的源代码，直接把org源代码copy 到相应目录及copy htmlized后的org.html到相应目录
;;          :components ( "base-note-org-org"
;;                        ;; "base-note-org-htmlize"
;;                        )
;;          :author "jixiuf at gmail dot com")
;;         ("base-note-org-html"
;;          :base-directory ,note-org-src-dir              ;;原始的org 文件所在目录
;;          :publishing-directory ,note-org-public-html-dir   ;;发布生后成的文件存放的目录
;;          :base-extension "org"  ;; 对于以`org' 结尾的文件进行处理
;;          :recursive t       ;;递归的处理`note-org-src-dir'目录里的`org'文件
;;          :publishing-function org-html-publish-to-html ;;发布方式,以html 方式
;;          :preparation-function before-publish-single-project-hook-func
;;          :completion-function after-publish-single-project-hook-func

;;          :section-numbers nil
;;          ;; :auto-sitemap t                ; Generate sitemap.org automagically...自动生成站点地图所用的site-map.org
;;          :sitemap-filename "sitemap.org"  ; ... call it sitemap.org (it's the default)...
;;          :sitemap-title "站点地图"         ; ... with title 'Sitemap'.
;;          :exclude ,publish-ignore-regex
;;          :time-stamp-file nil
;;          ;;        :sitemap-function org-publish-org-sitemap
;;          ;; :preparation-function org-publish-org-tag
;;          ;;         :makeindex
;;          ;;         :style ,(surround-css-with-style-type (format "%sstyle/emacs.css" note-org-src-dir)) ;;din't need it now
;;                                         ; :style "<link rel=\"stylesheet\" href=\"/style/emacs.css\" type=\"text/css\"/>"
;;          )
;;         ("base-note-static"                         ;;有了`note-org' 那一组的注释，这里就不详细给出注释了
;;          :base-directory ,note-org-src-dir
;;          :publishing-directory ,note-org-public-html-dir
;;          :recursive t
;;          :base-extension "pl\\|css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|swf\\|zip\\|gz\\|txt\\|el\\|reg\\|htm\\|exe\\|msi\\|c\\|xml\\|doc\\|Makefile"
;;          :publishing-function org-publish-attachment
;;          :preparation-function before-publish-single-project-hook-func
;;          :completion-function after-publish-single-project-hook-func
;;          )

;;         ("base-note-org-org"  ;;直接把src/目录下org 文件copy 到，public_html目录，并且把src/目录下的.org.html 也copy到public_html
;;          :base-directory ,note-org-src-dir              ;;原始的org 文件所在目录
;;          :publishing-directory ,note-org-public-org-src-dir   ;;发布生后成的文件存放的目录
;;          :base-extension "org"  ;; 对于以`org' 结尾的文件进行处理
;;          :recursive t       ;;递归的处理`note-org-src-dir'目录里的`org'文件
;;          :publishing-function org-org-publish-to-org
;;          :preparation-function before-publish-single-project-hook-func
;;          :completion-function after-publish-single-project-hook-func
;;          :exclude ,publish-ignore-regex
;;          ;; :plain-source   ;;这个直接 copy org文件
;;          ;; :htmlized-source ;;这个copy org.html 文件，这种文件一般是htmlfontify-buffer 生成的html 文件
;;          )
;;         ("base-note-org-htmlize"       ;;把org 文件，htmlize 化，生成的文件便于网上浏览，face 就是我所使用的Emacs 对应的face(即语法着色)
;;          :base-directory ,note-org-src-dir
;;          :base-extension "org"
;;          :html-extension "org.html"
;;          :publishing-directory ,note-org-public-org-htmlized-src-dir
;;          :preparation-function before-publish-single-project-hook-func
;;          :completion-function after-publish-single-project-hook-func
;;          :recursive t
;;          ;; :htmlized-source t
;;          :publishing-function org-org-publish-to-org)
;;         ))


;; (setq-default org-publish-timestamp-directory  (convert-standard-filename "~/.emacs.d/cache/org-files-timestamps"))
;; (setq-default org-html-link-home "sitemap.html"
;;               org-export-default-language "zh"
;;               ;; org-html-head-include-default-style nil ;不用默认的style
;;               ;; org-html-head-include-scripts nil ;
;;               ;; org-html-head "<link rel='stylesheet' type="text/css' href='style/emacs.css' />"
;;               ;;org 的文档是用* 一级级表示出来的，而此处设置前两级用作标题，其他是这些标题下的子项目
;;               ;; 在每个org 文件开头，加 #+OPTIONS: H:4 可以覆盖这里的默认值，
;;               org-export-headline-levels 2

;;               ;; org-html-extension "html"  ;;
;;               org-html-xml-declaration '(("html" . "");;这个表示在生成的html 文件首行添加<%xml ...%> 一句，感觉没必要，且会引起一些问题
;;                                          ("php" . "<?php echo \"<?xml version=\\\"1.0\\\" encoding=\\\"%s\\\" ?>\"; ?>"))
;;               org-html-validation-link "" ;;不在生成的html中插入validation 的链接
;;               ;; org-export-time-stamp-file t ;  :time-stamp-file
;;               org-export-with-timestamps t
;;               ;; org-html-timestamp t
;;               org-export-with-section-numbers nil
;;               org-export-with-tags 'not-in-toc
;;               ;; org-export-skip-text-before-1st-heading nil
;;               org-export-with-sub-superscripts '{}
;;               ;; org-export-with-LaTeX-fragments t
;;               org-export-with-archived-trees nil
;;               ;; org-export-highlight-first-table-line t
;;               ;; org-export-latex-listings-w-names nil
;;               ;; org-export-html-style-include-default nil
;;               ;; org-export-htmlize-output-type 'css
;;               org-publish-list-skipped-files t
;;               org-publish-use-timestamps-flag t ;;这个在发布一个网站的时候它会记住每一个org文件的最后修改时间，下次发布时如果这个文件没被修改就不会发布此文件，只发布修改过的文件
;;               ;; org-export-babel-evaluate nil
;;               org-confirm-babel-evaluate nil
;;               org-html-postamble '(("en" "<p class=\"author\">Author: %a (%e)</p><p class=\"date\">Date: %d</p><p class=\"creator\">Generated by %c</p><p class=\"xhtml-validation\">%v</p> ")
;;                                    ("zh" "<p class=\"author\">Author: %a (%e)</p>\n<p class=\"date\">Date: %d</p>\n<p class=\"creator\">Generated by %c</p>\n<p class=\"xhtml-validation\">%v</p>\n"))
;;               org-html-home/up-format "<div id=\"org-div-home-and-up\" style=\"text-align:right;font-size:70%%;white-space:nowrap;\">\n <a accesskey=\"h\" href=\"%s\"> 站点地图 </a>\n |\n <a accesskey=\"H\" href=\"%s\"> 首页 </a>\n</div>"
;;               )

;; ;;;###autoload
;; (defun publish-my-note-force()
;;   (interactive)
;;   (setq org-publish-use-timestamps-flag nil)
;;   ;;  (load "joseph-org-publish.el")
;;   ;;  (shell-command (format "find  %s  |xargs touch  " note-org-src-dir ))
;;   (publish-my-note)
;;   (setq org-publish-use-timestamps-flag t)
;;   )

;; (with-eval-after-load 'ox
;;   (add-hook 'org-export-before-processing-hook 'include-diffenert-org-in-different-level)
;;   (add-hook 'org-export-before-processing-hook 'insert-src-link-2-each-page))
;; (defun view-sitemap-html-in-brower()
;;   (let ((sitemap-html  (expand-file-name "sitemap.html" note-org-public-html-dir)))
;;     (start-process-shell-command "open" nil (concat "open " sitemap-html))))

;; (defun publish-my-note-html()
;;   "发布我的`note'笔记"
;;   (interactive)
;;   ;;(add-hook 'org-export-before-processing-hook 'org-generate-tag-links)
;;   ;; (add-hook 'org-export-before-processing-hook 'org-generate-tag-links)
;;   ;; (add-hook 'org-export-before-processing-hook 'set-diffenert-js-path-in-diffenert-dir-level)
;;   ;; (publish-single-project "note-html")
;;   ;;  (org-publish (assoc "note-html" org-publish-project-alist))
;;   ;; (remove-hook 'org-export-before-processing-hook 'org-generate-tag-links)
;;   ;; (remove-hook 'org-export-before-processing-hook 'include-diffenert-org-in-different-level)
;;   ;; (remove-hook 'org-export-before-processing-hook 'set-diffenert-js-path-in-diffenert-dir-level)
;;   ;; (remove-hook 'org-export-before-processing-hook 'insert-src-link-2-each-page)
;;   )

;; (defun publish-my-note-src()
;;   "这个直接把我的org 文件copy 到相应的目录，所以不需要`include-diffenert-org-in-different-level'
;; 这个hook,因为它会修改org 的文件，如果这样的话copy 过去的文件就不是原始文件了。"
;;   (interactive)
;;   ;;(org-publish (assoc "note-src" org-publish-project-alist))
;;   )


;;之所以定义这个繁锁的publish-single-project 是因为，我启用了auto-insert
;;在新建文件时它会自动加入一部分内容，为了排除它的影响，我会在publish 时关闭这个功能
;;publish 结束后，再启用这个功能 。
;;如果你没用auto-insert则只需要适当调整hook该运行的内容
;; (defvar before-publish-single-project-hook nil)
;; (defvar after-publish-single-project-hook nil)

;; (defun publish-single-project(project-name)
;;   "publish single project ,and add before and after hooks"
;;   ;; (run-hooks 'before-publish-single-project-hook)
;;   ;; (before-publish-single-project-hook-func)
;;   (org-publish (assoc project-name org-publish-project-alist))
;;   ;; (run-hooks 'after-publish-single-project-hook)
;;   ;; (after-publish-single-project-hook-func)
;;   )
;; (add-hook 'before-publish-single-project-hook 'before-publish-single-project-hook-func)

;; (defun before-publish-single-project-hook-func()
;;   (auto-insert-mode -1)
;;   ;; (remove-hook 'emacs-lisp-mode-hook 'el-outline-mode-hook)
;;   ;; (remove-hook 'find-file-hook 'yasnippet-auto-insert-fun)
;;   (remove-hook 'perl-mode-hook 'perl-mode-hook-fun)
;;   (yas-global-mode -1)
;;   (recentf-mode -1)
;;   )
;; (add-hook 'after-publish-single-project-hook 'after-publish-single-project-hook-func)
;; (defun after-publish-single-project-hook-func()
;;   (auto-insert-mode 1)
;;   ;; (add-hook 'emacs-lisp-mode-hook 'el-outline-mode-hook)
;;   ;; (add-hook 'find-file-hook 'yasnippet-auto-insert-fun)
;;   (add-hook 'perl-mode-hook 'perl-mode-hook-fun)
;;   (yas-global-mode 1)
;;   (recentf-mode 1)
;;   )

;; (defun include-diffenert-org-in-different-level(&optional backend)
;;   "这个会根据当前要export的org 文件相对于`note-org-src-dir'的路径深度，决定在当前文件头部引入哪个文件
;;  如果在`note-org-src-dir'根目录,则 引入~/.emacs.d/org-templates/`level-0.org' ,在一层子目录则是`level-1.org'"
;;   (when (equal backend 'html)
;;     (when (string-match (regexp-quote note-org-src-dir) (buffer-file-name))
;;       (let* ((relative-path-of-note-src-path (file-relative-name (buffer-file-name) note-org-src-dir))
;;              (relative-level 0))
;;         (dolist (char (string-to-list relative-path-of-note-src-path))
;;           (when (char-equal ?/ char)(setq relative-level (1+ relative-level))))
;;         (set (make-variable-buffer-local  'org-html-head-include-default-style) nil) ;
;;         (set (make-variable-buffer-local 'org-html-head-include-scripts) nil)
;;         (save-excursion
;;           (goto-char (point-min))
;;           (insert (format "#+SETUPFILE: ~/.emacs.d/org-templates/level-setupfile-%d.org\n" relative-level))
;;           (insert (format "#+INCLUDE: ~/.emacs.d/org-templates/level-%d.org\n" relative-level))
;;           (insert "#+INCLUDE: ~/.emacs.d/org-templates/level-all.org\n"))))))

;; (defun set-diffenert-js-path-in-diffenert-dir-level(&optional backend)
;;   "这个函数会根据当前要export的org 文件相对于`note-org-src-dir'的
;; 路径深度决定`note-org-src-dir'/js/emacs.js 文件的相对路径。
;; 不使用绝对路径以保证无论发布到本地还是网上都可以正常浏览。"
;;   (when (equal backend 'html)
;;     (let* ((relative-path-of-js-file
;;             (file-relative-name
;;              (format "%sjs/emacs.js" note-org-src-dir)
;;              (file-name-directory (buffer-file-name)))))
;;       (setq  org-html-scripts
;;              (format "<script type='text/javascript' src='%s'> </script>" relative-path-of-js-file)))))

;; ;;(add-hook 'org-export-before-processing-hook 'set-diffenert-js-path-in-diffenert-dir-level)
;; (defun insert-src-link-2-each-page(&optional backend)
;;   (when (equal backend 'html)
;;     (when (string-match (regexp-quote note-org-src-dir) (buffer-file-name))
;;                         (let* ((relative-path-of-cur-buf (file-relative-name  (buffer-file-name) note-org-src-dir ))
;;                                (relative-link-to-src-file-in-public-html-dir
;;                                 (file-relative-name  (concat note-org-public-org-src-dir relative-path-of-cur-buf)
;;                                                      (file-name-directory (concat note-org-public-html-dir relative-path-of-cur-buf))))
;;                                ;; (relative-link-to-htmlized-src-file-in-public-html-dir  (format "%s.html" (file-relative-name  (concat note-org-public-org-htmlized-src-dir relative-path-of-cur-buf) (file-name-directory (concat note-org-public-html-dir relative-path-of-cur-buf)))))
;;                                )
;;                           (save-excursion
;;                             (goto-char (point-max))
;;                             (insert (format "\n#+begin_html\n<div id='my-src'>\n<div id='org-src'><a href='%s'>src</a></div>\n#+end_html"
;;                                             relative-link-to-src-file-in-public-html-dir )))))))

;; (autoload 'joseph-all-files-under-dir-recursively "joseph-file-util" "get all file under dir ,match regexp" nil)

;; (defun joseph-get-all-tag-buffer-alist(project)
;;   "get all tag names from all org files under `note-org-src-dir'
;; the key is tagname ,and value = a list of file contains this tag"
;;   (let* ((project-plist (cdr project))
;;          (exclude-regexp (plist-get project-plist :exclude))
;;          (all-org-files (nreverse (org-publish-get-base-files project exclude-regexp)))
;;         buf-tags tag-buf-alist tag-name tag-buf-kv cdr-val buf-exists)
;;     (dolist (org all-org-files)
;;       (setq buf-exists  (find-buffer-visiting org))
;;       (with-current-buffer (or buf-exists (find-file-noselect org))
;;         (setq buf-tags (org-get-buffer-tags))
;;         (when (> (length buf-tags) 0)
;;           (dolist (tag buf-tags)
;;             (setq tag-name (substring-no-properties (car tag)))
;;             (setq tag-buf-kv (assoc  tag-name tag-buf-alist))
;;             (if tag-buf-kv
;;                 (progn
;;                   (setq cdr-val (cdr tag-buf-kv))
;;                   (setcdr tag-buf-kv (add-to-list  'cdr-val (buffer-file-name))))
;;               (setq tag-buf-alist (cons (list tag-name (buffer-file-name) )tag-buf-alist))
;;               )))
;;         (unless buf-exists (kill-buffer))))
;;     tag-buf-alist))

;; ;;(joseph-get-all-tag-buffer-alist (assoc "base-note-org-html" org-publish-project-alist))
;; (defvar tag-buf-alist nil "tagname-buffers alist")
;; (defun org-publish-org-tag ()
;;   "create a tag of pages in set defined by project.
;; optionally set the filename of the tag with sitemap-filename.
;; default for sitemap-filename is 'tag.org'."
;;   (setq tag-buf-alist (joseph-get-all-tag-buffer-alist (assoc "base-note-org-html" org-publish-project-alist)))
;;   (let* ( (dir (file-name-as-directory (concat (file-name-as-directory
;;                                                 (plist-get project-plist :base-directory)) "tags")))
;;          (indent-str (make-string 2 ?\ ))
;;          (tag-buf-alist tag-buf-alist)
;;          files  file tag-buffer tag-title tag-filename visiting ifn)
;;     (dolist (tag-buf-kv tag-buf-alist)
;;       (setq tag-title (concat  "Tag: " (car tag-buf-kv)) )
;;       (setq tag-filename (concat dir (car tag-buf-kv) ".org"))
;;       (setq visiting (find-buffer-visiting tag-filename))
;;       (setq ifn (file-name-nondirectory tag-filename))
;;       (setq files (cdr tag-buf-kv))
;;       (with-current-buffer (setq tag-buffer
;;                                  (or visiting (find-file tag-filename)))
;;         (erase-buffer)
;;         (insert  "# -*- coding:utf-8 -*-\n\n")
;;         (insert (concat "#+TITLE: " tag-title "\n\n"))
;;         (insert  "#+LANGUAGE:  zh\n")
;;         (while (setq file (pop files))
;;           (let ((fn (file-name-nondirectory file))
;;                 (link (file-relative-name file dir))
;;                 )
;;               (let ((entry
;;                      (org-publish-format-file-entry org-sitemap-file-entry-format
;;                                                     file project-plist))
;;                     (regexp "\\(.*\\)\\[\\([^][]+\\)\\]\\(.*\\)"))
;;                 (cond ((string-match-p regexp entry)
;;                        (string-match regexp entry)
;;                        (insert (concat indent-str " + " (match-string 1 entry)
;;                                        "[[file:" link "]["
;;                                        (match-string 2 entry)
;;                                        "]]" (match-string 3 entry) "\n")))
;;                       (t
;;                        (insert (concat indent-str " + [[file:" link "]["
;;                                        entry
;;                                        "]]\n")))))))
;;         (save-buffer))
;;       (or visiting (kill-buffer tag-buffer))
;;       )
;;     ))

;; (defun org-generate-tag-links()
;;   "Create a tag of pages in set defined by PROJECT.
;; Optionally set the filename of the tag with SITEMAP-FILENAME.
;; Default for SITEMAP-FILENAME is 'tag.org'."
;;     (let* ( (dir default-directory)
;;             (indent-str (make-string 2 ?\ ))
;;             (tag-buf-alist tag-buf-alist)
;;             (tags (mapcar 'car tag-buf-alist))
;;               file    html link)
;;       (save-excursion
;;         (goto-char (point-max))
;;         (insert "\n#+begin_html\n<div id='tags'><span id='tags-title'>Tags:</span><br />\n#+end_html\n")
;;         (dolist (tag-name tags)
;;           (setq file (concat (file-name-as-directory note-org-src-dir) "tags/" tag-name ".org"))
;;           (setq link (file-relative-name file dir))
;;           (insert (concat indent-str "  [[file:" link "]["
;;                           tag-name
;;                           "]]\n"))
;;           )
;;         (insert "\n#+begin_html\n</div>\n#+end_html\n")
;;         )
;;       )
;;   )

;; ;;(message (read-file-as-var "D:/Document/org/src/style/emacs.css"))
;; ;;;###autoload
;; (defun read-file-as-var (file-name)
;;   "read file content and return it as string"
;;   (let (buf-content)
;;     (with-current-buffer (find-file-noselect file-name t )
;;       (setq buf-content (buffer-substring  (point-min) (point-max)))
;;       (kill-buffer))
;;     buf-content))

;; ;;;###autoload
;; (defun surround-css-with-style-type(css-file-name)
;;   "read css file content ,and surround it with <style></style>"
;;   (format
;;    "<style type='text/css'>
;;        %s
;;     </style>"
;;    (read-file-as-var css-file-name)))

;; (setq-default org-html-style-default (surround-css-with-style-type (format "%sstyle/emacs.css" note-org-src-dir)))

;; (setq-default org-export-html-coding-system (quote utf-8))


;;( format
;;   "<style type='text/css'>
;;     <![CDATA[
;;       %s
;;     ]]>
;;    </style>"
;;   (read-file-as-var css-file-name)
;; )

;; (defun insert-tag-links-in-each-org()
;;   (let* ((relative-path-of-js-file
;;           (file-relative-name
;;            (format "%sjs/emacs.js" note-org-src-dir)
;;            (file-name-directory (buffer-file-name)))))
;;     (setq  org-html-scripts
;;           (format "<script type='text/javascript' src='%s'> </script>" relative-path-of-js-file))))
(provide 'joseph-org-publish)
