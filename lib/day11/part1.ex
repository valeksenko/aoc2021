defmodule AoC2021.Day11.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/11

    You enter a large cavern full of rare bioluminescent dumbo octopuses! They seem to not like the Christmas lights on your submarine, so you turn them off for now.

    There are 100 octopuses arranged neatly in a 10 by 10 grid. Each octopus slowly gains energy over time and flashes brightly for a moment when its energy is full. Although your lights are off, maybe you could navigate through the cave without disturbing the octopuses if you could predict when the flashes of light will happen.

    Each octopus has an energy level - your submarine can remotely measure the energy level of each octopus (your puzzle input).

    The energy level of each octopus is a value between 0 and 9. Here, the top-left octopus has an energy level of 5, the bottom-right one has an energy level of 6, and so on.

    You can model the energy levels and flashes of light in steps. During a single step, the following occurs:

    First, the energy level of each octopus increases by 1.
    Then, any octopus with an energy level greater than 9 flashes. This increases the energy level of all adjacent octopuses by 1, including octopuses that are diagonally adjacent. If this causes an octopus to have an energy level greater than 9, it also flashes. This process continues as long as new octopuses keep having their energy level increased beyond 9. (An octopus can only flash at most once per step.)
    Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
    Adjacent flashes can cause an octopus to flash on a step even if it begins that step with very little energy. Consider the middle octopus with 1 energy in this situation:

    After 100 steps, there have been a total of 1656 flashes.

    Given the starting energy levels of the dumbo octopuses in your cavern, simulate 100 steps. How many total flashes are there after 100 steps?
  """
  @behaviour AoC2021.Day

  @steps 100

  @impl AoC2021.Day
  def run(data) do
    {0, to_map(data)}
    |> Stream.iterate(&step/1)
    |> Stream.drop(@steps)
    |> Enum.take(1)
    |> hd
    |> elem(0)
  end

  defp step({total, map}) do
    map
    |> Enum.map(fn {pos, level} -> {pos, level + 1} end)
    |> Enum.into(%{})
    |> flash_all
    |> Enum.reduce({total, %{}}, fn {pos, level}, {t, m} ->
      if level > 9, do: {t + 1, Map.put(m, pos, 0)}, else: {t, Map.put(m, pos, level)}
    end)
  end

  defp flash_all(map) do
    {[], map}
    |> flash
  end

  defp flash({flashed, map}) do
    fresh = fleshes(map) -- flashed

    if Enum.empty?(fresh),
      do: map,
      else: {fresh ++ flashed, fresh |> Enum.reduce(map, &shine/2)} |> flash
  end

  defp fleshes(map) do
    map
    |> Enum.filter(fn {_, level} -> level > 9 end)
    |> Enum.map(&elem(&1, 0))
  end

  defp shine(pos, map) do
    neighbors(pos)
    |> Enum.reduce(map, fn p, m -> increment(m, p, Map.get(map, p)) end)
  end

  defp increment(map, _, nil), do: map
  defp increment(map, pos, level), do: Map.put(map, pos, level + 1)

  defp neighbors({x, y}) do
    for xd <- -1..1, yd <- -1..1, do: {x + xd, y + yd}
  end

  defp to_map(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), &add_row/2)
  end

  defp add_row({row, y}, map) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {v, x}, m -> Map.put(m, {x, y}, String.to_integer(v)) end)
  end
end
