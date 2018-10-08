#include <stdio.h>
#include <stdlib.h>

typedef unsigned char byte;

int read_cmd(byte *buffer);
int write_cmd(byte *buffer, int len);

int sum(int x, int y);
int twice(int x);

int main() {
  int fn, arg1, arg2, result;
  byte buffer[100];

  while (read_cmd(buffer) > 0) {
    fn = buffer[0];
    if (fn == 1) {
      arg1 = buffer[1];
      arg2 = buffer[2];
      /* fprintf(stderr, "calling sum %i %i\n", arg1, arg2); */
      result = sum(arg1, arg2)
    } else if (fn == 2) {
      arg1 = buffer[1];
      result = twice(arg1);
    } else {
      exit(EXIT_FAILURE);
    }
    buffer[0] = result;
    write_cmd(buffer, 1);
  }
}
