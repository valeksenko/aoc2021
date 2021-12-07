defmodule AoC2021.Day07.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/7

    A giant whale has decided your submarine is its next meal, and it's much faster than you are. There's nowhere to run!

    Suddenly, a swarm of crabs (each in its own tiny submarine - it's too deep for them otherwise) zooms in to rescue you! They seem to be preparing to blast a hole in the ocean floor; sensors indicate a massive underground cave system just beyond where they're aiming!

    The crab submarines all need to be aligned before they'll have enough power to blast a large enough hole for your submarine to get through. However, it doesn't look like they'll be aligned before the whale catches you! Maybe you can help?

    There's one major catch - crab submarines can only move horizontally.

    You quickly make a list of the horizontal position of each crab (your puzzle input). Crab submarines have limited fuel, so you need to find a way to make all of their horizontal positions match while requiring them to spend as little fuel as possible.

    For example, consider the following horizontal positions:

    16,1,2,0,4,2,7,1,2,14
    This means there's a crab with horizontal position 16, a crab with horizontal position 1, and so on.

    Each change of 1 step in horizontal position of a single crab costs 1 fuel. You could choose any horizontal position to align them all on, but the one that costs the least fuel is horizontal position 2:

    This costs a total of 37 fuel. This is the cheapest possible outcome; more expensive outcomes include aligning at position 1 (41 fuel), position 3 (39 fuel), or position 10 (71 fuel).

    Determine the horizontal position that the crabs can align to using the least fuel possible. How much fuel must they spend to align to that position?
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
    |> Enum.map(&abs(&1 - ind))
    |> Enum.sum()
  end
end
