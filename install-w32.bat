:: -*- coding:gbk -*-
set emacs_dir=D:\usr\emacs
set HOME=d:\
cd bin\mew-6.4
mew.exe

rem 回到~/.emacs.d
cd ..\.. 
xcopy /r /e /h /y  dll\* %emacs_dir%\bin
pecho f |xcopy /r /e /h /-y   script\msys-bashrc %HOME%\.bashrc

cd bin
:: Everything-1.2.1.371.exe

ctags -f %emacs_dir%\lisp\TAGS -e -R %emacs_dir%\lisp

mkdir %HOME%\.ssh
:: ，  f 是文件还是目录 
:: echo f |xcopy /r/e/h /-y dotsshconfig %HOME%\.ssh\config
cd ..

del c:\WINDOWS\system32\find.exe
del c:\WINDOWS\system32\dllcache\find.exe
del c:\WINDOWS\system32\find.exe

script\emacs-w32.reg

::xcopy 会提示 目标是文件还是目录，echo f 自动回复f  
echo f |xcopy /y %emacs_dir%\bin\emacsclient.exe  %HOME%\.emacs.d\bin\ec.exe

cd bin\emacs-w3m\
emacs -batch -q -no-site-file -l w3mhack.el NONE -f w3mhack-nonunix-install
cd ../..

echo a |xcopy %emacs_dir%\..\site-lisp\w3m %emacs_dir%\site-lisp\w3m\
pause
