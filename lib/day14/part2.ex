defmodule AoC2021.Day14.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/14#part2

    The resulting polymer isn't nearly strong enough to reinforce the submarine. You'll need to run more steps of the pair insertion process; a total of 40 steps should do it.

    Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
  """
  import AoC2021.Day14.Parser

  @behaviour AoC2021.Day

  @steps 40

  @impl AoC2021.Day
  def run(data) do
    {template, rules} = formula_parser(data)

    template
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.frequencies()
    |> apply_rules(rules, @steps)
    |> result(hd(template))
  end

  defp result(frequencies, first) do
    {min, max} =
      frequencies
      |> Enum.reduce(%{first => 1}, fn {[_, e], amount}, map ->
        Map.put(map, e, Map.get(map, e, 0) + amount)
      end)
      |> Map.values()
      |> Enum.min_max()

    max - min
  end

  defp apply_rules(frequencies, _, 0), do: frequencies

  defp apply_rules(frequencies, rules, step) do
    frequencies
    |> Enum.reduce(%{}, &update(&1, &2, rules))
    |> apply_rules(rules, step - 1)
  end

  defp update({elements = [e1, e2], amount}, frequencies, rules) do
    case Map.get(rules, elements) do
      nil ->
        Map.put(frequencies, elements, amount)

      e ->
        frequencies
        |> Map.put([e1, e], Map.get(frequencies, [e1, e], 0) + amount)
        |> Map.put([e, e2], Map.get(frequencies, [e, e2], 0) + amount)
    end
  end
end
