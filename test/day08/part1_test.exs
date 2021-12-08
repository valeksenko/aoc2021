defmodule AoC2021.Day08.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day08.Part1
  import AoC2021.Day08.Part1
  import TestHelper

  test "runs for sample input" do
    assert 26 == run(read_example(:day08))
  end
end
