defmodule AoC2021.Day16.Part2 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/16#part2

    Now that you have the structure of your transmission decoded, you can calculate the value of the expression it represents.

    Literal values (type ID 4) represent a single number as described above. The remaining type IDs are more interesting:

    Packets with type ID 0 are sum packets - their value is the sum of the values of their sub-packets. If they only have a single sub-packet, their value is the value of the sub-packet.
    Packets with type ID 1 are product packets - their value is the result of multiplying together the values of their sub-packets. If they only have a single sub-packet, their value is the value of the sub-packet.
    Packets with type ID 2 are minimum packets - their value is the minimum of the values of their sub-packets.
    Packets with type ID 3 are maximum packets - their value is the maximum of the values of their sub-packets.
    Packets with type ID 5 are greater than packets - their value is 1 if the value of the first sub-packet is greater than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
    Packets with type ID 6 are less than packets - their value is 1 if the value of the first sub-packet is less than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
    Packets with type ID 7 are equal to packets - their value is 1 if the value of the first sub-packet is equal to the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
    Using these rules, you can now work out the value of the outermost packet in your BITS transmission.
    What do you get if you evaluate the expression represented by your hexadecimal-encoded BITS transmission?
  """
  import AoC2021.Day16.Parser

  @behaviour AoC2021.Day

  @sum 0
  @prod 1
  @min 2
  @max 3
  @gt 5
  @lt 6
  @equal 7

  @impl AoC2021.Day
  def run(data) do
    data
    |> hd
    |> calculate
  end

  def calculate(data) do
    data
    |> String.graphemes()
    |> Enum.map(&to_bits/1)
    |> Enum.join()
    |> parse_packets
    |> exec
  end

  defp exec({_, {:literal, number}}), do: number

  defp exec({_, {:op, @sum, subpackets}}),
    do: subpackets |> Enum.map(&exec/1) |> Enum.sum()

  defp exec({_, {:op, @prod, subpackets}}),
    do: subpackets |> Enum.map(&exec/1) |> Enum.product()

  defp exec({_, {:op, @min, subpackets}}),
    do: subpackets |> Enum.map(&exec/1) |> Enum.min()

  defp exec({_, {:op, @max, subpackets}}),
    do: subpackets |> Enum.map(&exec/1) |> Enum.max()

  defp exec({_, {:op, @gt, subpackets}}) do
    [n1, n2] = subpackets |> Enum.map(&exec/1)
    if n1 > n2, do: 1, else: 0
  end

  defp exec({_, {:op, @lt, subpackets}}) do
    [n1, n2] = subpackets |> Enum.map(&exec/1)
    if n1 < n2, do: 1, else: 0
  end

  defp exec({_, {:op, @equal, subpackets}}) do
    [n1, n2] = subpackets |> Enum.map(&exec/1)
    if n1 == n2, do: 1, else: 0
  end

  defp to_bits(hex) do
    hex
    |> String.to_integer(16)
    |> Integer.to_string(2)
    |> String.pad_leading(4, "0")
  end
end
