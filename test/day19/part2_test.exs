defmodule AoC2021.Day19.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day19.Part2
  import AoC2021.Day19.Part2
  import TestHelper

  test "runs for sample input" do
    assert 3621 == run(read_example_file(:day19))
  end
end
