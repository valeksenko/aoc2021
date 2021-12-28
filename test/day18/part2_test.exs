defmodule AoC2021.Day18.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day18.Part2
  import AoC2021.Day18.Part2
  import TestHelper

  test "runs for sample input" do
    assert 3993 == run(read_example(:day18))
  end
end
