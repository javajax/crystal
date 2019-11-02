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


tu_int __udivmodti4(tu_int a, tu_int b, tu_int *rem) {
  const unsigned n_udword_bits = sizeof(du_int) * 8;
  const unsigned n_utword_bits = sizeof(tu_int) * 8;
  utwords n;
  n.all = a;
  utwords d;
  d.all = b;
  utwords q;
  utwords r;
  unsigned sr;
  // special cases, X is unknown, K != 0
  if (n.s.high == 0) {
    printf("1\n");
    if (d.s.high == 0) {
      printf("2\n");
      // 0 X
      // ---
      // 0 X
      if (rem) {
        *rem = n.s.low % d.s.low;
      }
      printf("XXXX\n");
      return n.s.low / d.s.low;
    }
    printf("3\n");
    // 0 X
    // ---
    // K X
    if (rem) {
      printf("QQQQ\n");
      *rem = n.s.low;
    }
    printf("EEEE\n");
    return 0;
  }
  // n.s.high != 0
  if (d.s.low == 0) {
    printf("4\n");
    if (d.s.high == 0) {
      printf("5\n");
      // K X
      // ---
      // 0 0
      if (rem)
        *rem = n.s.high % d.s.low;
      return n.s.high / d.s.low;
    }
    // d.s.high != 0
    if (n.s.low == 0) {
      printf("6\n");
      // K 0
      // ---
      // K 0
      if (rem) {
        r.s.high = n.s.high % d.s.high;
        r.s.low = 0;
        *rem = r.all;
      }
      return n.s.high / d.s.high;
    }
    // K K
    // ---
    // K 0
    if ((d.s.high & (d.s.high - 1)) == 0) /* if d is a power of 2 */ {
      printf("7\n");
      if (rem) {
        printf("8\n");
        r.s.low = n.s.low;
        r.s.high = n.s.high & (d.s.high - 1);
        *rem = r.all;
      }
      return n.s.high >> __builtin_ctzll(d.s.high);
    }
    // K K
    // ---
    // K 0
    sr = __builtin_clzll(d.s.high) - __builtin_clzll(n.s.high);
    // 0 <= sr <= n_udword_bits - 2 or sr large
    if (sr > n_udword_bits - 2) {
      printf("9\n");
      if (rem)
        *rem = n.all;
      return 0;
    }
    ++sr;
    // 1 <= sr <= n_udword_bits - 1
    // q.all = n.all << (n_utword_bits - sr);
    q.s.low = 0;
    q.s.high = n.s.low << (n_udword_bits - sr);
    // r.all = n.all >> sr;
    r.s.high = n.s.high >> sr;
    r.s.low = (n.s.high << (n_udword_bits - sr)) | (n.s.low >> sr);
  } else /* d.s.low != 0 */ {
    printf("10\n");
    if (d.s.high == 0) {
      printf("11\n");
      // K X
      // ---
      // 0 K
      if ((d.s.low & (d.s.low - 1)) == 0) /* if d is a power of 2 */ {
        printf("12\n");
        if (rem)
          *rem = n.s.low & (d.s.low - 1);
        if (d.s.low == 1)
          return n.all;
        sr = __builtin_ctzll(d.s.low);
        q.s.high = n.s.high >> sr;
        q.s.low = (n.s.high << (n_udword_bits - sr)) | (n.s.low >> sr);
        return q.all;
      }
      // K X
      // ---
      // 0 K
      sr = 1 + n_udword_bits + __builtin_clzll(d.s.low) -
           __builtin_clzll(n.s.high);
      // 2 <= sr <= n_utword_bits - 1
      // q.all = n.all << (n_utword_bits - sr);
      // r.all = n.all >> sr;
      if (sr == n_udword_bits) {
        printf("13\n");
        q.s.low = 0;
        q.s.high = n.s.low;
        r.s.high = 0;
        r.s.low = n.s.high;
      } else if (sr < n_udword_bits) /* 2 <= sr <= n_udword_bits - 1 */ {
        printf("14\n");
        q.s.low = 0;
        q.s.high = n.s.low << (n_udword_bits - sr);
        r.s.high = n.s.high >> sr;
        r.s.low = (n.s.high << (n_udword_bits - sr)) | (n.s.low >> sr);
      } else /* n_udword_bits + 1 <= sr <= n_utword_bits - 1 */ {
        printf("15\n");
        q.s.low = n.s.low << (n_utword_bits - sr);
        q.s.high = (n.s.high << (n_utword_bits - sr)) |
                   (n.s.low >> (sr - n_udword_bits));
        r.s.high = 0;
        r.s.low = n.s.high >> (sr - n_udword_bits);
      }
    } else {
      printf("16\n");
      // K X
      // ---
      // K K
      sr = __builtin_clzll(d.s.high) - __builtin_clzll(n.s.high);
      // 0 <= sr <= n_udword_bits - 1 or sr large
      if (sr > n_udword_bits - 1) {
        printf("17\n");
        if (rem)
          *rem = n.all;
        return 0;
      }
      ++sr;
      // 1 <= sr <= n_udword_bits
      // q.all = n.all << (n_utword_bits - sr);
      // r.all = n.all >> sr;
      q.s.low = 0;
      if (sr == n_udword_bits) {
        printf("18\n");
        q.s.high = n.s.low;
        r.s.high = 0;
        r.s.low = n.s.high;
      } else {
        printf("19\n");
        r.s.high = n.s.high >> sr;
        r.s.low = (n.s.high << (n_udword_bits - sr)) | (n.s.low >> sr);
        q.s.high = n.s.low << (n_udword_bits - sr);
      }
    }
  }
  // Not a special case
  // q and r are initialized with:
  // q.all = n.all << (n_utword_bits - sr);
  // r.all = n.all >> sr;
  // 1 <= sr <= n_utword_bits - 1
  su_int carry = 0;
  for (; sr > 0; --sr) {
    // r:q = ((r:q)  << 1) | carry
    r.s.high = (r.s.high << 1) | (r.s.low >> (n_udword_bits - 1));
    r.s.low = (r.s.low << 1) | (q.s.high >> (n_udword_bits - 1));
    q.s.high = (q.s.high << 1) | (q.s.low >> (n_udword_bits - 1));
    q.s.low = (q.s.low << 1) | carry;
    // carry = 0;
    // if (r.all >= d.all)
    // {
    //     r.all -= d.all;
    //      carry = 1;
    // }
    const ti_int s = (ti_int)(d.all - r.all - 1) >> (n_utword_bits - 1);
    carry = s & 1;
    printf("R: 0x%.16llx%.16llx \n", r.s.high, r.s.low);
    r.all -= d.all & s;
    printf("R: 0x%.16llx%.16llx \n", r.s.high, r.s.low);
  }
  q.all = (q.all << 1) | carry;
  if (rem)
    *rem = r.all;
  return q.all;
}


