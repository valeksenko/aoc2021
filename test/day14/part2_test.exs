defmodule AoC2021.Day14.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day14.Part2
  import AoC2021.Day14.Part2
  import TestHelper

  test "runs for sample input" do
    assert 2_188_189_693_529 == run(read_example_file(:day14))
  end
end
