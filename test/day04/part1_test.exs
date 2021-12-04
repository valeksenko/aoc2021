defmodule AoC2021.Day04.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day04.Part1
  import AoC2021.Day04.Part1
  import TestHelper

  test "runs for sample input" do
    assert 4512 == run(read_example_file(:day04))
  end
end
