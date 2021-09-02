// Written by Elisa Silva, 2021-09-01
#include "root_patch.h"

#include <stdio.h>
#include <unistd.h>

#define MAXSIZE 512

void root_patch(void) {
  if(access("root", R_OK) != 0) goto leave;
  
  FILE *root = fopen("root", "r");
  if(root == NULL) goto leave;

  if(fseek(root, 0, SEEK_END) != 0) goto close;
  long size = ftell(root);

  if(size < 1 || size >= MAXSIZE) goto close;
  if(fseek(root, 0, SEEK_SET) != 0) goto close;

  char path[MAXSIZE];
  size_t read = fread(path, sizeof(char), size, root);
  if(read != size) goto close;
  path[read] = '\0';

  if(chdir(path) != 0)
    fprintf(stderr, "root_patch: tried to cd into %s but failed\n", path);
  else
    fprintf(stderr, "root_patch: cd into %s\n", path);

close:
  fclose(root);

leave:
  return;
}
