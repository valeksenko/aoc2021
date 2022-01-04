defmodule AoC2021.Day19.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/19

      The beacons and scanners float motionless in the water; they're designed to maintain the same position for long periods of time. Each scanner is capable of detecting all beacons in a large cube centered on the scanner; beacons that are at most 1000 units away from the scanner in each of the three axes (x, y, and z) have their precise position determined relative to the scanner. However, scanners cannot detect other scanners. The submarine has automatically summarized the relative positions of beacons detected by each scanner (your puzzle input).

      For example, if a scanner is at x,y,z coordinates 500,0,-500 and there are beacons at -500,1000,-1500 and 1501,0,-500, the scanner could report that the first beacon is at -1000,1000,-1000 (relative to the scanner) but would not detect the second beacon at all.

      Unfortunately, while each scanner can report the positions of all detected beacons relative to itself, the scanners do not know their own position. You'll need to determine the positions of the beacons and scanners yourself.

      The scanners and beacons map a single contiguous 3d region. This region can be reconstructed by finding pairs of scanners that have overlapping detection regions such that there are at least 12 beacons that both scanners detect within the overlap. By establishing 12 common beacons, you can precisely determine where the scanners are relative to each other, allowing you to reconstruct the beacon map one scanner at a time.

      Assemble the full map of beacons. How many beacons are there?
  """
  import AoC2021.Day19.Parser

  @min_beacons 12

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    data
    |> parse_scans
    |> all_beacons
  end

  defp all_beacons(scans) do
    matches =
      scans
      |> Enum.map(&beacon_distances/1)
      |> overlapping_scans

    %{0 => hd(scans)}
    |> Stream.iterate(&match_scans(&1, scans, matches))
    |> Stream.drop_while(&(map_size(&1) != length(scans)))
    |> Enum.take(1)
    |> hd()
    |> Map.values()
    |> Enum.concat()
    |> Enum.sort()
    |> Enum.dedup()
    |> length()
  end

  defp match_scans(matched, scans, matches) do
    matches
    |> Enum.filter(fn {{i1, _}, {i2, _}} ->
      (Map.has_key?(matched, i1) and not Map.has_key?(matched, i2)) or
        (Map.has_key?(matched, i2) and not Map.has_key?(matched, i1))
    end)
    |> Enum.reduce(matched, fn {{i1, b1}, {i2, b2}}, m ->
      if Map.has_key?(matched, i1),
        do: Map.put(m, i2, rotate_scan(Enum.at(scans, i2), matched[i1], b2, b1)),
        else: Map.put(m, i1, rotate_scan(Enum.at(scans, i1), matched[i2], b1, b2))
    end)
  end

  defp rotate(rotation, pos) do
    rotation
    |> Enum.reduce(pos, fn r, p -> r.(p) end)
  end

  defp rotate_scan(scan1, scan2, b1, b2) do
    rotation =
      match_rotation(b1 |> Enum.map(&Enum.at(scan1, &1)), b2 |> Enum.map(&Enum.at(scan2, &1)))

    scanner = diff(rotate(rotation, Enum.at(scan1, hd(b1))), Enum.at(scan2, hd(b2)))

    scan1
    |> Enum.map(&diff(rotate(rotation, &1), scanner))
  end

  defp match_rotation(from, to) do
    rotation_matrix()
    |> Enum.find(&match_rotation?(&1, from, to))
  end

  defp match_rotation?(rotation, from, to) do
    matched =
      Enum.zip(from, to)
      |> Enum.map(fn {f, t} -> diff(t, rotate(rotation, f)) end)
      |> Enum.dedup()
      |> length()

    matched == 1
  end

  defp diff({x1, y1, z1}, {x2, y2, z2}), do: {x1 - x2, y1 - y2, z1 - z2}

  defp overlapping_scans(scans) do
    for(
      s1 <- 0..(length(scans) - 2),
      s2 <- (s1 + 1)..(length(scans) - 1),
      do: {{s1, Enum.at(scans, s1)}, {s2, Enum.at(scans, s2)}}
    )
    |> Enum.map(&overlapping_beacons/1)
    |> Enum.filter(fn {{_, b}, _} -> length(b) >= @min_beacons end)
  end

  defp overlapping_beacons({{i1, scan1}, {i2, scan2}}) do
    {b1, b2} =
      scan1
      |> Enum.map(fn {i, b} -> {i, overlapping_beacon(b, scan2)} end)
      |> Enum.filter(fn {_, b} -> b != :none end)
      |> Enum.unzip()

    {{i1, b1}, {i2, b2}}
  end

  defp overlapping_beacon(beacons, scan) do
    case Enum.find(scan, &(overlapping(&1, beacons) >= @min_beacons - 1)) do
      nil -> :none
      {i, _} -> i
    end
  end

  defp overlapping({_, beacons1}, beacons2) do
    length(beacons1) -
      length((beacons1 |> Enum.map(&elem(&1, 1))) -- (beacons2 |> Enum.map(&elem(&1, 1))))
  end

  defp roll({x, y, z}), do: {x, z, -y}

  defp turn({x, y, z}), do: {-y, x, z}

  defp rotation_matrix do
    rotations = [&roll/1, &turn/1, &turn/1, &turn/1]

    for c <- [[], [&roll/1, &turn/1, &roll/1]],
        s <- [[], rotations, rotations ++ rotations],
        r <- [&roll/1],
        t <- [[], [&turn/1], [&turn/1, &turn/1], [&turn/1, &turn/1, &turn/1]],
        do: c ++ s ++ [r | t]
  end

  defp beacon_distances(scan) do
    for b1 <- 0..(length(scan) - 1), b2 <- 0..(length(scan) - 1), b1 != b2 do
      d = distance(Enum.at(scan, b1), Enum.at(scan, b2))
      [{b1, {b2, d}}, {b2, {b1, d}}]
    end
    |> List.flatten()
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end
end
