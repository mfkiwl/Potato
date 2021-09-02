// Written by Elisa Silva, 2021-09-01
#include "root_patch.h"
#include "render_interface.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int fentry(int argc, char **argv);

struct CMD {
  char *name;
  fentry *ptr;
};

fentry poem;
fentry genws;

struct CMD commands[] = {
  {.name="poem",.ptr=poem},
  {.name="generatewebsite",.ptr=genws},
  {.name="",.ptr=NULL}
};

void log_possible_commands(void);

int main(int argc, char **argv) {
  root_patch();

  if(argc < 2) {
    fprintf(stderr, "%s\n", "too few arguments");
    log_possible_commands();
    exit(EXIT_FAILURE);
  }

  for(int i = 0; commands[i].ptr != NULL; i++)
    if(strcmp(argv[1], commands[i].name) == 0)
      return commands[i].ptr(argc, argv);

  fprintf(stderr, "%s\n", "command was not found");
  log_possible_commands();
  exit(EXIT_FAILURE);
}

int poem(int argc, char **argv) {
  puts("Roses are red,");
  puts("Violets are blue,");
  puts("Sugar is sweet,");
  puts("And so are you.");
  return 0;
}

int genws(int argc, char **argv) {
  renderPages();
  return 0;
}

void log_possible_commands(void) {
  puts("List of possible commands:");
  for(int i = 0; commands[i].ptr != NULL; i++)
    puts(commands[i].name);
}
