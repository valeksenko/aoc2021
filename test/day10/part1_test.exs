defmodule AoC2021.Day10.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day10.Part1
  import AoC2021.Day10.Part1
  import TestHelper

  test "runs for sample input" do
    assert 26397 == run(read_example(:day10))
  end
end
