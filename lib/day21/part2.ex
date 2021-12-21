defmodule AoC2021.Day21.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/21#part2

    Now that you're warmed up, it's time to play the real game.

    A second compartment opens, this time labeled Dirac dice. Out of it falls a single three-sided die.

    As you experiment with the die, you feel a little strange. An informational brochure in the compartment explains that this is a quantum die: when you roll it, the universe splits into multiple copies, one copy for each possible outcome of the die. In this case, rolling the die always splits the universe into three copies: one where the outcome of the roll was 1, one where it was 2, and one where it was 3.

    The game is played the same as before, although to prevent things from getting too far out of hand, the game now ends when either player's score reaches at least 21.

    Using your given starting positions, determine every possible outcome. Find the player that wins in more universes; in how many universes does that player win?
  """
  @behaviour AoC2021.Day

  @win 21

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_game
    |> play
  end

  defp play({{player1, player2}, count1, count2}) do
    {wins, ongoing1} = turn(player1) |> Enum.split_with(&win?/1)
    count1 = count1 + length(wins)

    if Enum.empty?(ongoing1) do
      {count1, count2}
    else
      {wins, ongoing2} = turn(player2) |> Enum.split_with(&win?/1)
      count2 = count2 + length(wins)

      if Enum.empty?(ongoing2),
        do: {count1, count2},
        else: play_all(ongoing1, ongoing2, count1, count2)
    end
  end

  defp play_all(games1, games2, count1, count2) do
    for(player1 <- games1, player2 <- games2, do: {player1, player2})
    |> Enum.map(&play({&1, count1, count2}))
    |> Enum.reduce(fn {c1, c2}, {t1, t2} -> {c1 + t1, c2 + t2} end)
  end

  defp win?({score, _}), do: score >= @win

  defp turn(player) do
    for(r1 <- 1..3, r2 <- 1..3, r3 <- 1..3, do: r1 + r2 + r3)
    |> Enum.map(&next(player, &1))
  end

  defp next({score, pos}, rolls) do
    move = rem(pos - 1 + rolls, 10) + 1
    {score + move, move}
  end

  defp to_game(data) do
    players =
      data
      |> Enum.map(fn l -> l |> String.split(": ") |> List.last() |> String.to_integer() end)
      |> Enum.map(&{0, &1})
      |> List.to_tuple()

    {players, 0, 0}
  end
end
