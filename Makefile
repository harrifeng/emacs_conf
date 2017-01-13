# -*- coding:gbk -*-
.PHONY: compile
ROOT_DIR=`pwd`
OS=`uname -s`

# LOAD_PATH ?= -L . -L $(CL_LIB_DIR) -L $(DASH_DIR)
EMACS ?= emacs
BATCH  = $(EMACS) -batch -Q $(LOAD_PATH)  -l site-lisp/submodules/joseph-file-util/joseph-file-util.el -l site-lisp/joseph/joseph-util.el  -l site-lisp/joseph/joseph-byte-compile.el  -l site-lisp/joseph/joseph_byte_compile_include.el

help:
	@echo "[Warning]:if you are not the author of git@github.com:jixiuf/emacs_conf.git"
	@echo "[Warning]:please modify variable MODULE_FILE_NAME in ./make.sh to ./site-lisp/submodules/modules_public"
	@echo please use make like this:
	@echo make linux
	@echo make mac
	@echo make pull
	@echo make update-autoloads
	@echo make compile
	@echo make push
	@echo make st[atus]
	@echo make clean
compile:
# @-cd site-lisp/submodules/helm &&make
# @-cd site-lisp/submodules/Emacs-wgrep &&make
# @-cd site-lisp/submodules/evil &&make
# @make _compile-magit
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/joseph-file-util" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/gold-ratio-scroll-screen" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/auto-java-complete/" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/helm-dired-history" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/helm-etags-plus" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/dired-filetype-face/" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/emacs-helm-gtags" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/erlang-dired-mode" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/submodules/sqlparser" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/csharp-mode" 0)'
	@$(BATCH) --eval '(byte-compile-file "site-lisp/xahk-mode.el" 0)'
	@$(BATCH) --eval '(byte-compile-file "site-lisp/visual-basic-mode.el" 0)'
	@$(BATCH) --eval '(byte-compile-file "site-lisp/compile-dwim.el" 0)'
	@$(BATCH) --eval '(byte-recompile-directory "site-lisp/joseph" 0)'

	@make update-autoloads

#@-make update-autoloads
# @-emacs --batch --no-site-file -l site-lisp/joseph/joseph-byte-compile.el --eval '(byte-compile-all-my-el-files-batch)'
# @-./make.sh configure
# @-./make.sh make
# _compile-magit:
# 	@-cd site-lisp/submodules/magit ; git checkout default.mk
# 	sed -i '' 's|\.\./dash|../dash.el|g'  site-lisp/submodules/magit/default.mk
# 	@-cd site-lisp/submodules/magit &&make
# 	@-cd site-lisp/submodules/magit && make
# 	@-cd site-lisp/submodules/magit && git checkout Makefile

update-autoloads:
	@-rm site-lisp/lisp/joseph-loaddefs.el
	@-emacs --batch --no-site-file -l site-lisp/joseph/joseph-autoload.el --eval '(update-directory-autoloads-recursively)'
linux:
	@echo 请手动运行以下命令 if you are not root	fi

	@-git pull
	@-./make.sh init
push:
	@-git pull
	@-git push
	@-./make.sh push
	@-cd $(ROOT_DIR)/site-lisp/submodules/dotemacs_priv && git pull &&git add mail/* && git commit -m "update mail" -a &&  git push

status:
	@./make.sh status

st:status

fetch:	init
	@-git pull
pull:init

clean:
	@find .  -name "*.elc" -exec rm {} \;

# emacs --batch --no-site-file -l site-lisp/joseph/joseph-byte-compile.el --eval '(byte-compile-file "/home/jixiuf/emacs_conf/site-lisp/joseph/joseph-org-publish.el")'
# emacs --batch --no-site-file -l /home/jixiuf/.emacs.d/site-lisp/joseph/joseph-byte-compile.el  -l /home/jixiuf/.emacs.d/site-lisp/joseph/joseph_byte_compile_include.el --eval '(byte-compile-file "/home/jixiuf/emacs_conf/site-lisp/submodules/helm-replace-string/helm-replace-string.el")'
