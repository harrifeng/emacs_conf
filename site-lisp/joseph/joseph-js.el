;;; joseph-js.el --- Description
;;; Code:
;; 要实现js 的补全需要安装 tern
;; http://ternjs.net/
;; Tern is a stand-alone, editor-independent JavaScript
;; analyzer that can be used to improve the JavaScript integration of
;; existing editors.
;; git clone git@github.com:marijnh/tern.git
;; 然后在tern 目录下执行npm install 安装其依赖
;; npm 是js 的package manager tool ,
;; npm  命令 需要安装nodejs 才行，从以下网址下载nodejs安装包
;; http://nodejs.org/download/
;;默认 npm install jquery 安装包 装在 /usr/local/lib/node_modules/npm/node_modules
 (setq-default tern-command (cons (expand-file-name "~/.emacs.d/site-lisp/submodules/tern/bin/tern") '()))

(autoload 'tern-mode "tern.el" nil t)
(defun my-js-mode-hook()
  (setq js-indent-level 2)
  (tern-mode t)
  (add-to-list 'ac-sources 'ac-source-tern-completion)
  (add-to-list 'ac-sources 'ac-source-filename)
  (add-to-list 'ac-sources 'ac-source-yasnippet)
  (add-to-list 'ac-sources 'ac-source-dictionary)
  (add-to-list 'ac-sources 'ac-source-words-in-same-mode-buffers)
  (auto-complete-mode 1)
  )
(add-hook 'js-mode-hook 'my-js-mode-hook)

(with-eval-after-load 'tern
  (require 'tern-auto-complete)
  (tern-ac-setup))


;; M-.
;;     Jump to the definition of the thing under the cursor.
;; M-,
;;     Brings you back to last place you were when you pressed M-..
;; C-c C-r
;;     Rename the variable under the cursor.
;; C-c C-c
;;     Find the type of the thing under the cursor.
;; C-c C-d
;;     Find docs of the thing under the cursor. Press again to open the associated URL (if any).

;; Tern 的配置文件 ~/.tern-config 或者 project 目录下的.tern-project
;; When started, the server will look for a .tern-project file in the
;; current directory or one of the directories above that, and use it
;; for its configuration. If no project file is found, it’ll fall back
;; to a default configuration. You can change this default
;; configuration by putting a .tern-config file, with the same format
;; as .tern-project, in your home directory.

;; 试例 配置文件.tern-project
;; ;; {
;;   "libs": [
;;     "browser",
;;     "jquery",
;;     "ecma5",
;;     "underscore"
;;   ],
;;   "plugins": {
;;     "angular": {},
;;    "node": {}
;;   }

;;  A .tern-project file is a JSON file in a format like this:
;; {
;;   "libs": [
;;     "browser",
;;     "jquery"
;;   ],
;;   "loadEagerly": [    "importantfile.js", "*.js", "*/*.js", "*/*/*.js", "*/*/*/*.js" ],
;;   "dontLoad": [ ".meteor" ],
;;   "plugins": {
;;     "requirejs": {
;;       "baseURL": "./",
;;       "paths": {}
;;     }
;;   }
;; }
;; libs 属性对应 term/defs 下在的内容browser.json    chai.json       ecma5.json      ecma6.json      jquery.json     underscore.json
;; 比如加入browser 就可以实现对document ,window 等浏览器的补全
;; 加入jquery  就对的对 $.开头的函数进行补全
;; libs 的搜索顺序是项目目录下 ，然后才是tern/defs目录下
;; The libs property refers to the JSON type descriptions that should
;; be loaded into the environment for this project. See the tern/defs/
;; directory for examples. The strings given here will be suffixed
;; with .json, and searched for first in the project’s own dir, and
;; then in the defs/ directory of the Tern distribution.

;; loadEagerly 则指定加载哪些js 文件， 可以使用正式表达式如foo/bar/*.js
;;  dontLoad ignore files in  folder.  (上面的试例忽略.meteor目录下的所有js)
;; By default, local files are loaded into the Tern server when
;; queries are run on them the editor. loadEagerly allows you to force
;; some files to always be loaded, it may be an array of filenames or
;; glob patterns (i.e. foo/bar/*.js). The dontLoad option can be used
;; to prevent Tern from loading certain files. It also takes an array
;; of file names or glob patterns.

;; plugins 则指定 tern/plugin 目录些的相关配置
;;目前tern/plugin已有 angular.js          complete_strings.js component.js        doc_comment.js      node.js             requirejs.js
;; 试例中 baseURL paths 是传给requirejs的参数
;; 搜索顺序先project 目录下 ，后tern/plugin
;; The plugins field may hold object used to load and configure Tern
;; plugins. The names of the properties refer to files that implement
;; plugins, either in the project dir or under plugin/ in the Tern
;; directory. Their values are configuration objects that will be
;; passed to the plugins. You can leave them at {} when you don’t need
;; to pass any options.



(provide 'joseph-js)

;; Local Variables:
;; coding: utf-8
;; End:

;;; joseph-js.el ends here
