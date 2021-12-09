defmodule AoC2021.Day09.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day09.Part2
  import AoC2021.Day09.Part2
  import TestHelper

  test "runs for sample input" do
    assert 1134 == run(read_example(:day09))
  end
end
