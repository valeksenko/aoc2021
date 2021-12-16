defmodule AoC2021.Day16.Parser do
  import NimbleParsec

  @bit [?0, ?1]

  byte = ascii_string(@bit, 4)
  zero = ascii_char([?0])
  one = ascii_char([?1])

  version =
    ascii_string(@bit, 3)
    |> reduce({:to_integer, []})
    |> tag(:version)

  op =
    ascii_string(@bit, 3)
    |> reduce({:to_integer, []})
    |> tag(:op)

  packet_operator =
    ignore(one)
    |> ascii_string(@bit, 11)
    |> reduce({:to_integer, []})
    |> tag(:packet_length)

  bit_operator =
    ignore(zero)
    |> ascii_string(@bit, 15)
    |> reduce({:to_integer, []})
    |> tag(:bit_length)

  operator =
    op
    |> choice([
      bit_operator,
      packet_operator
    ])

  literal =
    ignore(one |> concat(zero) |> concat(zero))
    |> repeat(
      ignore(one)
      |> concat(byte)
    )
    |> ignore(zero)
    |> concat(byte)
    |> wrap
    |> reduce({:to_integer, []})
    |> tag(:literal)

  packet =
    version
    |> choice([
      literal,
      operator
    ])

  defparsec(:packet_parser, packet)

  def parse_packets(data) do
    data
    |> packet_parser
    |> to_packet
    |> elem(1)
  end

  defp to_integer(bits) do
    bits
    |> List.flatten()
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp get_packets({bits, packets}) do
    {reminder, parsed} = bits |> packet_parser |> to_packet

    {reminder, [parsed | packets]}
  end

  defp to_packet({:ok, [version: [version], literal: [literal]], reminder, _, _, _}),
    do: {reminder, {version, {:literal, literal}}}

  defp to_packet({:ok, [version: [version], op: [op], bit_length: [size]], reminder, _, _, _}) do
    {to_parse, final} = reminder |> String.split_at(size)

    {_, subpackets} =
      {to_parse, []}
      |> Stream.iterate(&get_packets/1)
      |> Stream.drop_while(fn {bits, _} -> String.length(bits) > 0 end)
      |> Enum.take(1)
      |> hd

    {final, {version, {:op, op, Enum.reverse(subpackets)}}}
  end

  defp to_packet({:ok, [version: [version], op: [op], packet_length: [size]], reminder, _, _, _}) do
    {final, subpackets} =
      0..(size - 1)
      |> Enum.reduce({reminder, []}, fn _, input -> get_packets(input) end)

    {final, {version, {:op, op, Enum.reverse(subpackets)}}}
  end
end
