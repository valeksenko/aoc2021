defmodule AoC2021.Day17.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/17

    Ahead of you is what appears to be a large ocean trench. Could the keys have fallen into it? You'd better send a probe to investigate.

    The probe launcher on your submarine can fire the probe with any integer velocity in the x (forward) and y (upward, or downward if negative) directions. For example, an initial x,y velocity like 0,10 would fire the probe straight up, while an initial velocity like 10,-1 would fire the probe forward at a slight downward angle.

    The probe's x,y position starts at 0,0. Then, it will follow some trajectory by moving in steps. On each step, these changes occur in the following order:

    The probe's x position increases by its x velocity.
    The probe's y position increases by its y velocity.
    Due to drag, the probe's x velocity changes by 1 toward the value 0; that is, it decreases by 1 if it is greater than 0, increases by 1 if it is less than 0, or does not change if it is already 0.
    Due to gravity, the probe's y velocity decreases by 1.
    For the probe to successfully make it into the trench, the probe must be on some trajectory that causes it to be within a target area after any step. The submarine computer has already calculated this target area (your puzzle input). For example:

    target area: x=20..30, y=-10..-5
    This target area means that you need to find initial x,y velocity values such that after any step, the probe's x position is at least 20 and at most 30, and the probe's y position is at least -10 and at most -5.

    The probe appears to pass through the target area, but is never within it after any step. Instead, it continues down and to the right - only the first few steps are shown.

    If you're going to fire a highly scientific probe out of a super cool probe launcher, you might as well do it with style. How high can you make the probe go while still reaching the target area?

    In the above example, using an initial velocity of 6,9 is the best you can do, causing the probe to reach a maximum y position of 45. (Any higher initial y velocity causes the probe to overshoot the target area entirely.)

    Find the initial velocity that causes the probe to reach the highest y position and still eventually be within the target area after any step. What is the highest y position it reaches on this trajectory?
  """
  import AoC2021.Day17.Parser

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    {x_target, y_target} = data |> hd |> parse_target

    velocities(x_target)
    |> Enum.map(&fire(&1, x_target, y_target))
    |> Enum.filter(&hit?(&1, x_target, y_target))
    |> Enum.map(&top/1)
    |> Enum.max()
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

  def top(trajectory) do
    trajectory
    |> Enum.map(fn {{_, y}, _} -> y end)
    |> Enum.max()
  end

  defp velocities(_..x_max) do
    for xv <- 1..x_max, yv <- 0..x_max, do: {xv, yv}
  end

  defp passed?({x, y}, _..x_max, y_min.._), do: x > x_max or y < y_min

  defp move({{x, y}, {xv, yv}}), do: {{x + xv, y + yv}, {change(xv), yv - 1}}

  defp change(n), do: if(n > 0, do: n - 1, else: 0)
end
