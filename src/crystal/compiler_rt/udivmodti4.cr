require "./u128_info"

# Function return the remainder of the unsigned division with overflow eg. `a % b`

fun __udivmodti4(a : UInt128, b : UInt128, rem : UInt128*) : UInt128
  n_udword_bits = 64 # sizeof(Int64) &* sizeof(Char)
  n_utword_bits = 128 # sizeof(Int128) &* sizeof(Char)
  n = UInt128RT.new
  d = UInt128RT.new
  q = UInt128RT.new
  r = UInt128RT.new
  sr = 0_u32
  n.all = a
  d.all = b

  # printf("R: %x REM: %x\n\n", r.all, rem.value)
  puts "HERE"

  if n.info.high == 0
    puts "1"
    if d.info.high == 0
      puts "2"
      if rem
        rem.value = (n.info.low % d.info.low).to_u128
      end
      n.info.low = n.info.low // d.info.low
      return n.all
    end
    printf("R: %x REM: %x\n\n", r.all, rem.value)
    if rem
      printf("R: %x REM: %x\n\n", r.all, rem.value)
      rem.value = 123_u128
      # rem.value = n.info.low
    end
    return 0_u128
  end

  if d.info.low == 0
    puts "3"
    if d.info.high == 0
      puts "4"
      if rem
        n.info.high = n.info.high % d.info.low
        rem.value = n.all
      end
      n.info.high = n.info.high // d.info.low
      return n.all
    end

    if n.info.low == 0
      puts "5"
      if rem
        r.info.high = n.info.high % d.info.high
        r.info.low = 0
        rem.value = r.all
      end
      n.info.high = n.info.high // d.info.high
      return n.all
    end

    if (d.info.high & (d.info.high &- 1)) == 0 # if d is a power of 2
      puts "6"
      if rem
        r.info.low = n.info.low
        r.info.high = n.info.high & (d.info.high &- 1)
        rem.value = r.all
      end
      n.info.high = n.info.high >> d.info.high.trailing_zeros_count
      return n.all
    end

    sr = d.info.high.leading_zeros_count &- n.info.high.leading_zeros_count
    if sr > n_udword_bits &- 2
      puts "7"
      if rem
        rem.value = n.all
      end
      return 0_u128
    end
    puts "8"
    sr = sr &+ 1
    q.info.low = 0
    q.info.high = n.info.low << (n_udword_bits &- sr)
    r.info.high = n.info.high >> sr
    r.info.low = (n.info.high << (n_udword_bits &- sr)) | (n.info.low >> sr)
  else
    puts "9"
    if d.info.high == 0
      puts "10"
      if (d.info.low & (d.info.low &- 1)) == 0
        puts "11"
        if rem
          rem.value = (n.info.low & (d.info.low &- 1)).to_u128
        end
        return n.all if d.info.low == 1

        puts "12"
        sr = d.info.low.trailing_zeros_count
        q.info.high = n.info.high >> sr
        q.info.low = (n.info.high << (n_udword_bits &- sr)) | (n.info.low >> sr)
        return q.all
      end
      sr = 1_u32 &+ n_udword_bits &+ d.info.low.leading_zeros_count &- n.info.high.leading_zeros_count
      if sr == n_udword_bits
        puts "13"
        q.info.low = 0
        q.info.high = n.info.low
        r.info.high = 0
        r.info.low = n.info.high
      elsif sr < n_udword_bits
        puts "14"
        q.info.low = 0
        q.info.high = n.info.low << (n_udword_bits &- sr)
        r.info.high = n.info.high >> sr
        r.info.low = (n.info.high << (n_udword_bits &- sr)) | (n.info.low >> sr)
      else
        puts "14"
        q.info.low = n.info.low << (n_utword_bits &- sr)
        q.info.high = (n.info.high << (n_utword_bits &- sr)) | (n.info.low >> (sr &- n_udword_bits))
        r.info.high = 0
        r.info.low = n.info.high >> (sr &- n_udword_bits)
      end
    else
      puts "15"
      sr = d.info.high.leading_zeros_count &- n.info.high.leading_zeros_count
      if sr > n_udword_bits &- 1
        puts "16"
        if rem
          rem.value = n.all
        end
        return 0_u128
      end
      sr = sr &+ 1
      q.info.low = 0
      if sr == n_udword_bits
        puts "17"
        q.info.high = n.info.low
        r.info.high = 0
        r.info.low = n.info.high
      else
        puts "18"
        r.info.high = n.info.high >> sr
        r.info.low = (n.info.high << (n_udword_bits &- sr)) | (n.info.low >> sr)
        q.info.high = n.info.low << (n_udword_bits &- sr)
      end
    end
  end

  carry = 0_u64
  sr -= 1
  while sr > 0
    # puts "SR: #{sr} | Q: #{q} | R: #{r}"
    r.info.high = (r.info.high << 1_u64) | (r.info.low  >> (n_udword_bits &- 1_u64))
    r.info.low  = (r.info.low  << 1_u64) | (q.info.high >> (n_udword_bits &- 1_u64))
    q.info.high = (q.info.high << 1_u64) | (q.info.low  >> (n_udword_bits &- 1_u64))
    q.info.low  = (q.info.low  << 1_u64) | carry

    s = (d.all &- r.all &- 1_u128) >> (n_utword_bits &- 1_u128)
    carry = s & 1
    # puts "SR: #{sr} | Q: #{q} | R: #{r}"
    # r.all -= d.all & s;
    r.all = r.all &- d.all & s
    # puts "SR: #{sr} | Q: #{q} | R: #{r}"

    sr = sr &- 1
  end

  q = ((q.all << 1_u128) | carry).unsafe_as(UInt128RT)
  if rem
    rem.value = r.all
  end
  q.all
end
