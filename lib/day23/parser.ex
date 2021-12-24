defmodule AoC2021.Day23.Parser do
  import NimbleParsec

  new_line = ascii_string([?\n], 1)
  wall = ascii_string([?#, ?\s], 1)
  hall = ascii_string([?.], 1)
  amphipod = ascii_string([?A..?D], 1)

  room =
    ignore(repeat(wall))
    |> repeat(
      amphipod
      |> ignore(repeat(wall))
    )
    |> wrap
    |> ignore(new_line)

  diagram =
    ignore(repeat(wall))
    |> ignore(new_line)
    |> ignore(repeat(wall))
    |> ignore(repeat(hall))
    |> ignore(repeat(wall))
    |> ignore(new_line)
    |> repeat(room)
    |> ignore(repeat(wall))
    |> eos()

  defparsec(:parse, diagram)

  def parse_diagram(data) do
    data
    |> parse
    |> to_rooms
  end

  defp to_rooms({:ok, levels, "", _, _, _}), do: levels |> Enum.zip()
end