int main()
{
  // const unsigned n_udword_bits = sizeof(du_int) * 8;
  // const unsigned n_utword_bits = sizeof(tu_int) * 8;

  // printf("%u\n", n_udword_bits);
  // printf("%u\n", n_utword_bits);

  // utwords aa;
  // aa.s.high = 0x00000000000000B5LL;
  // aa.s.low = 0x04F333F9DE5BE000LL;
  // printf("0x%.16llx%.16llx \n", aa.s.high, aa.s.low);




  tu_int a = (tu_int)0x0000000000000001uLL << 64 | 0x0000000000000000uLL;
  tu_int b = (tu_int)0x0000000000000000uLL << 64 | 0x00000000FFFFFFFFuLL;
  tu_int rem;

  twords aa;
  twords bb;
  aa.all = a;
  bb.all = b;

  printf("A: 0x%.16llx%.16llx B: 0x%.16llx%.16llx \n", aa.s.high, aa.s.low, bb.s.high, bb.s.low);
  printf("A: %llu / %llu B: %llu / %llu \n", aa.s.high, aa.s.low, bb.s.high, bb.s.low);

  tu_int num = __udivmodti4(a, b, &rem);

  twords n;
  twords r;
  n.all = num;
  r.all = rem;

  printf("Q: 0x%.16llx%.16llx R: 0x%.16llx%.16llx \n", n.s.high, n.s.low, r.s.high, r.s.low);
  printf("Q: %llu / %llu R: %llu / %llu \n", n.s.high, n.s.low, r.s.high, r.s.low);

  return 0;
}
