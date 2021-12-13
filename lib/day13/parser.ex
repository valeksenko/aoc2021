defmodule AoC2021.Day13.Parser do
  import NimbleParsec

  new_line = ascii_string([?\n], 1)

  instructions =
    repeat(
      ignore(string("fold along "))
      |> concat(ascii_string([?x, ?y], 1))
      |> ignore(string("="))
      |> integer(min: 1)
      |> ignore(optional(new_line))
      |> reduce({List, :to_tuple, []})
    )
    |> tag(:instructions)

  coordinates =
    repeat(
      integer(min: 1)
      |> ignore(string(","))
      |> integer(min: 1)
      |> ignore(new_line)
      |> reduce({List, :to_tuple, []})
    )
    |> tag(:coordinates)

  defparsec(:parse, coordinates |> ignore(new_line) |> concat(instructions) |> eos())

  def manual_parser(data) do
    data
    |> parse
    |> to_manual
  end

  defp to_manual({:ok, [coordinates: coordinates, instructions: instructions], "", _, _, _}),
    do: {coordinates |> Enum.map(&{&1, 1}) |> Map.new(), instructions}
end
