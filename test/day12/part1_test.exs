defmodule AoC2021.Day12.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day12.Part1
  import AoC2021.Day12.Part1
  import TestHelper

  test "runs for sample input" do
    assert 19 == run(read_example(:day12))
    assert 226 == run(read_example(:day12_1))
  end
end
