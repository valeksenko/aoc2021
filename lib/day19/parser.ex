defmodule AoC2021.Day19.Parser do
  import NimbleParsec

  new_line = ascii_string([?\n], 1)
  element = ascii_string([?A..?Z], 1)

  signed =
    optional(ascii_char([?-]))
    |> integer(min: 1)
    |> post_traverse({:sign_int, []})

  beacon =
    signed
    |> ignore(string(","))
    |> concat(signed)
    |> ignore(string(","))
    |> concat(signed)
    |> reduce({List, :to_tuple, []})
    |> ignore(optional(new_line))

  scan =
    ignore(string("---") |> repeat(ascii_char(not: ?\n)) |> concat(new_line))
    |> repeat(beacon)
    |> ignore(optional(new_line))
    |> wrap()

  defp sign_int(_, [int, _neg], context, _, _), do: {[int * -1], context}
  defp sign_int(_, res, context, _, _), do: {res, context}

  defparsec(:parse, repeat(scan) |> eos())

  def parse_scans(data) do
    data
    |> parse
    |> to_scans
  end

  defp to_scans({:ok, scans, "", _, _, _}), do: scans
end
