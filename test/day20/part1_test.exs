defmodule AoC2021.Day20.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day20.Part1
  import AoC2021.Day20.Part1
  import TestHelper

  test "runs for sample input" do
    assert 35 == run(read_example(:day20))
  end
end
