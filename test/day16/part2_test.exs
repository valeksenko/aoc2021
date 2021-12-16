defmodule AoC2021.Day16.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day16.Part2
  import AoC2021.Day16.Part2

  test "runs for sample input" do
    assert 3 == calculate("C200B40A82")
    assert 54 == calculate("04005AC33890")
    assert 7 == calculate("880086C3E88112")
    assert 9 == calculate("CE00C43D881120")
    assert 1 == calculate("D8005AC2A8F0")
    assert 0 == calculate("F600BC2D8F")
    assert 0 == calculate("9C005AC2F8F0")
    assert 1 == calculate("9C0141080250320F1802104A08")
  end
end
