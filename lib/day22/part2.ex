defmodule AoC2021.Day22.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/22#part2

    Now that the initialization procedure is complete, you can reboot the reactor.

    Starting again with all cubes off, execute all reboot steps. Afterward, considering all cubes, how many cubes are on?
  """
  import AoC2021.Day22.Parser

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    data
    |> parse_steps
    |> (fn [{coords, :on} | reminder] -> reminder |> Enum.reduce([coords], &run_step/2) end).()
    |> Enum.map(&cuboid_size/1)
    |> Enum.sum()
  end

  defp run_step({coords, :on}, active) do
    active
    |> Enum.map(&intersect(&1, coords))
    |> List.flatten()
  end

  defp run_step({coords, :off}, active) do
    active
    |> Enum.map(&intersect(coords, &1))
    |> List.flatten()
  end

  defp intersect(base, other) do
    cond do
      base |> excludes?(other) -> [other]
      base |> includes?(other) -> []
      true -> split(base, other)
    end
  end

  defp split({x_base, y_base, z_base}, {x_other, y_other, z_other}) do
    # TODO: implement
  end

  defp includes?({x_range1, y_range1, z_range1}, {x_range2, y_range2, z_range2}) do
    in_range?(x_range1, x_range2) and in_range?(y_range1, y_range2) and
      in_range?(z_range1, z_range2)
  end

  defp excludes?({x_range1, y_range1, z_range1}, {x_range2, y_range2, z_range2}) do
    Range.disjoint?(x_range1, x_range2) and Range.disjoint?(y_range1, y_range2) and
      Range.disjoint?(z_range1, z_range2)
  end

  defp in_range?(a1..a2, b1..b2), do: a1 <= b1 and a2 >= b2

  defp cuboid_size(coords) do
    coords
    |> Tuple.to_list()
    |> Enum.map(&Range.size/1)
    |> Enum.product()
  end
end
