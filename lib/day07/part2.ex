defmodule AoC2021.Day07.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/7#part2

    The crabs don't seem interested in your proposed solution. Perhaps you misunderstand crab engineering?

    As it turns out, crab submarine engines don't burn fuel at a constant rate. Instead, each change of 1 step in horizontal position costs 1 more unit of fuel than the last: the first step costs 1, the second step costs 2, the third step costs 3, and so on.

    As each crab moves, moving further becomes more expensive. This changes the best horizontal position to align them all on; in the example above, this becomes 5:

    This is the new cheapest possible outcome; the old alignment position (2) now costs 206 fuel instead.

    Determine the horizontal position that the crabs can align to using the least fuel possible so they can make you an escape route! How much fuel must they spend to align to that position?
  """
  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run([data]) do
    data
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> align()
  end

  defp align(positions) do
    {min, max} = Enum.min_max(positions)

    min..max
    |> Enum.map(&fuel(positions, &1))
    |> Enum.min()
  end

  defp fuel(positions, ind) do
    positions
    |> Enum.map(&(1..abs(&1 - ind) |> Enum.sum()))
    |> Enum.sum()
  end
end
