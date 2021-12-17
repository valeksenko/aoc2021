defmodule AoC2021.Day17.Parser do
  import NimbleParsec

  signed =
    optional(ascii_char([?-]))
    |> integer(min: 1)
    |> post_traverse({:sign_int, []})

  range =
    signed
    |> ignore(string(".."))
    |> concat(signed)
    |> reduce({:to_range, []})

  # Example: target area: x=20..30, y=-10..-5
  target =
    ignore(string("target area: x="))
    |> concat(range)
    |> ignore(string(", y="))
    |> concat(range)

  defparsec(:parse, target)

  defp to_range([min, max]), do: min..max

  defp sign_int(_, [int, _neg], context, _, _), do: {[int * -1], context}
  defp sign_int(_, res, context, _, _), do: {res, context}

  def parse_target(data) do
    data
    |> parse
    |> to_target
  end

  defp to_target({:ok, [x, y], "", _, _, _}), do: {x, y}
end
