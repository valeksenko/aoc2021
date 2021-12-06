defmodule AoC2021.Day06.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/6#part2
    
    Suppose the lanternfish live forever and have unlimited food and space. Would they take over the entire ocean?

    After 256 days in the example above, there would be a total of 26984457539 lanternfish!

    How many lanternfish would there be after 256 days?
  """
  @behaviour AoC2021.Day

  @days 256

  @impl AoC2021.Day
  def run([data]) do
    data
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> Stream.iterate(&lifecycle/1)
    |> Stream.drop(@days)
    |> Enum.take(1)
    |> hd
    |> Map.values()
    |> Enum.sum()
  end

  defp lifecycle(counts) do
    1..8
    |> Enum.reduce(Map.new(), fn i, n -> Map.put(n, i - 1, Map.get(counts, i, 0)) end)
    |> Map.put(8, Map.get(counts, 0, 0))
    |> Map.get_and_update(6, fn c -> {c, c + Map.get(counts, 0, 0)} end)
    |> elem(1)
  end
end
