#include <stdio.h>

typedef int si_int;
typedef unsigned su_int;
typedef long long di_int;
typedef unsigned long long du_int;
typedef int ti_int __attribute__((mode(TI)));
typedef unsigned tu_int __attribute__((mode(TI)));
typedef union {
  ti_int all;
  struct {
    di_int high;
    du_int low;
  } s;
} twords;
typedef union {
  tu_int all;
  struct {
    du_int high;
    du_int low;
  } s;
} utwords;

int main()
{
  utwords aa;
  utwords bb;
  aa.s.high = 0x00000000000000B5LL;
  aa.s.low = 0x04F333F9DE5BE000LL;
  bb.s.high = 0x0000000000000000LL;
  bb.s.low = 0x00B504F333F9DE5BLL;
  printf("0x%.16llx%.16llx | 0x%.16llx%.16llx \n", aa.s.high, aa.s.low, bb.s.high, bb.s.low);

  ti_int a = aa.all;
  ti_int b = bb.all;
  int overflow = 0;
  const int N = 128;
  const ti_int MIN = (ti_int)1 << (N - 1);
  const ti_int MAX = ~MIN;

  ti_int result = a * b;
  if (a == MIN) {
    printf("a min");
    if (b != 0 && b != 1)
      overflow = 1;
    return result;
  }
  if (b == MIN) {
    printf("b min");
    if (a != 0 && a != 1)
      overflow = 1;
    return result;
  }
  ti_int sa = a >> (N - 1);
  ti_int abs_a = (a ^ sa) - sa;
  ti_int sb = b >> (N - 1);
  ti_int abs_b = (b ^ sb) - sb;

  twords sat;
  sat.all = sa;
  twords sbt;
  sbt.all = sb;
  printf("0x%.16llx%.16llx | 0x%.16llx%.16llx \n", sat.s.high, sat.s.low, sbt.s.high, sbt.s.low);
  
  twords at;
  at.all = abs_a;
  twords bt;
  bt.all = abs_b;
  printf("0x%.16llx%.16llx | 0x%.16llx%.16llx \n", at.s.high, at.s.low, bt.s.high, bt.s.low);

  if (abs_a < 2 || abs_b < 2) {
    printf("abs min");
    return result;
  }
  if (sa == sb) {
    printf("X\n");
    if (abs_a > MAX / abs_b) {
      printf("yolo\n");
      overflow = 1;
    }
  } else {
    printf("Y");
    if (abs_a > MIN / -abs_b)
      overflow = 1;
  }
  return result;


  printf("%d \n", (int)(sizeof(ti_int) * 8));

  return 0;
}

// printf("%llx:%llx \n", e.s.high, e.s.low);
