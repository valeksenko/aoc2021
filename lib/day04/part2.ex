defmodule AoC2021.Day04.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/4#part2
    
    On the other hand, it might be wise to try a different strategy: let the giant squid win.

    You aren't sure how many bingo boards a giant squid could play at once, so rather than waste time counting its arms, the safe thing to do is to figure out which board will win last and choose that one. That way, no matter which boards it picks, it will win for sure.

    In the above example, the second board is the last to win, which happens after 13 is eventually called and its middle column is completely marked. If you were to keep playing until this point, the second board would have a sum of unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.

    Figure out which board will win last. Once it wins, what would its final score be?
  """
  import AoC2021.Day04.Parser

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    {numbers, boards} = bingo_parser(data)

    numbers
    |> Enum.reduce_while([], &call_number(&1, boards, &2))
    |> result
  end

  defp result({[match], matches}) do
    sum =
      match
      |> List.flatten()
      |> (fn l -> l -- matches end).()
      |> Enum.sum()

    sum * hd(matches)
  end

  defp call_number(number, boards, prev) do
    matches = [number | prev]
    matched = matched_boards(boards, matches)

    if length(boards) == length(matched),
      do: {:halt, {matched -- matched_boards(boards, prev), matches}},
      else: {:cont, matches}
  end

  defp matched_boards(boards, matches) do
    (Enum.filter(boards, &board_match?(&1, matches)) ++
       Enum.filter(boards, &board_match?(transpose(&1), matches)))
    |> Enum.uniq()
  end

  defp board_match?(board, matches) do
    board
    |> Enum.any?(fn row -> Enum.all?(row, &Enum.member?(matches, &1)) end)
  end

  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
