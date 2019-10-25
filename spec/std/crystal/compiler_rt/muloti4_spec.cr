require "spec"
require "../../../../src/crystal/compiler_rt/muloti4"
require "../../../../src/crystal/compiler_rt/i128_info"

# Ported from compiler-rt:test/builtins/Unit/muloti4_test.c

private def test__muloti4(a : (Int128 | Int128RT), b : (Int128 | Int128RT), expected : (Int128 | Int128RT), expected_overflow : Int32, file = __FILE__, line = __LINE__)
  it "passes compiler-rt builtins unit tests" do
    actual_overflow : Int32 = 0
    actual = __muloti4(a.to_i128, b.to_i128, pointerof(actual_overflow))
    actual_overflow.should eq(expected_overflow), file, line
    if !expected_overflow
      actual.should eq(expected.to_i128), file, line
    end
  end
end

describe "__muloti4" do
  test__muloti4(0_i128, 0_i128, 0_i128, 0)
  test__muloti4(0_i128, 1_i128, 0_i128, 0)
  test__muloti4(1_i128, 0_i128, 0_i128, 0)
  test__muloti4(0_i128, 10_i128, 0_i128, 0)
  test__muloti4(10_i128, 0_i128, 0_i128, 0)
  test__muloti4(0_i128, 81985529216486895_i128, 0_i128, 0)
  test__muloti4(81985529216486895_i128, 0_i128, 0_i128, 0)
  test__muloti4(0_i128, Int128RT[1_i128].negate!, 0_i128, 0)
  test__muloti4(Int128RT[1_i128].negate!, 0_i128, 0_i128, 0)
  test__muloti4(0_i128, Int128RT[10].negate!, 0_i128, 0)
  test__muloti4(Int128RT[10].negate!, 0_i128, 0_i128, 0)
  test__muloti4(0_i128, Int128RT[81985529216486895_i128].negate!, 0_i128, 0)
  test__muloti4(Int128RT[81985529216486895_i128].negate!, 0_i128, 0_i128, 0)
  test__muloti4(1_i128, 1_i128, 1_i128, 0)
  test__muloti4(1_i128, 10_i128, 10_i128, 0)
  test__muloti4(10_i128, 1_i128, 10_i128, 0)
  test__muloti4(1_i128, 81985529216486895_i128, 81985529216486895_i128, 0)
  test__muloti4(81985529216486895_i128, 1_i128, 81985529216486895_i128, 0)
  test__muloti4(1_i128, Int128RT[1_i128].negate!, Int128RT[1_i128].negate!, 0)
  test__muloti4(1_i128, Int128RT[10].negate!, Int128RT[10].negate!, 0)
  test__muloti4(Int128RT[10].negate!, 1_i128, Int128RT[10].negate!, 0)
  test__muloti4(1_i128, Int128RT[81985529216486895_i128].negate!, Int128RT[81985529216486895_i128].negate!, 0)
  test__muloti4(Int128RT[81985529216486895_i128].negate!, 1_i128, Int128RT[81985529216486895_i128].negate!, 0)
  test__muloti4(3037000499_i128, 3037000499_i128, 9223372030926249001_i128, 0)
  test__muloti4(Int128RT[3037000499_i128].negate!, 3037000499_i128, Int128RT[9223372030926249001_i128].negate!, 0)
  test__muloti4(3037000499_i128, Int128RT[3037000499_i128].negate!, Int128RT[9223372030926249001_i128].negate!, 0)
  test__muloti4(Int128RT[3037000499_i128].negate!, Int128RT[3037000499_i128].negate!, 9223372030926249001_i128, 0)
  test__muloti4(4398046511103_i128, 2097152_i128, 9223372036852678656_i128, 0)
  test__muloti4(Int128RT[4398046511103_i128].negate!, 2097152_i128, Int128RT[9223372036852678656_i128].negate!, 0)
  test__muloti4(4398046511103_i128, Int128RT[2097152_i128].negate!, Int128RT[9223372036852678656_i128].negate!, 0)
  test__muloti4(Int128RT[4398046511103_i128].negate!, Int128RT[2097152_i128].negate!, 9223372036852678656_i128, 0)
  test__muloti4(2097152_i128, 4398046511103_i128, 9223372036852678656_i128, 0)
  test__muloti4(Int128RT[2097152_i128].negate!, 4398046511103_i128, Int128RT[9223372036852678656_i128].negate!, 0)
  test__muloti4(2097152_i128, Int128RT[4398046511103_i128].negate!, Int128RT[9223372036852678656_i128].negate!, 0)
  test__muloti4(Int128RT[2097152_i128].negate!, Int128RT[4398046511103_i128].negate!, 9223372036852678656_i128, 0)
  # test__muloti4(Int128RT[0x00000000000000B5, 0x04F333F9DE5BE000], Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], Int128RT[2_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000001], 1), Int128RT[0x7FFFFFFFFFFFF328, 0xDF915DA296E8A000], 0) ## NOTE: does not seem to work in c
  test__muloti4(Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], Int128RT[2_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000001], 1)
  # test__muloti4(Int128RT[2_i128].negate!, Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], Int128RT[0x8000000000000000, 0x0000000000000001], 1)
  test__muloti4(Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], Int128RT[1_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000001], 0)
  test__muloti4(Int128RT[1_i128].negate!, Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], Int128RT[0x8000000000000000, 0x0000000000000001], 0)
  test__muloti4(Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], 0_i128, 0_i128, 0)
  test__muloti4(0_i128, Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], 0_i128, 0)
  test__muloti4(Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], 1_i128, Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], 0)
  test__muloti4(1_i128, Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], 0)
  test__muloti4(Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], 2_i128, Int128RT[0x8000000000000000, 0x0000000000000001], 1)
  # test__muloti4(2_i128, Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], Int128RT[0x8000000000000000, 0x0000000000000001], 1)
  # test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000000], Int128RT[2_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000000], 1)
  # test__muloti4(Int128RT[2_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000000], Int128RT[0x8000000000000000, 0x0000000000000000], 1)
  # test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000000], Int128RT[1_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000000], 1)
  # test__muloti4(Int128RT[1_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000000], Int128RT[0x8000000000000000, 0x0000000000000000], 1)
  test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000000], 0_i128, 0_i128, 0)
  test__muloti4(0_i128, Int128RT[0x8000000000000000, 0x0000000000000000], 0_i128, 0)
  test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000000], 1_i128, Int128RT[0x8000000000000000, 0x0000000000000000], 0)
  test__muloti4(1_i128, Int128RT[0x8000000000000000, 0x0000000000000000], Int128RT[0x8000000000000000, 0x0000000000000000], 0)
