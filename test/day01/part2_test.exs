defmodule AoC2021.Day01.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day01.Part2
  import AoC2021.Day01.Part2
  import TestHelper

  test "runs for sample input" do
    assert 5 == run(read_example(:day01))
  end
end
