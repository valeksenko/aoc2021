defmodule AoC2021.Day14.Parser do
  import NimbleParsec

  new_line = ascii_string([?\n], 1)
  element = ascii_string([?A..?Z], 1)

  rules =
    repeat(
      element
      |> concat(element)
      |> wrap
      |> ignore(string(" -> "))
      |> concat(element)
      |> reduce({List, :to_tuple, []})
      |> ignore(optional(new_line))
    )
    |> tag(:rules)

  template =
    repeat(element)
    |> ignore(new_line)
    |> tag(:template)

  defparsec(:parse, template |> ignore(new_line) |> concat(rules) |> eos())

  def formula_parser(data) do
    data
    |> parse
    |> to_formula
  end

  defp to_formula({:ok, [template: template, rules: rules], "", _, _, _}),
    do: {template, Map.new(rules)}
end
