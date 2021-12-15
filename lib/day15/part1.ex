defmodule AoC2021.Day15.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/15

    You've almost reached the exit of the cave, but the walls are getting closer together. Your submarine can barely still fit, though; the main problem is that the walls of the cave are covered in chitons, and it would be best not to bump any of them.

    The cavern is large, but has a very low ceiling, restricting your motion to two dimensions. The shape of the cavern resembles a square; a quick scan of chiton density produces a map of risk level throughout the cave (your puzzle input).

    You start in the top left position, your destination is the bottom right position, and you cannot move diagonally. The number at each position is its risk level; to determine the total risk of an entire path, add up the risk levels of each position you enter (that is, don't count the risk level of your starting position unless you enter it; leaving it adds no risk to your total).

    What is the lowest total risk of any path from the top left to the bottom right?
  """
  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_map
    |> calculate_risk
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
