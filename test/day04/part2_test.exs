defmodule AoC2021.Day04.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day04.Part2
  import AoC2021.Day04.Part2
  import TestHelper

  test "runs for sample input" do
    assert 1924 == run(read_example_file(:day04))
  end
end
