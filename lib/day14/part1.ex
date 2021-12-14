defmodule AoC2021.Day14.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/14

    The incredible pressures at this depth are starting to put a strain on your submarine. The submarine has polymerization equipment that would produce suitable materials to reinforce the submarine, and the nearby volcanically-active caves should even have the necessary input elements in sufficient quantities.

    The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer template and a list of pair insertion rules (your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.

    The first line is the polymer template - this is the starting point of the process.

    The following section defines the pair insertion rules. A rule like AB -> C means that when elements A and B are immediately adjacent, element C should be inserted between them. These insertions all happen simultaneously.

    Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
  """
  import AoC2021.Day14.Parser

  @behaviour AoC2021.Day

  @steps 10

  @impl AoC2021.Day
  def run(data) do
    {template, rules} = formula_parser(data)

    template
    |> apply_rules(rules, @steps)
    |> result
  end

  defp result(polymer) do
    {min, max} = polymer |> Enum.frequencies() |> Map.values() |> Enum.min_max()

    max - min
  end

  defp apply_rules(polymer, _, 0), do: polymer

  defp apply_rules(polymer, rules, step) do
    polymer
    |> Enum.chunk_every(2, 1)
    |> Enum.flat_map(&map(&1, rules))
    |> apply_rules(rules, step - 1)
  end

  defp map([e], _), do: [e]

  defp map(elements = [e1, _], rules) do
    case Map.get(rules, elements) do
      nil -> [e1]
      e -> [e1, e]
    end
  end
end
