defmodule AoC2021.Day22.Parser do
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

  step =
    choice([
      string("on"),
      string("off")
    ])
    |> ignore(string(" x="))
    |> concat(range)
    |> ignore(string(",y="))
    |> concat(range)
    |> ignore(string(",z="))
    |> concat(range)
    |> eos()

  defp to_range([min, max]), do: min..max

  defp sign_int(_, [int, _neg], context, _, _), do: {[int * -1], context}
  defp sign_int(_, res, context, _, _), do: {res, context}

  defparsec(:parse, step)

  def parse_steps(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.map(&to_step/1)
  end

  defp to_step({:ok, [state, x, y, z], "", _, _, _}) do
    {{x, y, z}, String.to_atom(state)}
  end
end
