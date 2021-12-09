defmodule AoC2021.Day09.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/9

    These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

    If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

    Smoke flows to the lowest point of the area it's in. 

    Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

    Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

    In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

    The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.

    Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?
  """
  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_heightmap
    |> low_points
    |> Enum.map(&(&1 + 1))
    |> Enum.sum
  end

  defp low_points(heightmap) do
    heightmap
    |> Enum.filter(&(low_point(&1, heightmap)))
    |> Enum.map(&elem(&1, 1))
  end

  defp low_point({{x, y}, height}, heightmap) do
    min =
      neighbors()
      |> Enum.map(fn {xd, yd} -> Map.get(heightmap, {x + xd, y + yd}) end)
      |> Enum.reject(&is_nil/1)
      |> Enum.min

    height < min
  end

  defp neighbors do
    for xd <- -1..1, yd <- -1..1, {xd, yd} != {0, 0}, do: {xd, yd}
  end

  defp to_heightmap(data) do
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
