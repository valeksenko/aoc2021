defmodule AoC2021.Day13.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/13#part2

    Finish folding the transparent paper according to the instructions. The manual says the code is always eight capital letters.

    What code do you use to activate the infrared thermal imaging camera system?
  """
  import AoC2021.Day13.Parser

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    {coordinates, instructions} = manual_parser(data)

    instructions
    |> Enum.reduce(coordinates, &fold/2)
    |> inspect_manual
    |> map_size
  end

  defp fold({axis, fold_value}, coordinates) do
    coordinates
    |> Enum.reduce(%{}, fn {pos, val}, cs -> update(cs, translate(axis, pos, fold_value), val) end)
  end

  defp update(coordinates, pos, value) do
    coordinates
    |> Map.put(pos, value + Map.get(coordinates, pos, 0))
  end

  defp translate("x", {x, y}, fold_value) do
    new = if x > fold_value, do: fold_value - (x - fold_value), else: x
    {new, y}
  end

  defp translate("y", {x, y}, fold_value) do
    new = if y > fold_value, do: fold_value - (y - fold_value), else: y
    {x, new}
  end

  def inspect_manual(coordinates) do
    max_x = coordinates |> Map.keys() |> Enum.max_by(fn {x, _} -> x end) |> elem(0)
    max_y = coordinates |> Map.keys() |> Enum.max_by(fn {_, y} -> y end) |> elem(1)

    for y <- 0..max_y do
      for x <- 0..max_x,
          do: IO.binwrite(if Map.has_key?(coordinates, {x, y}), do: "#", else: " ")

      IO.binwrite("\n")
    end

    coordinates
  end
end
