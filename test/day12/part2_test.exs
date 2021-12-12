defmodule AoC2021.Day12.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day12.Part2
  import AoC2021.Day12.Part2
  import TestHelper

  test "runs for sample input" do
    assert 103 == run(read_example(:day12))
    assert 3509 == run(read_example(:day12_1))
  end
end
