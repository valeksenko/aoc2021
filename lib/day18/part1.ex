defmodule AoC2021.Day18.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/18

    You descend into the ocean trench and encounter some snailfish. They say they saw the sleigh keys! They'll even tell you which direction the keys went if you help one of the smaller snailfish with his math homework.

    Snailfish numbers aren't like regular numbers. Instead, every snailfish number is a pair - an ordered list of two elements. Each element of the pair can be either a regular number or another pair.

    Pairs are written as [x,y], where x and y are the elements within the pair. Here are some example snailfish numbers, one snailfish number per line.

    This snailfish homework is about addition. To add two snailfish numbers, form a pair from the left and right parameters of the addition operator. For example, [1,2] + [[3,4],5] becomes [[1,2],[[3,4],5]].

    There's only one problem: snailfish numbers must always be reduced, and the process of adding two snailfish numbers can result in snailfish numbers that need to be reduced.

    To reduce a snailfish number, you must repeatedly do the first action in this list that applies to the snailfish number:

    If any pair is nested inside four pairs, the leftmost such pair explodes.
    If any regular number is 10 or greater, the leftmost such regular number splits.
    Once no action in the above list applies, the snailfish number is reduced.

    During reduction, at most one action applies, after which the process returns to the top of the list of actions. For example, if split produces a pair that meets the explode criteria, that pair explodes before other splits occur.

    To explode a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any), and the pair's right value is added to the first regular number to the right of the exploding pair (if any). Exploding pairs will always consist of two regular numbers. Then, the entire exploding pair is replaced with the regular number 0.

    To split a regular number, replace it with a pair; the left element of the pair should be the regular number divided by two and rounded down, while the right element of the pair should be the regular number divided by two and rounded up. For example, 10 becomes [5,5], 11 becomes [5,6], 12 becomes [6,6], and so on.

    The homework assignment involves adding up a list of snailfish numbers (your puzzle input). The snailfish numbers are each listed on a separate line. Add the first snailfish number and the second, then add that result and the third, then add that result and the fourth, and so on until all numbers in the list have been used once.

    To check whether it's the right answer, the snailfish teacher only checks the magnitude of the final sum. The magnitude of a pair is 3 times the magnitude of its left element plus 2 times the magnitude of its right element. The magnitude of a regular number is just that number.

    Add up all of the snailfish numbers from the homework assignment in the order they appear. What is the magnitude of the final sum?
  """
  import AoC2021.Day18.Parser

  @explode 4

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    data
    |> parse_pairs
    |> Enum.reduce(&add_pair/2)
    |> magnitude
  end

  defp add_pair(b, a) do
    reduce_and_split({a, b})
  end

  defp reduce_and_split(pair) do
    {next, reduced, _} = reduce(pair, 0)

    if reduced do
      reduce_and_split(next)
    else
      {done, next} = split(pair)
      if done, do: reduce_and_split(next), else: next
    end
  end

  defp reduce({a, b}, @explode) when is_number(a) and is_number(b), do: {0, true, {a, b}}
  defp reduce(n, _) when is_number(n), do: {n, false, {:done, :done}}

  defp reduce({a, b}, level) do
    {a1, reduced, {adda, addb}} = reduce(a, level + 1)

    if reduced do
      if addb == :done,
        do: {{a1, b}, true, {adda, :done}},
        else: {{a1, add_right(b, addb)}, true, {adda, :done}}
    else
      {b1, reduced, {adda, addb}} = reduce(b, level + 1)

      if reduced do
        if adda == :done,
          do: {{a1, b1}, true, {:done, addb}},
          else: {{add_left(a, adda), b1}, true, {:done, addb}}
      else
        {{a, b}, false, {:done, :done}}
      end
    end
  end

  defp add_left(n, adda) when is_number(n), do: n + adda
  defp add_left({a, b}, adda), do: {a, add_left(b, adda)}

  defp add_right(n, addb) when is_number(n), do: n + addb
  defp add_right({a, b}, addb), do: {add_right(a, addb), b}

  defp split(n) when is_number(n) do
    if n >= 10, do: {true, {floor(n / 2), ceil(n / 2)}}, else: {false, n}
  end

  defp split({a, b}) do
    {done, next} = split(a)

    if done do
      {true, {next, b}}
    else
      {done, next} = split(b)
      if done, do: {true, {a, next}}, else: {false, {a, b}}
    end
  end

  defp magnitude({a, b}) when is_tuple(a), do: magnitude({magnitude(a), b})
  defp magnitude({a, b}) when is_tuple(b), do: magnitude({a, magnitude(b)})
  defp magnitude({a, b}), do: 3 * a + 2 * b
end
