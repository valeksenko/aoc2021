defmodule AoC2021.Day23.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/23#part2

    As you prepare to give the amphipods your solution, you notice that the diagram they handed you was actually folded up. As you unfold it, you discover an extra part of the diagram.

    Between the first and second lines of text that contain amphipod starting positions, insert the following lines:

      #D#C#B#A#
      #D#B#A#C#

    Using the initial configuration from the full diagram, what is the least energy required to organize the amphipods?
  """
  import AoC2021.Day23.Parser

  @behaviour AoC2021.Day

  @hall_size 11
  @rooms %{
    "A" => 2,
    "B" => 4,
    "C" => 6,
    "D" => 8
  }
  @energy %{
    "A" => 1,
    "B" => 10,
    "C" => 100,
    "D" => 1000
  }
  @hall 0
  @top 1
  @level1 2
  @level2 3
  @bottom 4
  @levels @top..@bottom

  @impl AoC2021.Day
  def run(data) do
    parse_diagram(data)
    |> to_diagram
    |> insert_extra
    |> min_energy(0, :none, [])
  end

  defp min_energy(diagram, energy, calculated, moved) do
    cond do
      calculated != :none and energy >= calculated ->
        calculated

      rooms_filled?(diagram) ->
        energy

      true ->
        diagram
        |> Enum.filter(&available?(diagram, &1))
        |> Enum.flat_map(&moves(diagram, &1))
        |> Enum.reject(fn {d, _} -> d in moved end)
        |> Enum.sort_by(&elem(&1, 1))
        # |> Enum.map(&inspect_diagram/1)
        |> Enum.reduce(calculated, fn {d, e}, c ->
          min_energy(d, energy + e, c, [diagram | moved])
        end)
    end
  end

  defp available?(_, {_, :free}), do: false
  defp available?(_, {{_, @hall}, _}), do: true

  defp available?(diagram, {{x, y}, _}),
    do: diagram[{x, y - 1}] == :free and y..@bottom |> Enum.any?(&(@rooms[diagram[{x, &1}]] != x))

  defp moves(diagram, {pos = {_, y}, type}) do
    room = @rooms[type]

    free = @bottom..@top |> Enum.find(&(diagram[{room, &1}] == :free))

    cond do
      free != nil and room_available?(diagram, room, free, type) and
          free_path?(diagram, pos, room) ->
        [move(diagram, pos, {room, free})]

      y == @hall ->
        []

      true ->
        hall_moves(diagram, pos)
    end
  end

  defp move(diagram, source, dest) do
    {
      diagram |> Map.put(dest, diagram[source]) |> Map.put(source, :free),
      energy(diagram, source, dest)
    }
  end

  defp room_available?(_, _, @bottom, _), do: true

  defp room_available?(diagram, x, y, type),
    do: (y + 1)..@bottom |> Enum.all?(&(diagram[{x, &1}] == type))

  defp free_path?(diagram, {xs, ys}, xd) do
    free_room_exit?(diagram, xs, ys) and
      xs..xd |> Enum.drop(1) |> Enum.all?(fn x -> diagram[{x, @hall}] == :free end)
  end

  defp free_room_exit?(_, _, @hall), do: true

  defp free_room_exit?(diagram, x, y),
    do: @hall..(y - 1) |> Enum.all?(&(diagram[{x, &1}] == :free))

  defp hall_moves(diagram, pos) do
    (free_halls(diagram, pos, fn {{x, _}, _} -> x end) ++
       free_halls(diagram, pos, fn {{x, _}, _} -> -x end))
    |> Enum.map(&elem(&1, 0))
    |> Enum.reject(&(elem(&1, 0) in room_indexes()))
    |> Enum.map(&move(diagram, pos, &1))
  end

  defp free_halls(diagram, {x, _}, sorter) do
    diagram
    |> Enum.filter(fn {{_, y1}, _} -> y1 == @hall end)
    |> Enum.sort_by(sorter)
    |> Enum.drop_while(fn {{x1, _}, _} -> x1 != x end)
    |> Enum.take_while(fn {{_, _}, val} -> val == :free end)
  end

  defp energy(diagram, pos1, pos2) do
    @energy[diagram[pos1]] * distance(pos1, pos2)
  end

  defp distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + y1 + y2
  end

  defp rooms_filled?(diagram) do
    for(x <- room_indexes(), y <- @levels, do: {x, y})
    |> Enum.all?(fn {x, y} -> @rooms[diagram[{x, y}]] == x end)
  end

  defp inspect_diagram({diagram, energy}) do
    IO.inspect({:energy, energy})
    for x <- 0..(@hall_size - 1), do: IO.binwrite(inspect_cell(diagram[{x, @hall}]))

    for y <- @levels do
      IO.binwrite("\n  ")

      for x <- Map.values(@rooms) do
        IO.binwrite(inspect_cell(diagram[{x, y}]))
        IO.binwrite(" ")
      end
    end

    IO.binwrite("\n\n")
    {diagram, energy}
  end

  defp inspect_cell(val), do: if(val == :free, do: ".", else: val)

  defp insert_extra(diagram) do
    %{
      @level1 => ["D", "C", "B", "A"],
      @level2 => ["D", "B", "A", "C"]
    }
    |> Enum.reduce(diagram, &add_level/2)
  end

  defp add_level({y, amphipods}, diagram) do
    amphipods
    |> Enum.zip(room_indexes())
    |> Enum.reduce(diagram, fn {a, x}, d -> Map.put(d, {x, y}, a) end)
  end

  defp to_diagram(rooms) do
    diagram =
      0..(@hall_size - 1)
      |> Enum.map(&{{&1, @hall}, :free})
      |> Enum.into(%{})

    indexes = room_indexes()

    rooms
    |> Enum.with_index()
    |> Enum.reduce(diagram, fn {{a1, a2}, i}, d ->
      d |> Map.put({Enum.at(indexes, i), @top}, a1) |> Map.put({Enum.at(indexes, i), @bottom}, a2)
    end)
  end

  defp room_indexes do
    @rooms
    |> Map.values()
    |> Enum.sort()
  end
end
