//file name : eflymake.c
//created at: 2011-12-2 16:10:37
//author:  纪秀峰

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>

/*
  you need add D:\usr\erl5.8.5\bin to %Path%
  flymake for erlang
  with eflymake.erl
  accept 2 params
  argv[1] is the full path of eflymake.erl 是eflymake.erl 文件的绝对路径
  argv[2] is the erlang source file you want to check
  for example:
  eflymake /home/jixiuf/.emacs.d/bin/eflymake.erl /tmp/tmp.erl
 */
int main(int argc, char *argv[]){
  char cmd[1024] ;
  if (argc<2){
    printf("need a arg as erlang src file name.");
    return 1;
  }
  /* sprintf(cmd,"escript.exe %s %s" ,argv[1],argv[2]); /\* on windows *\/ */
  sprintf(cmd,"escript %s %s" ,argv[1],argv[2]); /* on linux */
  system(cmd);
  return 0;
}
