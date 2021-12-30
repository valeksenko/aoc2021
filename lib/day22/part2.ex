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
    |> (fn [{base, :on} | reminder] -> reminder |> Enum.reduce([base], &run_step/2) end).()
    |> Enum.map(&cuboid_size/1)
    |> Enum.sum()
  end

  defp run_step({other, :on}, active), do: [other | intersect(other, active)]
  defp run_step({other, :off}, active), do: intersect(other, active)

  defp intersect(base, others) do
    others
    |> Enum.flat_map(&intersect_pair(base, &1))
  end

  defp intersect_pair(base, other) do
    cond do
      excludes?(base, other) -> [other]
      includes?(base, other) -> []
      true -> split(base, other)
    end
  end

  # based on @kpumuk solution for cuboid substracting
  defp split(base, other = {x_other, y_other, z_other}) do
    {x_inter, y_inter, z_inter} = intersection(base, other)

    extract(x_inter, x_other, 0, {y_other, z_other}) ++
      extract(y_inter, y_other, 1, {x_inter, z_other}) ++
      extract(z_inter, z_other, 2, {x_inter, y_inter})
  end

  defp extract(inter_begin..inter_end, base_begin..base_end, pos, dest) do
    if(inter_begin > base_begin,
      do: [Tuple.insert_at(dest, pos, base_begin..(inter_begin - 1))],
      else: []
    ) ++
      if inter_end < base_end,
        do: [Tuple.insert_at(dest, pos, (inter_end + 1)..base_end)],
        else: []
  end

  defp axis_intersection(base_start..base_end, other_start..other_end),
    do: max(base_start, other_start)..min(base_end, other_end)

  defp intersection({x_base, y_base, z_base}, {x_other, y_other, z_other}),
    do:
      {axis_intersection(x_base, x_other), axis_intersection(y_base, y_other),
       axis_intersection(z_base, z_other)}

  defp includes?({x_base, y_base, z_base}, {x_other, y_other, z_other}) do
    in_range?(x_base, x_other) and
      in_range?(y_base, y_other) and
      in_range?(z_base, z_other)
  end

  defp excludes?({x_base, y_base, z_base}, {x_other, y_other, z_other}) do
    Range.disjoint?(x_base, x_other) or
      Range.disjoint?(y_base, y_other) or
      Range.disjoint?(z_base, z_other)
  end

  defp in_range?(a1..a2, b1..b2), do: a1 <= b1 and a2 >= b2

  defp cuboid_size(coords) do
    coords
    |> Tuple.to_list()
    |> Enum.map(&Range.size/1)
    |> Enum.product()
  end
end
