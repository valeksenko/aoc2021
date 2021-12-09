defmodule AoC2021.Day09.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day09.Part1
  import AoC2021.Day09.Part1
  import TestHelper

  test "runs for sample input" do
    assert 15 == run(read_example(:day09))
  end
end
