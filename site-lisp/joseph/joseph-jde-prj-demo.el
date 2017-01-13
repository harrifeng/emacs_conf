 ;; -*-no-byte-compile: t;  coding:utf-8-*-
(jde-project-file-version "1.0")
(jde-set-variables)
;;添加classpath 的函数
(defun add_classpath  (classpath)
;;;;做容错处理，正常情况下my-classpath 是一个list类型,但是如果 用户将它设成普通的string ，则转为list
   (if (stringp classpath) (setq jde-global-classpath  (append jde-global-classpath (list classpath ))) )
   (if (listp classpath) (setq jde-global-classpath (append jde-global-classpath classpath)) )
)
;;添加源代码目录(可以是项目的源码目录，也可以是你引用的jar对应的源码，jde-open-class-source(查看对应类的源代码的方法(方法导航)) ， )
(defun add_src_path  (src_path)
;;;;做容错处理，正常情况下source   是一个list类型,但是如果 用户将它设成普通的string ，则转为list
   (if (stringp src_path) (setq jde-sourcepath  (append jde-sourcepath (list src_path ))) )
   (if (listp  src_path) (setq  jde-sourcepath  (append jde-sourcepath  src_path)) )
)

;; progname
;;   -
;;    | src
;;    | test
;;    | bin
;;    | lib

;;这几个变量是我自定义的，下文会引用到
(setq prog_root_dir "/tmp/mail") ;;项目根目录 ,不要用相对目录，易出错
(setq prog_src_dir  (concat prog_root_dir "/src/"))   ;src
(setq prog_test_dir (concat prog_root_dir "/test/")) ;;test
(setq prog_bin_dir  (concat prog_root_dir "/bin/"));;bin
(setq prog_lib_dir  (concat prog_root_dir "/lib/"));;libd
(setq prog_xrefdb_dir  (concat prog_root_dir "/xrefdb/"));;libd
;(setq JAVA_HOME nil ) ;;可以在这里设置JAVA_HOME的路径，也可不设

;;向jde-sourcepath 中添加路径
;;实际上你可以直接向jde-sourcepath中 手动添加 ，不过不了解elisp 的人可能会因格式不对，导致出错，故此提示此函数
(add_src_path  prog_src_dir) ;;将项目的src目录指定为源代码目录
(add_src_path  prog_test_dir);; 将项目的test目录指定为源代码目录
(add_src_path "/opt/sun-jdk-1.6.0.22/src")  ;;jdk源码，便于查看源代码，"Alt+."


;;关于classpath 的设置 向jde-global-classpath 中添加路径
(add_classpath  (getenv "CLASSPATH"));; 添加系统的classpath
(add_classpath prog_bin_dir);; 将项目bin 目录指定为classpath
(add_classpath prog_lib_dir);; 将项目的lib目录指定为classpath ,其中可以放任意数量的jar文件

;; (if (not JAVA_HOME) (setq JAVA_HOME (getenv "JAVA_HOME" )) )
;; (if (string-match  "/$" JAVA_HOME )
;;       (progn
;;        (add_classpath  (concat JAVA_HOME "lib/dt.jar" )  )
;;        (add_classpath  (concat JAVA_HOME "lib/tools.jar" )  )
;;        )
;;       (progn
;;        (add_classpath  (concat JAVA_HOME "/lib/dt.jar" )  )
;;        (add_classpath  (concat JAVA_HOME "/lib/tools.jar" )  )
;;        )
;; )


