defmodule AoC2021.Day17.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/17#part2

    Maybe a fancy trick shot isn't the best idea; after all, you only have one probe, so you had better not miss.

    To get the best idea of what your options are for launching the probe, you need to find every initial velocity that causes the probe to eventually be within the target area after any step.

    How many distinct initial velocity values cause the probe to be within the target area after any step?d the initial velocity that causes the probe to reach the highest y position and still eventually be within the target area after any step. What is the highest y position it reaches on this trajectory?
  """
  import AoC2021.Day17.Parser

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    {x_target, y_target} = data |> hd |> parse_target

    velocities(x_target)
    |> Enum.map(&fire(&1, x_target, y_target))
    |> Enum.count(&hit?(&1, x_target, y_target))
  end

  def fire(velocity, x_target, y_target) do
    {{0, 0}, velocity}
    |> Stream.iterate(&move/1)
    |> Stream.take_while(fn {pos, _} -> !passed?(pos, x_target, y_target) end)
    |> Enum.to_list()
  end

  def hit?(trajectory, x_target, y_target) do
    trajectory
    |> Enum.any?(fn {{x, y}, _} -> x in x_target and y in y_target end)
  end

  defp velocities(_..x_max) do
    for xv <- 1..x_max, yv <- -x_max..x_max, do: {xv, yv}
  end

  defp passed?({x, y}, _..x_max, y_min.._), do: x > x_max or y < y_min

  defp move({{x, y}, {xv, yv}}), do: {{x + xv, y + yv}, {change(xv), yv - 1}}

  defp change(n), do: if(n > 0, do: n - 1, else: 0)
end