#  test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000000], 2_i128, Int128RT[0x8000000000000000, 0x0000000000000000], 1)
#  test__muloti4(2_i128, Int128RT[0x8000000000000000, 0x0000000000000000], Int128RT[0x8000000000000000, 0x0000000000000000], 1)
  # test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000001], Int128RT[2_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000001], 1)
  # test__muloti4(Int128RT[2_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000001], Int128RT[0x8000000000000000, 0x0000000000000001], 1)
  test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000001], Int128RT[1_i128].negate!, Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], 0)
  test__muloti4(Int128RT[1_i128].negate!, Int128RT[0x8000000000000000, 0x0000000000000001], Int128RT[0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF], 0)
  test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000001], 0_i128, 0_i128, 0)
  test__muloti4(0_i128, Int128RT[0x8000000000000000, 0x0000000000000001], 0_i128, 0)
  test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000001], 1_i128, Int128RT[0x8000000000000000, 0x0000000000000001], 0)
  test__muloti4(1_i128, Int128RT[0x8000000000000000, 0x0000000000000001], Int128RT[0x8000000000000000, 0x0000000000000001], 0)
#  test__muloti4(Int128RT[0x8000000000000000, 0x0000000000000001], 2_i128, Int128RT[0x8000000000000000, 0x0000000000000000], 1)
#  test__muloti4(2_i128, Int128RT[0x8000000000000000, 0x0000000000000001], Int128RT[0x8000000000000000, 0x0000000000000000], 1)
end
