# Function returning quotient for signed division eg `a / b`
fun __divti3(a : Int128, b : Int128) : Int128
  bits_in_tword_m1 = sizeof(Int128) * sizeof(Char) - 1
  s_a = a >> bits_in_tword_m1
  s_b = b >> bits_in_tword_m1
  a = (a ^ s_a) - s_a
  b = (b ^ s_b) - s_b
  s_a ^= s_b
  return __udivmodti4(a, b, (0_i128 ^ s_a)) - s_a #TODO: does not work with fun
end
