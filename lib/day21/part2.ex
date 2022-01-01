defmodule AoC2021.Day21.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/21#part2

    Now that you're warmed up, it's time to play the real game.

    A second compartment opens, this time labeled Dirac dice. Out of it falls a single three-sided die.

    As you experiment with the die, you feel a little strange. An informational brochure in the compartment explains that this is a quantum die: when you roll it, the universe splits into multiple copies, one copy for each possible outcome of the die. In this case, rolling the die always splits the universe into three copies: one where the outcome of the roll was 1, one where it was 2, and one where it was 3.

    The game is played the same as before, although to prevent things from getting too far out of hand, the game now ends when either position's score reaches at least 21.

    Using your given starting positions, determine every possible outcome. Find the position that wins in more universes; in how many universes does that position win?
  """
  @behaviour AoC2021.Day

  @win 21

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_game()
    |> play()
    |> Tuple.to_list()
    |> Enum.max()
  end

  defp play({position1, position2}) do
    wins({position1, @win}, {position2, @win})
  end

  defp wins({_, _}, {_, n}) when n <= 0, do: {0, 1}

  defp wins(game1, game2) do
    rolls()
    |> Enum.reduce({0, 0}, &turn(&1, &2, game1, game2))
  end

  defp turn({points, amount}, {total1, total2}, {position1, score1}, game2) do
    move = rem(position1 - 1 + points, 10) + 1
    {count2, count1} = wins(game2, {move, score1 - move})

    {total1 + amount * count1, total2 + amount * count2}
  end

  defp rolls do
    for(r1 <- 1..3, r2 <- 1..3, r3 <- 1..3, do: r1 + r2 + r3)
    |> Enum.frequencies()
  end

  defp to_game(data) do
    data
    |> Enum.map(fn l -> l |> String.split(": ") |> List.last() |> String.to_integer() end)
    |> List.to_tuple()
  end
end
