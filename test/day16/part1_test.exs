defmodule AoC2021.Day16.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day16.Part1
  import AoC2021.Day16.Part1

  test "runs for sample input" do
    assert 16 == versions("8A004A801A8002F478")
    assert 12 == versions("620080001611562C8802118E34")
    assert 23 == versions("C0015000016115A2E0802F182340")
    assert 31 == versions("A0016C880162017C3686B18A3D4780")
  end
end
