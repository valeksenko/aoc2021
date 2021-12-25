defmodule AoC2021.Day24.Parser do
  import NimbleParsec
  alias AoC2021.Day24.ALU.Instruction

  whitespace = ascii_string([?\s], min: 1)
  variable = ascii_string([?w..?z], 1)

  number =
    ignore(optional(ascii_char([?+])))
    |> optional(ascii_char([?-]))
    |> integer(min: 1)
    |> post_traverse({:sign_int, []})

  defp sign_int(_, [int, _neg], context, _, _) do
    {[int * -1], context}
  end

  defp sign_int(_, res, context, _, _) do
    {res, context}
  end

  arguments =
    ignore(whitespace)
    |> concat(variable)
    |> optional(
      ignore(whitespace)
      |> choice([
        variable,
        number
      ])
    )
    |> reduce({List, :to_tuple, []})

  instruction =
    ascii_string([?a..?z], 3)
    |> concat(arguments)
    |> eos()

  defparsec(:parse, instruction)

  def parse_code(data) do
    data
    |> Enum.map(&parse/1)
    |> Enum.map(&to_instruction/1)
  end

  defp to_instruction({:ok, [op, arguments], _, _, _, _}) do
    %Instruction{op: op, arguments: arguments}
  end
end
