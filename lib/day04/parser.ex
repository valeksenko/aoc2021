defmodule AoC2021.Day04.Parser do
  import NimbleParsec

  whitespace = ascii_string([?\s], min: 1)
  new_line = ascii_string([?\n], 1)

  numbers =
    integer(min: 1)
    |> repeat(
      ignore(string(","))
      |> concat(integer(min: 1))
    )
    |> tag(:numbers)
    |> ignore(new_line)

  row =
    times(
      ignore(optional(whitespace))
      |> concat(integer(min: 1)),
      5
    )
    |> wrap
    |> ignore(optional(new_line))

  board =
    ignore(new_line)
    |> times(row, 5)
    |> tag(:board)

  boards =
    times(board, min: 1)
    |> tag(:boards)

  defparsec(:parse, numbers |> concat(boards))

  def bingo_parser(data) do
    case parse(data) do
      {:ok, [numbers: numbers, boards: boards], _, _, _, _} ->
        {numbers, boards |> Enum.map(fn {:board, b} -> b end)}
    end
  end
end
