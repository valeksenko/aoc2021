defmodule AoC2021.Day10.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day10.Part2
  import AoC2021.Day10.Part2
  import TestHelper

  test "runs for sample input" do
    assert 288_957 == run(read_example(:day10))
  end
end
