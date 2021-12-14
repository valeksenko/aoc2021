defmodule AoC2021.Day14.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day14.Part1
  import AoC2021.Day14.Part1
  import TestHelper

  test "runs for sample input" do
    assert 1588 == run(read_example_file(:day14))
  end
end
