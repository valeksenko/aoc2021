defmodule AoC2021.Day11.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day11.Part2
  import AoC2021.Day11.Part2
  import TestHelper

  test "runs for sample input" do
    assert 195 == run(read_example(:day11))
  end
end
