defmodule AoC2021.Day05.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/5#part2

    Unfortunately, considering only horizontal and vertical lines doesn't give you the full picture; you need to also consider diagonal lines.

    Because of the limits of the hydrothermal vent mapping system, the lines in your list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees. In other words:

    An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
    An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.

    You still need to determine the number of points where at least two lines overlap. In the above example, this is still anywhere in the diagram with a 2 or larger - now a total of 12 points.

    Consider all of the lines. At how many points do at least two lines overlap?
  """
  import AoC2021.Day05.Parser

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    lines_parser(data)
    |> Enum.flat_map(&to_coordinates/1)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.count(&(&1 > 1))
  end

  defp to_coordinates({{start_x, start_y}, {end_x, end_y}})
       when start_x == end_x or start_y == end_y,
       do: for(x <- start_x..end_x, y <- start_y..end_y, do: {x, y})

  defp to_coordinates({{start_x, start_y}, {end_x, end_y}}),
    do: Enum.zip(start_x..end_x, start_y..end_y)
end
