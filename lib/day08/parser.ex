defmodule AoC2021.Day08.Parser do
  import NimbleParsec

  whitespace = ascii_string([?\s], min: 1)
  value = ascii_string([?a..?g], min: 1)

  signal =
    times(
      value
      |> ignore(optional(whitespace)),
      10
    )
    |> tag(:signal)

  output =
    times(
      value
      |> ignore(optional(whitespace)),
      4
    )
    |> tag(:output)

  defparsec(:parse, signal |> ignore(string("| ")) |> concat(output) |> eos())

  def note_parser(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.map(&to_note/1)
  end

  defp to_note({:ok, [signal: signal, output: output], "", _, _, _}),
    do: {signal |> Enum.map(&String.to_charlist/1), output |> Enum.map(&String.to_charlist/1)}
end
