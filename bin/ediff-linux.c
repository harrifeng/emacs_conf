#include <stdio.h>
#include <stdlib.h>

/*
 ,* call-ediff is used to call ediff from Perforce.
 ,* gcc -o call-ediff call-ediff.c && call-ediff y:/Source/find_audio_xmls.sh y:/Source/find_audio_xmls.sh~
 ,*/

int main(int argc, char *argv[], char *envp[]) {
  if(argc<3){
    printf ("Usage: %s file1 file2\n",argv[0]);
    exit(-1);
  }
  char *param1 = argv[1];
  char *param2 = argv[2];

  char *command = (char *)malloc(4096);
  /* sprintf(command, "(progn (raise-frame) (ediff \"%s\" \"%s\"))", param1, param2); */
  sprintf(command, "(progn (raise-frame) (ediff \"%s\" \"%s\"))", param1, param2);
  argv[1] = "-eval";
  /* Sample usage: argv[2] = "(progn (message \"foo\") (raise-frame))"; */

  argv[2] = command;

  execvp("emacsclient", argv);
  perror("error");
  return 0;
}