(jde-set-variables
;;下面这些选项才是jde提供的配置选项，我上面配置只是通过间接的方式配置下面这些变量
;'(jde-compile-option-directory   prog_bin_dir) ;;编译生成的class文件放在这个目录，就是项目的bin目录
'(jde-complete-function (quote jde-complete-menu))  ;;代码提示的方式 使用菜单在下面我把快捷键设成了Ctrl+return
'(jde-run-working-directory prog_bin_dir);;运行命令以此目录为基目录(,,才能正确指定哪些文件夹对应着java中的包名)
'(jde-help-docsets (quote (("JDK API" "/java/java/doc/j2ee6_api/index.html" nil))));;指定jdk帮助文档的位置,当然也可以加入其他的帮助文档
'(jde-jdk-doc-url "/java/java/doc/j2ee6_api/index.html") ;;jdk帮助文档的位置
;;'(jde-sourcepath (quote (".zip" "/opt/sun-jdk-1.6.0.22/src")));;这里注释掉了，如果前面你使用了我写的add_src_path()函数添加指定目录为源代码目录，就不要在这里打开这个注释(会覆盖掉)  。解释一下这个选项，：一是指你的源代码放在什么位置，需要告诉它，二你用到的一些jar包，如果你想要在jde中查看jar包中对应的类的话,也要添加到这里，

 '(jde-build-function (quote (jde-ant-build)));; 使用ant 构建项目，默认是make
 '(jde-ant-invocation-method (quote ("Script")));;调用ant 的方法使用ant_home/bin里提供的脚本，(也可以使用java 调用ant包中相应的类)
 '(jde-ant-home "/java/java/apache/apache-ant-1.8.0") ;;ant_home
 '(jde-ant-program "/java/java/apache/apache-ant-1.8.0/bin/ant") ;;用哪个脚本启动ant
 '(jde-ant-args "-emacs") ; compile output in emacs format ,这个不知有没有用，先放这
 '(jde-ant-complete-target t)
 '(jde-ant-enable-find t)  ;;如果当前目录没有build.xml会搜索子目录
 '(jde-ant-read-args nil) ;; ant脚本可能要传入一些参数，jde会要求用户输入，这里禁用之
 '(jde-ant-read-buildfile nil);; 不要求用户输入build文件具体的名字，使用默认的build.xml
 '(jde-ant-read-target nil);; 不要求用户输入调用哪个target ,即调用build.xml文件中默认的target
 '(jde-ant-use-global-classpath t);;使用jde的 global-classpath
 '(jde-ant-working-directory  (concat  prog_bin_dir "/") );;指定ant 的工作目录，指定为bin对应目录(注意目录必须以"/"结尾，Windows上以"\"结尾  ) ;;这里没进行详细判断pro_bin_dir是不是以"/"结尾，直接加在末尾加一个"/" ,linux上可以理解"/home//jixiuf//" 这样不太合法的目录


;;;关于cross reference ，应该是记录某个方法在哪些地方被调用
;;我们在一个方法上按"C-c C-v a"会运行jde-xref-first-caller命令，
;;然后就后跳到第一个调用此方法的地方（如果有的话）然后"C-c C-v n" jde-xref-next-caller，则一直next
;;而运行 jde-xref-display-call-tree 则会以树状展示调用关系
;; M-x jde-xref-list-uncalled-functions,则展示当前文件，哪些方法没被调用过
'(jde-built-class-path  '( prog_bin_dir)) ;;这个选项还不太明白，先这样放着;下面几句英文是jde提供的解释
;;Similar to `jde-global-classpath', except this path should only
;;have those places where compile files live.  This list of paths could
;;contain both directories and jar files.  Each of these should
;;correspond to the root of the build tree, in other words the
;;directories under it should correpond to packages.
 '(jde-xref-cache-size 3);;设定缓存大小，默认为3 ，越大越快越大越占内存
 '(jde-xref-db-base-directory prog_root_dir);;运行jde-xref-make-xref-db会生成一些索引文件，放在prog_root_dir/xrefdb目录下
 '(jde-xref-store-prefixes (quote ("mail")));;只索引这个包里的
;; M-x jde-xref-make-xref-db  使用此命令生成相应的文件
  (run-at-time "11:00pm" 86400 'jde-xref-make-xref-db);;从11:00pm开始每隔86400s更新一下索引目录./xrefdb/
;;另外一个办法就是每次调用compile后调用一下jde-xref-update命令，,现在还不清楚相应的hook是什么，所以暂时没实现

;;关于etag jtags   Tagging Java Source Code，这个应该就是eclipse调试时的代码跳转
;;比如光标在"abb".substring() ,然后点击"Alt+." 就会跳到String.substring()方法的定义处
;;前提是你将jdk的src.zip 解压后的目录加入到jde-sourcepath中，用我的add_src_path()可以做到，另外一点是
;;在源代码目录下运行jtags命令，(它是etags命令的一个包装，所以确保你装了etags )
;;使用方法，当然先那建索引库jdee提供了jtags命令用于扫描java源文件，方法在bash 中进入到项目根目录然后运行jtags命令，会在根目录下生成一个TAGS文件
;;所有你想跳转过去的源代码都要如此处理

)

;;;elisp 的一点语法
;;;   '("aaa" "bbb" "ccc" )  与(quote ("aaa" "bbb" "ccc"))同
;;;   将 "aaa" 变成 '(aaa)  使用 (list "aaa")     '("aaa" "bbb" ) 变成 '("aaa" "bbb" "ccc")的语法 (append  _listname  string    );;;    (setq var value)  与 '(var value) 同为设值


;;在编辑java 文件时 Ctrl+return 代码提示
(defun my-java-jde-mode-hook()
  (local-set-key (quote [C-return]) (quote jde-complete));;java jde 自动补全键C-return
    )
(add-hook 'java-mode-hook 'my-java-jde-mode-hook)
