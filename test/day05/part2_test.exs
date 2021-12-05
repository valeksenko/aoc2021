defmodule AoC2021.Day05.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day05.Part2
  import AoC2021.Day05.Part2
  import TestHelper

  test "runs for sample input" do
    assert 12 == run(read_example(:day05))
  end
end
