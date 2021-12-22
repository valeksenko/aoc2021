defmodule AoC2021.Day22.Part1Test do
  use ExUnit.Case
  doctest AoC2021.Day22.Part1
  import AoC2021.Day22.Part1
  import TestHelper

  test "runs for sample input" do
    assert 590_784 == run(read_example(:day22))
  end
end
