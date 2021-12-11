defmodule AoC2021.Day11.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/11
    
    It seems like the individual flashes aren't bright enough to navigate. However, you might have a better option: the flashes seem to be synchronizing!

    In the example above, the first time all octopuses flash simultaneously is step 195.

    If you can calculate the exact moments when the octopuses will all flash simultaneously, you should be able to navigate through the cavern. What is the first step during which all octopuses flash?
  """
  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_map
    |> Stream.iterate(&step/1)
    |> Stream.with_index()
    |> Stream.drop_while(fn {m, _} -> Map.values(m) |> Enum.any?(&(&1 != 0)) end)
    |> Enum.take(1)
    |> hd
    |> elem(1)
  end

  defp step(map) do
    map
    |> Enum.map(fn {pos, level} -> {pos, level + 1} end)
    |> Enum.into(%{})
    |> flash_all
    |> Enum.reduce(%{}, fn {pos, level}, m ->
      Map.put(m, pos, if(level > 9, do: 0, else: level))
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
