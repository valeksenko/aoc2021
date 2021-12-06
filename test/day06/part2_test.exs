defmodule AoC2021.Day06.Part2Test do
  use ExUnit.Case
  doctest AoC2021.Day06.Part2
  import AoC2021.Day06.Part2
  import TestHelper

  test "runs for sample input" do
    assert 26_984_457_539 == run(read_example(:day06))
  end
end
