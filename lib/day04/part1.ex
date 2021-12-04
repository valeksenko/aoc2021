defmodule AoC2021.Day04.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/4
    You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.

    Maybe it wants to play bingo?

    Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

    The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input).
    The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

    To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?
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

    matched =
      Enum.filter(boards, &board_match?(&1, matches)) ++
        Enum.filter(boards, &board_match?(transpose(&1), matches))

    if Enum.empty?(matched), do: {:cont, matches}, else: {:halt, {matched, matches}}
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
