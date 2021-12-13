defmodule AoC2021.Day13.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/13

    You reach another volcanically active part of the cave. It would be nice if you could do some kind of thermal imaging so you could tell ahead of time which caves are too hot to safely enter.

    Fortunately, the submarine seems to be equipped with a thermal camera! When you activate it, you are greeted with:

    Congratulations on your purchase! To activate this infrared thermal imaging
    camera system, please enter the code found on page 1 of the manual.
    Apparently, the Elves have never used this feature. To your surprise, you manage to find the manual; as you go to open it, page 1 falls out. It's a large sheet of transparent paper! The transparent paper is marked with random dots and includes instructions on how to fold it up (your puzzle input). 
    The first section is a list of dots on the transparent paper. 0,0 represents the top-left coordinate. The first value, x, increases to the right. The second value, y, increases downward. So, the coordinate 3,0 is to the right of 0,0, and the coordinate 0,7 is below 0,0. The coordinates in this example form the following pattern, where # is a dot on the paper and . is an empty, unmarked position:

    Then, there is a list of fold instructions. Each instruction indicates a line on the transparent paper and wants you to fold the paper up (for horizontal y=... lines) or left (for vertical x=... lines). In this example, the first fold instruction is fold along y=7, which designates the line formed by all of the positions where y is 7 (marked here with -):

    The transparent paper is pretty big, so for now, focus on just completing the first fold. After the first fold in the example above, 17 dots are visible - dots that end up overlapping after the fold is completed count as a single dot.

    How many dots are visible after completing just the first fold instruction on your transparent paper?    
  """
  import AoC2021.Day13.Parser

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    {coordinates, instructions} = manual_parser(data)

    instructions
    |> hd
    |> fold(coordinates)
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
end
