defmodule AoC2021.Day05.Parser do
  import NimbleParsec

  coord =
    integer(min: 1)
    |> ignore(string(","))
    |> concat(integer(min: 1))

  line =
    coord
    |> ignore(string(" -> "))
    |> concat(coord)
    |> eos()

  defparsec(:parse, line)

  def lines_parser(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.map(&to_line/1)
  end

  defp to_line({:ok, [start_x, start_y, end_x, end_y], "", _, _, _}),
    do: {{start_x, start_y}, {end_x, end_y}}
end
