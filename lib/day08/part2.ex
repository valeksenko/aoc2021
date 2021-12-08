defmodule AoC2021.Day08.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/8#part2

    Through a little deduction, you should now be able to determine the remaining digits. 
    For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?  
  """
  import AoC2021.Day08.Parser

  @digits %{
    [?a, ?b, ?c, ?e, ?f, ?g] => 0,
    [?c, ?f] => 1,
    [?a, ?c, ?d, ?e, ?g] => 2,
    [?a, ?c, ?d, ?f, ?g] => 3,
    [?b, ?c, ?d, ?f] => 4,
    [?a, ?b, ?d, ?f, ?g] => 5,
    [?a, ?b, ?d, ?e, ?f, ?g] => 6,
    [?a, ?c, ?f] => 7,
    [?a, ?b, ?c, ?d, ?e, ?f, ?g] => 8,
    [?a, ?b, ?c, ?d, ?f, ?g] => 9
  }
  @ids Enum.to_list(?a..?g)

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    note_parser(data)
    |> Enum.map(&decode(&1, %{}, @ids))
    |> Enum.map(&translate/1)
    |> Enum.sum()
  end

  defp decode(note, decoded, []), do: {note, decoded}

  defp decode(note, decoded, [c | remaining]) do
    case match(note, c, Map.values(decoded)) do
      nil -> decode(note, decoded, remaining ++ [c])
      c1 -> decode(note, Map.put(decoded, c, c1), remaining)
    end
  end

  def match({signal, _}, c, decoded) do
    target = matching(signal, c)

    (@ids -- decoded)
    |> Enum.find(&(matching(Map.keys(@digits), &1) == target))
  end

  defp matching(digits, c) do
    digits
    |> Enum.filter(&(c in &1))
    |> Enum.map(&length/1)
    |> Enum.sort()
  end

  defp translate({{_, output}, decoded}) do
    output
    |> Enum.map(&translate_digit(&1, decoded))
    |> Enum.join()
    |> String.to_integer()
  end

  defp translate_digit(output, decoded) do
    output
    |> Enum.map(&Map.fetch!(decoded, &1))
    |> Enum.sort()
    |> (fn s -> Map.fetch!(@digits, s) end).()
  end
end
