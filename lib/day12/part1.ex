defmodule AoC2021.Day12.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/12

    With your submarine's subterranean subsystems subsisting suboptimally, the only way you're getting out of this cave anytime soon is by finding a path yourself. Not just a path - the only way to know if you've found the best path is to find all of them.

    Fortunately, the sensors are still mostly working, and so you build a rough map of the remaining caves (your puzzle input).

    This is a list of how all of the caves are connected. You start in the cave named start, and your destination is the cave named end. An entry like b-d means that cave b is connected to cave d - that is, you can move between them.

    Your goal is to find the number of distinct paths that start at start, end at end, and don't visit small caves more than once. There are two types of caves: big caves (written in uppercase, like A) and small caves (written in lowercase, like b). It would be a waste of time to visit any small cave more than once, but big caves are large enough that it might be worth visiting them multiple times. So, all paths you find should visit small caves at most once, and can visit big caves any number of times.

    Given these rules, there are 10 paths through this example cave system.

    How many paths through this cave system are there that visit small caves at most once?
  """

  @behaviour AoC2021.Day

  @finish "end"

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_caves
    |> visit_caves
    |> length
  end

  defp visit_caves(caves) do
    visit_cave("start", caves, [])
    |> Enum.filter(&(hd(&1) == @finish))
  end

  defp visit_cave(@finish, _, visited), do: [mark_visit(@finish, visited)]

  defp visit_cave(current, caves, visited) do
    caves
    |> Map.get(current, [])
    |> Enum.filter(&visit?(&1, visited))
    |> visit(caves, mark_visit(current, visited))
  end

  def visit([], _, visited), do: [visited]

  def visit(new, caves, visited) do
    new
    |> Enum.flat_map(&visit_cave(&1, caves, visited))
  end

  def mark_visit(cave, visited) do
    [cave | visited]
  end

  def visit?(cave, visited) do
    String.match?(cave, ~r/[A-Z]+/) || !(cave in visited)
  end

  defp to_caves(data) do
    data
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [c1, c2], map -> map |> to_cave(c1, c2) |> to_cave(c2, c1) end)
  end

  def to_cave(map, cave1, cave2) do
    map
    |> Map.put(cave1, [cave2 | Map.get(map, cave1, [])])
  end
end
