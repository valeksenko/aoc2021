defmodule AoC2021.Day05.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day05.Part1
  import AoC2021.Day05.Part1
  import TestHelper

  test "runs for sample input" do
    assert 5 == run(read_example(:day05))
  end
end
