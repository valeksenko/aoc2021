defmodule AoC2021.Day09.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/9#part2

    Next, you need to find the largest basins so you know what areas are most important to avoid.

    A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

    The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

    Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.

    What do you get if you multiply together the sizes of the three largest basins?
  """
  @behaviour AoC2021.Day

  @peak 9

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_heightmap
    |> Enum.reduce([], &map_basin(&1, &2))
    |> Enum.map(&length/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  defp map_basin({_, @peak}, basins), do: basins

  defp map_basin({pos, _}, basins) do
    positions = neighbors(pos)

    {found, rest} =
      basins
      |> Enum.split_with(fn b -> Enum.any?(positions, &(&1 in b)) end)

    [[pos | List.flatten(found)] | rest]
  end

  defp neighbors({x, y}) do
    [{x, y + 1}, {x, y - 1}, {x + 1, y}, {x - 1, y}]
  end

  defp to_heightmap(data) do
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
