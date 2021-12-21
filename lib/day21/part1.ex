defmodule AoC2021.Day21.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/21

    There's not much to do as you slowly descend to the bottom of the ocean. The submarine computer challenges you to a nice game of Dirac Dice.

    This game consists of a single die, two pawns, and a game board with a circular track containing ten spaces marked 1 through 10 clockwise. Each player's starting space is chosen randomly (your puzzle input). Player 1 goes first.

    Players take turns moving. On each player's turn, the player rolls the die three times and adds up the results. Then, the player moves their pawn that many times forward around the track (that is, moving clockwise on spaces in order of increasing value, wrapping back around to 1 after 10). So, if a player is on space 7 and they roll 2, 2, and 1, they would move forward 5 times, to spaces 8, 9, 10, 1, and finally stopping on 2.

    After each player moves, they increase their score by the value of the space their pawn stopped on. Players' scores start at 0. So, if the first player starts on space 7 and rolls a total of 5, they would stop on space 2 and add 2 to their score (for a total score of 2). The game immediately ends as a win for any player whose score reaches at least 1000.

    Since the first game is a practice game, the submarine opens a compartment labeled deterministic dice and a 100-sided die falls out. This die always rolls 1 first, then 2, then 3, and so on up to 100, after which it starts over at 1 again. Play using this die.

    Play a practice game using the deterministic 100-sided die. The moment either player wins, what do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?
  """
  @behaviour AoC2021.Day

  @win 1000

  @impl AoC2021.Day
  def run(data) do
    data
    |> to_game
    |> play
  end

  defp play({{player1, player2}, die}) do
    {score1, pos1, die} = turn(player1, die)

    if score1 >= @win do
      result(player2, die)
    else
      {score2, pos2, die} = turn(player2, die)

      if score2 >= @win,
        do: result({score1, pos1}, die),
        else: play({{{score1, pos1}, {score2, pos2}}, die})
    end
  end

  defp result({score, _}, {_, count}), do: score * count

  defp turn({score, pos}, die) do
    {die, rolls} = roll(die)

    move = rem(pos - 1 + rolls, 10) + 1
    {score + move, move, die}
  end

  defp roll({die, count}) do
    rolls =
      1..3
      |> Enum.map(&(rem(die - 1 + &1, 100) + 1))

    {{List.last(rolls), count + 3}, Enum.sum(rolls)}
  end

  defp to_game(data) do
    players =
      data
      |> Enum.map(fn l -> l |> String.split(": ") |> List.last() |> String.to_integer() end)
      |> Enum.map(&{0, &1})
      |> List.to_tuple()

    {players, {0, 0}}
  end
end
