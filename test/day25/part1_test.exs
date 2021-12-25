defmodule AoC2021.Day25.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day25.Part1
  import AoC2021.Day25.Part1
  import TestHelper

  test "runs for sample input" do
    assert 58 == run(read_example(:day25))
  end
end
