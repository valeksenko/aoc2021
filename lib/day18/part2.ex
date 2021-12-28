defmodule AoC2021.Day18.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/18#part2
    
    You notice a second question on the back of the homework assignment:

    What is the largest magnitude you can get from adding only two of the snailfish numbers?

    Note that snailfish addition is not commutative - that is, x + y and y + x can produce different results.

    What is the largest magnitude of any sum of two different snailfish numbers from the homework assignment?
  """
  import AoC2021.Day18.Parser

  @explode 4

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    data
    |> parse_pairs
    |> permutations
    |> Enum.map(&pair_magnitude/1)
    |> Enum.max()
  end

  defp pair_magnitude(pair) do
    pair
    |> reduce_and_split
    |> magnitude
  end

  defp permutations(numbers) do
    0..(length(numbers) - 1)
    |> Enum.map(&List.pop_at(numbers, &1))
    |> Enum.map(&permutation/1)
    |> List.flatten()
  end

  defp permutation({number, reminder}) do
    [reminder]
    |> Enum.zip_with(fn [x] -> [{x, number}, {number, x}] end)
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
