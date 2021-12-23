defmodule AoC2021.Day22.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day22.Part2
  import AoC2021.Day22.Part2
  import TestHelper

  test "runs for sample input" do
    assert 2_758_514_936_282_235 == run(read_example(:day22_1))
  end
end
