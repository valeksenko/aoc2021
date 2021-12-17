defmodule AoC2021.Day17.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day17.Part2
  import AoC2021.Day17.Part2
  import TestHelper

  test "runs for sample input" do
    assert 112 == run(read_example(:day17))
  end
end
