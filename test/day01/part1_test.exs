defmodule AoC2021.Day01.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day01.Part1
  import AoC2021.Day01.Part1
  import TestHelper

  test "runs for sample input" do
    assert 7 == run(read_example(:day01))
  end
end
