defmodule AoC2021.Day19.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day19.Part1
  import AoC2021.Day19.Part1
  import TestHelper

  test "runs for sample input" do
    assert 79 == run(read_example_file(:day19))
  end
end
