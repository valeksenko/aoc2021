defmodule AoC2021.Day15.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/15#part2

    Now that you know how to find low-risk paths in the cave, you can try to find your way out.

    The entire cave is actually five times larger in both dimensions than you thought; the area you originally scanned is just one tile in a 5x5 tile area that forms the full map. Your original map tile repeats to the right and downward; each time the tile repeats to the right or downward, all of its risk levels are 1 higher than the tile immediately up or left of it. However, risk levels above 9 wrap back around to 1.

    Using the full map, what is the lowest total risk of any path from the top left to the bottom right?
  """
  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_map
    |> expand
    |> calculate_risk
  end

  defp expand(map) do
    max = map |> Map.keys() |> Enum.max()

    map
    |> Enum.reduce(%{}, &add_positions(&2, &1, max))
  end

  defp add_positions(map, {{x, y}, risk}, {max_x, max_y}) do
    for(xd <- 0..4, yd <- 0..4, do: {xd, yd})
    |> Enum.reduce(map, fn {xd, yd}, m ->
      Map.put(m, {x + xd * (max_x + 1), y + yd * (max_y + 1)}, updated_risk(risk + xd + yd))
    end)
  end

  defp updated_risk(risk) do
    if risk > 9, do: rem(risk, 10) + 1, else: risk
  end

  defp calculate_risk(map) do
    nbs = fn pos -> neighbors(pos) |> Enum.reject(&(map |> Map.get(&1) |> is_nil)) end
    nb_risk = fn _, pos -> Map.get(map, pos) end
    # we can't estimate, so using it as a Dijkstra's
    estimated_risk = fn _, _ -> 1 end

    Astar.astar({nbs, nb_risk, estimated_risk}, {0, 0}, map |> Map.keys() |> Enum.max())
    |> Enum.map(&Map.get(map, &1))
    |> Enum.sum()
  end

  defp neighbors({x, y}) do
    [
      {x, y + 1},
      {x, y - 1},
      {x + 1, y},
      {x - 1, y}
    ]
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
