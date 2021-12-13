defmodule AoC2021.Day13.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day13.Part1
  import AoC2021.Day13.Part1
  import TestHelper

  test "runs for sample input" do
    assert 17 == run(read_example_file(:day13))
  end
end
