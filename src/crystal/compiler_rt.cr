# Low Level Runtime Functions for LLVM.
# The function definitions and explinations can be found here.
# https://gcc.gnu.org/onlinedocs/gccint/Libgcc.html#Libgcc
{% skip_file unless flag?(:compiler_rt) %}

struct Int128Info
  property low : UInt64 = 0_u64, high : Int64 = 0_i64
  def initialize; end
end

# Integer Runtime Routines

# Arithmetic Routines
# These are used on platforms that don’t provide hardware support for arithmetic operations.

# Functions for arithmetically shifting bits left eg. `a << b`
# fun __ashlhi3(a : Int16, b : Int32) : Int16
# fun __ashlsi3(a : Int32, b : Int32) : Int32
# fun __ashldi3(a : Int64, b : Int32) : Int64
# fun __ashlti3(a : Int128, b : Int32) : Int128
#   raise "__ashlti3"
# end

# Functions for arithmetically shifting bits right eg. `a >> b`
# fun __ashrhi3(a : Int16, b : Int32) : Int16
# fun __ashrsi3(a : Int32, b : Int32) : Int32
# fun __ashrdi3(a : Int64, b : Int32) : Int64
# fun __ashrti3(a : Int128, b : Int32) : Int128
#   raise "__ashrti3"
# end

# Function for logically shifting left (signed shift)
# fun __lshrhi3(a : Int16, b : Int32) : Int16
# fun __lshrsi3(a : Int32, b : Int32) : Int32
# fun __lshrdi3(a : Int64, b : Int32) : Int64
# fun __lshrti3(a : Int128, b : Int32) : Int128
#   raise "__lshrti3"
# end

# Functions for returning the product eg. `a * b`
# fun __mulqi3(a : Int8, b : Int8) : Int8
# fun __mulhi3(a : Int16, b : Int16) : Int16
# fun __mulsi3(a : Int32, b : Int32) : Int32
# fun __muldi3(a : Int64, b : Int64) : Int64

def __umuldi3(a : UInt64, b : UInt64) : UInt128
  r = Int128Info.new
  bits_in_dword_2 = (sizeof(Int64) * 8) / 2
  lower_mask = ~0_u64 >> bits_in_dword_2
  r.low = (a & lower_mask) * (b & lower_mask)
  t = (r.low >> bits_in_dword_2).unsafe_as(UInt64)
  r.low &= lower_mask
  t += (a >> bits_in_dword_2) * (b & lower_mask)
  r.low += (t & lower_mask) << bits_in_dword_2
  r.high = t >> bits_in_dword_2
  t = r.low >> bits_in_dword_2
  r.low &= lower_mask
  t += (b >> bits_in_dword_2) * (a & lower_mask)
  r.low += (t & lower_mask) << bits_in_dword_2
  r.high += t >> bits_in_dword_2
  r.high += (a >> bits_in_dword_2) * (b >> bits_in_dword_2)
  r.unsafe_as(UInt128)
end

def __multi3(a : Int128, b : Int128) : Int128
  x = a.unsafe_as(Int128Info)
  y = b.unsafe_as(Int128Info)

  ## TODO: deal with signed integer
  r = umuldi3(x.low, y.low).unsafe_as(Int128Info)
  r.high += (x.high * y.low + x.low * y.high).unsafe_as(Int64)

  # p x, y, r.unsafe_as(Int128Info)
  r.unsafe_as(Int128)
end

# Functions for returning the product with overflow eg. `a * b`
# NOTE: This is not in the GCC spec
# fun __mulosi4(a : Int32, b : Int32, overflow : Int32*) : Int32
fun __mulodi4(a : Int64, b : Int64, overflow : Int32*) : Int64
  n = 64
  min = Int64::MIN
  max = Int64::MAX
  overflow.value = 0
  result = a &* b
  if a == min
    if b != 0 && b != 1
      overflow.value = 1
    end
    return result
  end
  if b == min
    if a != 0 && a != 1
      overflow.value = 1
    end
    return result
  end
  sa = a >> (n &- 1)
  abs_a = (a ^ sa) &- sa
  sb = b >> (n &- 1)
  abs_b = (b ^ sb) &- sb
  if abs_a < 2 || abs_b < 2
    return result
  end
  if sa == sb
    if abs_a > max // abs_b
      overflow.value = 1
    end
  else
    if abs_a > min // (0i64 &- abs_b)
      overflow.value = 1
    end
  end
  return result
end

fun __muloti4(a : Int128, b : Int128, overflow : Int32*) : Int128
  n = 64
  min = Int64::MIN
  max = Int64::MAX
  overflow.value = 0
  result = a &* b
  if a == min
    if b != 0 && b != 1
      overflow.value = 1
    end
    return result
  end
  if b == min
    if a != 0 && a != 1
      overflow.value = 1
    end
    return result
  end
  sa = a >> (n &- 1)
  abs_a = (a ^ sa) &- sa
  sb = b >> (n &- 1)
  abs_b = (b ^ sb) &- sb
  if abs_a < 2 || abs_b < 2
    return result
  end
  if sa == sb
    if abs_a > max // abs_b
      overflow.value = 1
    end
  else
    if abs_a > min // (0i64 &- abs_b)
      overflow.value = 1
    end
  end
  return result
end

# Function returning quotient for signed division eg `a / b`
# fun __divqi3(a : Int8, b : Int8) : Int8
# fun __divhi3(a : Int16, b : Int16) : Int16
# fun __divsi3(a : Int32, b : Int32) : Int32
# fun __divdi3(a : Int64, b : Int64) : Int64
fun __divti3(a : Int128, b : Int128) : Int128
  raise "__divti3"
end

# Function returning quotient for unsigned division eg. `a / b`
# fun __udivqi3(a : Int8, b : Int8) : Int8
# fun __udivhi3(a : Int16, b : Int16) : Int16
# fun __udivsi3(a : Int32, b : Int32) : Int32
# fun __udivdi3(a : Int64, b : Int64) : Int64
fun __udivti3(a : Int128, b : Int128) : Int128
  raise "__udivti3"
end

# Function return the remainder of the signed division eg. `a % b`
# fun __modqi3(a : Int8, b : Int8) : Int8
# fun __modhi3(a : Int16, b : Int16) : Int16
# fun __modsi3(a : Int32, b : Int32) : Int32
# fun __moddi3(a : Int64, b : Int64) : Int64
fun __modti3(a : Int128, b : Int128) : Int128
  raise "__modti3"
end

# Function return the remainder of the unsigned division eg. `a % b`
# fun __umodqi3(a : Int8, b : Int8) : Int8
# fun __umodhi3(a : Int16, b : Int16) : Int16
# fun __umodsi3(a : Int32, b : Int32) : Int32
# fun __umoddi3(a : Int64, b : Int64) : Int64
fun __umodti3(a : Int128, b : Int128) : Int128
  raise "__modti3"
end





# TODO
# __absvti2
# __addvti3
# __negti2
# __negvti2
# __subvti3

# __ashlti3
# __ashrti3
# __lshrti3

# __cmpti2
# __ucmpti2

# __clrsbti2
# __clzti2
# __ctzti2
# __ffsti2

# __divti3
# __modti3
# __multi3
# __mulvti3
# __udivti3
# __umodti3

# __parityti2
# __popcountti2
