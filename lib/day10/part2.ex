defmodule AoC2021.Day10.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/10#part2

    Now, discard the corrupted lines. The remaining lines are incomplete.

    Incomplete lines don't have any incorrect characters - instead, they're missing some closing characters at the end of the line. To repair the navigation subsystem, you just need to figure out the sequence of closing characters that complete all open chunks in the line.

    You can only use closing characters (), ], }, or >), and you must add them in the correct order so that only legal pairs are formed and all chunks end up closed.

    Did you know that autocomplete tools also have contests? It's true! The score is determined by considering the completion string character-by-character. Start with a total score of 0. Then, for each character, multiply the total score by 5 and then increase the total score by the point value given for the character in the following table:

    ): 1 point.
    ]: 2 points.
    }: 3 points.
    >: 4 points.
    So, the last completion string above - ])}> - would be scored as follows:

    Start with a total score of 0.
    Multiply the total score by 5 to get 0, then add the value of ] (2) to get a new total score of 2.
    Multiply the total score by 5 to get 10, then add the value of ) (1) to get a new total score of 11.
    Multiply the total score by 5 to get 55, then add the value of } (3) to get a new total score of 58.
    Multiply the total score by 5 to get 290, then add the value of > (4) to get a new total score of 294.

    Autocomplete tools are an odd bunch: the winner is found by sorting all of the scores and then taking the middle score. (There will always be an odd number of scores to consider.) In this example, the middle score is 288957 because there are the same number of scores smaller and larger than it.

    Find the completion string for each incomplete line, score the completion strings, and sort the scores. What is the middle score?
  """
  @behaviour AoC2021.Day

  @closing [")", "]", "}", ">"]

  @opening %{
    ")" => "(",
    "]" => "[",
    "}" => "{",
    ">" => "<"
  }

  @points %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  @impl AoC2021.Day
  def run(data) do
    data
    |> Enum.map(&String.graphemes/1)
    |> Enum.reject(&illegal?/1)
    |> Enum.map(&score/1)
    |> final_score
  end

  defp final_score(scores) do
    scores
    |> Enum.sort()
    |> Enum.drop(trunc(length(scores) / 2))
    |> hd
  end

  defp score(line) do
    line
    |> Enum.reduce_while([], &process/2)
    |> Enum.reduce(0, &calculate/2)
  end

  defp calculate(o, total) do
    total * 5 + Map.get(@points, o)
  end

  defp illegal?(line) do
    Enum.reduce_while(line, [], &process/2) == :illegal
  end

  defp process(c, [o | stack]) when c in @closing do
    if o == Map.get(@opening, c), do: {:cont, stack}, else: {:halt, :illegal}
  end

  defp process(c, stack), do: {:cont, [c | stack]}
end
