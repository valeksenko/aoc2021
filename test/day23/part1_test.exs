defmodule AoC2021.Day23.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day23.Part1
  import AoC2021.Day23.Part1
  import TestHelper

  test "runs for sample input" do
    assert 12521 == run(read_example_file(:day23))
  end
end
