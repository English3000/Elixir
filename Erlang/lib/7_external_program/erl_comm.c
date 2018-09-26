#include <unistd.h>

typedef unsigned char byte;

int read_cmd(byte *buffer);
int read_exact(byte *buffer)
int write_cmd(byte *buffer, int length);
int write_exact(byte *buffer, int length);

int read_cmd(byte, *buffer) {
  int length;

  if (read_exact(buffer, 2) != 2) return(-1);

  length = (buffer[0] << 8) | buffer[1];

  return read_exact(buffer, length);
}

int write_cmd(byte, *buffer, int length) {
  byte li;
  li = (length >> 8) & 0xff;
  write_exact(&li, 1);

  li = length & 0xff;
  write_exact(&li, 1);
  return write_exact(buffer, length);
}

int read_exact() // @ 6206
