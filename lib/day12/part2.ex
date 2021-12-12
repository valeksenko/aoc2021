defmodule AoC2021.Day12.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/12#part2

    After reviewing the available paths, you realize you might have time to visit a single small cave twice. Specifically, big caves can be visited any number of times, a single small cave can be visited at most twice, and the remaining small caves can be visited at most once. However, the caves named start and end can only be visited exactly once each: once you leave the start cave, you may not return to it, and once you reach the end cave, the path must end immediately.
    Given these new rules, how many paths through this cave system are there?
  """

  @behaviour AoC2021.Day

  @finish "end"
  @singles ["start", "end"]

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
    |> Enum.filter(&visit?(&1, current, visited))
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

  def visit?(cave, current, visited) do
    big?(cave) ||
      !(cave in visited) ||
      (!(cave in @singles) && !doubles?(mark_visit(current, visited)))
  end

  defp big?(cave) do
    String.match?(cave, ~r/[A-Z]+/)
  end

  defp doubles?(visited) do
    smalls = Enum.reject(visited, &big?/1)
    length(smalls) != smalls |> Enum.uniq() |> length
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
