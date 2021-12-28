defmodule AoC2021.Day18.Parser do
  import NimbleParsec

  value = integer(min: 1)

  pair =
    ignore(ascii_char([?[]))
    |> choice([
      value,
      parsec(:pair_parser)
    ])
    |> ignore(ascii_char([?,]))
    |> choice([
      value,
      parsec(:pair_parser)
    ])
    |> ignore(ascii_char([?]]))
    |> reduce({List, :to_tuple, []})

  defparsec(:pair_parser, pair)

  def parse_pairs(data) do
    data
    |> Enum.map(&pair_parser/1)
    |> Enum.map(&to_pair/1)
  end

  defp to_pair({:ok, [pairs], "", _, _, _}), do: pairs
end
