defmodule AoC2021.Day15.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day15.Part1
  import AoC2021.Day15.Part1
  import TestHelper

  test "runs for sample input" do
    assert 40 == run(read_example(:day15))
  end
end
