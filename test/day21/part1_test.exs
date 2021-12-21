defmodule AoC2021.Day21.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day21.Part1
  import AoC2021.Day21.Part1
  import TestHelper

  test "runs for sample input" do
    assert 739_785 == run(read_example(:day21))
  end
end
