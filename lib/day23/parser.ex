defmodule AoC2021.Day23.Parser do
  import NimbleParsec

  new_line = ascii_string([?\n], 1)
  wall = ascii_string([?#, ?\s], 1)
  hall = ascii_string([?.], 1)
  amphipod = ascii_string([?A..?D], 1)

  rooms =
    ignore(repeat(wall))
    |> times(
      amphipod
      |> ignore(repeat(wall)),
      4
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
    |> times(rooms, 2)
    |> ignore(repeat(wall))
    |> ignore(repeat(new_line))

  defparsec(:parse, diagram)

  def parse_diagram(data) do
    data
    |> parse
    |> to_rooms
  end

  defp to_rooms({:ok, levels, "", _, _, _}), do: levels |> Enum.zip()
end
