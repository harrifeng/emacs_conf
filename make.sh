#!/bin/sh
# for 纪秀峰本人
MODULE_FILE_NAME=./site-lisp/submodules/modules
# for public 
# MODULE_FILE_NAME=./site-lisp/submodules/modules_public

WORD_DIR=`pwd`/site-lisp/submodules
# ./make init
# ./make push
# ./make status
# ./make make
case "$1" in  
    "init" )  
        # 过滤掉开头的#的注释行
        for url in  `cat $MODULE_FILE_NAME|grep -v "^[ \t]*#" ` ; do
            url=`echo $url|awk -F '.git:' '{print $1}'`
			echo $url
            mod=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $1}'`
            branch=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $2}'`
            abs_mod_path=$WORD_DIR/$mod
            if [ -d $abs_mod_path ] && [ -d $abs_mod_path/.git ] ; then
        # 如果库已经存在
                echo $abs_mod_path 
                cd $abs_mod_path
                git checkout $branch
                git pull
                if [ -f $abs_mod_path/.gitmodules ] ; then
                    git submodule init
                    git submodule update
                fi
            else
                cd $WORD_DIR
                echo git clone $url 
                git clone  $url --depth 1
                git checkout $branch
            fi
        done
        ;;  
    
    "push" )  
        # 过滤掉开头的#的注释行
        for url in  `cat $MODULE_FILE_NAME|grep -v "^[ \t]*#" ` ; do
            mod=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $1}'`
            branch=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $2}'`
            abs_mod_path=$WORD_DIR/$mod
            # url 中含jixiuf 是我有权限push的
            if [ -d $abs_mod_path ] && [ -d $abs_mod_path/.git  ] && [ `echo $url | grep -c "jixiuf"`  -gt 0 ] ; then
                # my private repos 
                echo git push $url 
                cd $abs_mod_path
                git checkout $branch
                git pull
                git push 
            fi
        done
        
        ;;  
    "status" )  
        # 过滤掉开头的#的注释行
        for url in  `cat $MODULE_FILE_NAME|grep -v "^[ \t]*#" ` ; do
            mod=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $1}'`
            branch=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $2}'`
            abs_mod_path=$WORD_DIR/$mod
            cd $abs_mod_path
            echo $url
            git status
            echo 
        done
        
        ;;  
    "make" )
        # 如果子模块下有Makefile
        # run make in sub mods
        # 过滤掉开头的#的注释行
        for url in  `cat $MODULE_FILE_NAME|grep -v "^[ \t]*#" ` ; do
            mod=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $1}'`
            branch=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $2}'`
            abs_mod_path=$WORD_DIR/$mod
            if [ -d $abs_mod_path ] && [ -d $abs_mod_path/.git ] ; then
                if [ -f $abs_mod_path/Makefile ]  ; then
                    cd $abs_mod_path
                    make
                fi
                if [ -f $abs_mod_path/bin/build ]; then
                    cd $abs_mod_path
                    sh ./bin/build
                fi
            fi
        done
        
        ;;  
    "configure" )
        # 如果子模块下有 ./configure
        # run ./configure
        # 过滤掉开头的#的注释行
        for url in  `cat $MODULE_FILE_NAME|grep -v "^[ \t]*#" ` ; do
            mod=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $1}'`
            branch=`echo $url|sed 's|.*/||g'|awk -F '.git:' '{print $2}'`
            abs_mod_path=$WORD_DIR/$mod
            if [ -d $abs_mod_path ] && [ -d $abs_mod_path/.git ] ; then
                if [ -f $abs_mod_path/configure.in ]  ; then
                    cd $abs_mod_path
                    echo $abs_mod_path
                    autoconf
                fi
                
                # 如果 ./configure存在
                if [ -f $abs_mod_path/configure ]  ; then
                    cd $abs_mod_path
                    echo $abs_mod_path
                    echo ./configure
                    sh ./configure
                fi
            fi
        done
        
        ;;  
    
esac 
