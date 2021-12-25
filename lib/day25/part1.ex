defmodule AoC2021.Day25.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/25

    This is it: the bottom of the ocean trench, the last place the sleigh keys could be. Your submarine's experimental antenna still isn't boosted enough to detect the keys, but they must be here. All you need to do is reach the seafloor and find them.

    At least, you'd touch down on the seafloor if you could; unfortunately, it's completely covered by two large herds of sea cucumbers, and there isn't an open space large enough for your submarine.

    You suspect that the Elves must have done this before, because just then you discover the phone number of a deep-sea marine biologist on a handwritten note taped to the wall of the submarine's cockpit.

    "Sea cucumbers? Yeah, they're probably hunting for food. But don't worry, they're predictable critters: they move in perfectly straight lines, only moving forward when there's space to do so. They're actually quite polite!"

    You explain that you'd like to predict when you could land your submarine.

    "Oh that's easy, they'll eventually pile up and leave enough space for-- wait, did you say submarine? And the only place with that many sea cucumbers would be at the very bottom of the Mariana--" You hang up the phone.

    There are two herds of sea cucumbers sharing the same region; one always moves east (>), while the other always moves south (v). Each location can contain at most one sea cucumber; the remaining locations are empty (.). The submarine helpfully generates a map of the situation (your puzzle input).

    Due to strong water currents in the area, sea cucumbers that move off the right edge of the map appear on the left edge, and sea cucumbers that move off the bottom edge of the map appear on the top edge. Sea cucumbers always check whether their destination location is empty before moving, even if that destination is on the opposite side of the map

    To find a safe place to land your submarine, the sea cucumbers need to stop moving. Find somewhere safe to land your submarine. What is the first step on which no sea cucumbers move?
  """
  @behaviour AoC2021.Day

  defstruct [:map, :x_size, :y_size, :history]

  alias __MODULE__, as: State

  @east ">"
  @south "v"
  @free "."

  @impl AoC2021.Day
  def run(data) do
    %State{
      map: to_map(data),
      x_size: String.length(data |> hd),
      y_size: length(data),
      history: []
    }
    |> Stream.iterate(&step/1)
    |> Stream.with_index()
    |> Stream.drop_while(fn {state, _} -> state.map not in state.history end)
    |> Enum.take(1)
    |> hd
    |> elem(1)
  end

  defp step(state) do
    [@east, @south]
    |> Enum.reduce(%{state | history: [state.map | state.history]}, fn t, s ->
      %{s | map: move(t, s)}
    end)
  end

  defp move(type, state) do
    state.map
    |> Enum.filter(fn {_, t} -> t == type end)
    |> Enum.reduce(state.map, fn {pos, _}, m ->
      new = next(pos, type, state)
      m |> Map.put(pos, @free) |> Map.put(new, type)
    end)
  end

  defp next({x, y}, @east, state) do
    pos = {rem(x + 1, state.x_size), y}

    if state.map[pos] == @free, do: pos, else: {x, y}
  end

  defp next({x, y}, @south, state) do
    pos = {x, rem(y + 1, state.y_size)}

    if state.map[pos] == @free, do: pos, else: {x, y}
  end

  defp to_map(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), &add_row/2)
  end

  defp add_row({row, y}, map) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {v, x}, m -> Map.put(m, {x, y}, v) end)
  end

  defp inspect_state(state) do
    for y <- 0..(state.y_size - 1) do
      for x <- 0..(state.x_size - 1), do: IO.binwrite(state.map[{x, y}])

      IO.binwrite("\n")
    end

    IO.binwrite("\n")

    state
  end
end
