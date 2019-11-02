{% skip_file unless flag?(:compile_rt) %}

require "spec"
require "../../../../src/crystal/compiler_rt/udivmodti4.cr"

# Ported from compiler-rt:test/builtins/Unit/udivmodti4_test.c

private def test__udivmodti4(a : (UInt128 | UInt128RT), b : (UInt128 | UInt128RT), expected : (UInt128 | UInt128RT), expected_overflow : (UInt128 | UInt128RT), file = __FILE__, line = __LINE__)
  it "passes compiler-rt builtins unit tests" do
    printf("A: %x B: %x \n", a.to_u128, b.to_u128)
    actual_overflow = 0_u128
    actual = __udivmodti4(a.to_u128, b.to_u128, pointerof(actual_overflow))
    actual_overflow.should eq(expected_overflow.to_u128), file, line
    if !expected_overflow.to_u128
      actual.should eq(expected.to_u128), file, line
    end
  end
end

private UDIVMODTI4_TESTS = StaticArray[
  1_u64, 0_u64, 0_u64, 4294967295_u64, 0_u64, 4294967297_u64, 0_u64, 1_u64,
]

describe "__udivmodti4" do
  UDIVMODTI4_TESTS.each_slice(8) do |test|
    test__udivmodti4(
      UInt128RT[test[1], test[0]],
      UInt128RT[test[3], test[2]],
      UInt128RT[test[5], test[4]],
      UInt128RT[test[7], test[6]]
    )
  end
end
