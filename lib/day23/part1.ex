defmodule AoC2021.Day23.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/23

    A group of amphipods notice your fancy submarine and flag you down. "With such an impressive shell," one amphipod says, "surely you can help us with a question that has stumped our best scientists."

    They go on to explain that a group of timid, stubborn amphipods live in a nearby burrow. Four types of amphipods live there: Amber (A), Bronze (B), Copper (C), and Desert (D). They live in a burrow that consists of a hallway and four side rooms. The side rooms are initially full of amphipods, and the hallway is initially empty.

    They give you a diagram of the situation (your puzzle input), including locations of each amphipod (A, B, C, or D, each of which is occupying an otherwise open space), walls (#), and open space (.).

    Amphipods can move up, down, left, or right so long as they are moving into an unoccupied open space. Each type of amphipod requires a different amount of energy to move one step: Amber amphipods require 1 energy per step, Bronze amphipods require 10 energy, Copper amphipods require 100, and Desert ones require 1000. The amphipods would like you to find a way to organize the amphipods that requires the least total energy.

    However, because they are timid and stubborn, the amphipods have some extra rules:

    Amphipods will never stop on the space immediately outside any room. They can move into that space so long as they immediately continue moving. (Specifically, this refers to the four open spaces in the hallway that are directly above an amphipod starting position.)
    Amphipods will never move from the hallway into a room unless that room is their destination room and that room contains no amphipods which do not also have that room as their own destination. If an amphipod's starting room is not its destination room, it can stay in that room until it leaves the room. (For example, an Amber amphipod will not move from the hallway into the right three rooms, and will only move into the leftmost room if that room is empty or if it only contains other Amber amphipods.)
    Once an amphipod stops moving in the hallway, it will stay in that spot until it can move into a room. (That is, once any amphipod starts moving, any other amphipods currently in the hallway are locked in place and will not move again until they can move fully into a room.)

    What is the least energy required to organize the amphipods?
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
  @bottom 2

  @impl AoC2021.Day
  def run(data) do
    parse_diagram(data)
    |> to_diagram
    |> min_energy(0, [])
    |> Enum.min()
  end

  defp min_energy(diagram, energy, moved) do
    if rooms_filled?(diagram) do
      [energy]
    else
      moved = [diagram | moved]

      diagram
      |> Enum.filter(&available?(diagram, &1))
      |> Enum.flat_map(&moves(diagram, &1))
      |> Enum.reject(fn {d, _} -> d in moved end)
      |> Enum.flat_map(fn {d, e} -> min_energy(d, energy + e, moved) end)
    end
  end

  defp available?(_, {_, :free}), do: false
  defp available?(_, {{_, @hall}, _}), do: true
  defp available?(diagram, {{x, @top}, val}), do: x != @rooms[val] or diagram[{x, @bottom}] != val

  defp available?(diagram, {{x, @bottom}, val}),
    do: x != @rooms[val] && diagram[{x, @top}] == :free

  defp moves(diagram, {pos = {x, y}, type}) do
    room = @rooms[type]

    cond do
      y == @hall && diagram[{room, @bottom}] == :free -> [move(diagram, pos, {room, @bottom})]
      y == @hall && diagram[{room, @top}] == :free -> [move(diagram, pos, {room, @top})]
      y == @hall -> []
      true -> hall_moves(diagram, pos)
    end
  end

  defp move(diagram, source, dest) do
    {diagram |> Map.put(dest, diagram[source]) |> Map.put(source, :free),
     energy(diagram, source, dest)}
  end

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
    abs(x1 + x2) + abs(y1 + y2)
  end

  defp rooms_filled?(diagram) do
    for(x <- room_indexes(), y <- [@top, @bottom], do: {x, y})
    |> Enum.all?(fn {x, y} -> @rooms[diagram[{x, y}]] == x end)
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
