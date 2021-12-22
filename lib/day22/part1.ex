defmodule AoC2021.Day22.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/22

    Operating at these extreme ocean depths has overloaded the submarine's reactor; it needs to be rebooted.

    The reactor core is made up of a large 3-dimensional grid made up entirely of cubes, one cube per integer 3-dimensional coordinate (x,y,z). Each cube can be either on or off; at the start of the reboot process, they are all off. (Could it be an old model of a reactor you've seen before?)

    To reboot the reactor, you just need to set all of the cubes to either on or off by following a list of reboot steps (your puzzle input). Each step specifies a cuboid (the set of all cubes that have coordinates which fall within ranges for x, y, and z) and whether to turn all of the cubes in that cuboid on or off.

    The initialization procedure only uses cubes that have x, y, and z positions of at least -50 and at most 50. For now, ignore cubes outside this region.

    Execute the reboot steps. Afterward, considering only cubes in the region x=-50..50,y=-50..50,z=-50..50, how many cubes are on?
  """
  import AoC2021.Day22.Parser

  @behaviour AoC2021.Day

  @limit 50
  @range -@limit..@limit

  @impl AoC2021.Day
  def run(data) do
    data
    |> parse_steps
    |> Enum.filter(&limited/1)
    |> Enum.reduce(%{}, &run_step/2)
    |> Enum.filter(fn {{x, y, z}, _} -> x in @range and y in @range and z in @range end)
    |> Enum.count(fn {_, v} -> v == :on end)
  end

  defp limited({ranges, _}) do
    ranges
    |> Tuple.to_list()
    |> Enum.all?(fn min..max -> min >= -@limit and max <= @limit end)
  end

  defp run_step({{x_range, y_range, z_range}, state}, core) do
    for(x <- x_range, y <- y_range, z <- z_range, do: {x, y, z})
    |> Enum.reduce(core, fn coord, c -> Map.put(c, coord, state) end)
  end
end
