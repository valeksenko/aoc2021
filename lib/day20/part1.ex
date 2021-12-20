defmodule AoC2021.Day20.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/20

    With the scanners fully deployed, you turn their attention to mapping the floor of the ocean trench.

    When you get back the image from the scanners, it seems to just be random noise. Perhaps you can combine an image enhancement algorithm and the input image (your puzzle input) to clean it up a little.

    The first section is the image enhancement algorithm. It is normally given on a single line, but it has been wrapped to multiple lines in this example for legibility. The second section is the input image, a two-dimensional grid of light pixels (#) and dark pixels (.).

    The image enhancement algorithm describes how to enhance an image by simultaneously converting all pixels in the input image into an output image. Each pixel of the output image is determined by looking at a 3x3 square of pixels centered on the corresponding input image pixel. So, to determine the value of the pixel at (5,10) in the output image, nine pixels from the input image need to be considered: (4,9), (4,10), (4,11), (5,9), (5,10), (5,11), (6,9), (6,10), and (6,11). These nine input pixels are combined into a single binary number that is used as an index in the image enhancement algorithm string.

    For example, to determine the output pixel that corresponds to the very middle pixel of the input image, the nine pixels marked by [...] would need to be considered:

    # . . # .
    #[. . .].
    #[# . .]#
    .[. # .].
    . . # # #
    Starting from the top-left and reading across each row, these pixels are ..., then #.., then .#.; combining these forms ...#...#.. By turning dark pixels (.) into 0 and light pixels (#) into 1, the binary number 000100010 can be formed, which is 34 in decimal.

    The image enhancement algorithm string is exactly 512 characters long, enough to match every possible 9-bit binary number. The first few characters of the string (numbered starting from zero) are as follows:

    0         10        20        30  34    40        50        60        70
    |         |         |         |   |     |         |         |         |
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
    In the middle of this first group of characters, the character at index 34 can be found: #. So, the output pixel in the center of the output image should be #, a light pixel.

    This process can then be repeated to calculate every pixel of the output image.

    Through advances in imaging technology, the images being operated on here are infinite in size. Every pixel of the infinite output image needs to be calculated exactly based on the relevant pixels of the input image. The small input image you have is only a small region of the actual infinite input image; the rest of the input image consists of dark pixels (.). For the purposes of the example, to save on space, only a portion of the infinite-sized input and output images will be shown.

    Truly incredible - now the small details are really starting to come through. After enhancing the original input image twice, 35 pixels are lit.

    Start with the original input image and apply the image enhancement algorithm twice, being careful to account for the infinite size of the images. How many pixels are lit in the resulting image?
  """
  @behaviour AoC2021.Day

  defstruct [:algorithm, :image, :size, :default]

  alias __MODULE__, as: State

  @times 2
  @dark "."
  @light "#"
  @mapping %{
    @dark => 0,
    @light => 1
  }

  @impl AoC2021.Day
  def run([algorithm | data]) do
    %State{
      algorithm: algorithm |> String.graphemes(),
      image: to_map(data),
      size: length(data),
      default: default_pixel(algorithm)
    }
    |> enhance(0)
    |> Enum.count(&(&1 == @light))
  end

  defp default_pixel(algorithm) do
    if String.first(algorithm) == @light,
      do: {String.last(algorithm), String.first(algorithm)},
      else: {@dark, @dark, @dark}
  end

  defp enhance(state, @times), do: state.image |> Map.values()

  defp enhance(state, times) do
    enhance(
      %{
        state
        | image: positions(state, times) |> Enum.reduce(%{}, &enhance_pixel(&1, state, times, &2))
      },
      times + 1
    )
  end

  defp enhance_pixel(pos, state, times, image) do
    index =
      neighbors(pos)
      |> Enum.map(&Map.get(state.image, &1, state.default |> elem(times |> rem(2))))
      |> Enum.map(&@mapping[&1])
      |> Enum.join()
      |> String.to_integer(2)

    image |> Map.put(pos, Enum.at(state.algorithm, index))
  end

  defp positions(state, times) do
    for x <- (-times - 1)..(state.size + times),
        y <- (-times - 1)..(state.size + times),
        do: {x, y}
  end

  defp neighbors({x, y}) do
    for yd <- -1..1, xd <- -1..1, do: {x + xd, y + yd}
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
    {min, max} =
      state.image
      |> Map.keys()
      |> Enum.min_max_by(fn {x, _} -> x end)
      |> (fn {{xmin, _}, {xmax, _}} -> {xmin, xmax} end).()

    for y <- min..max do
      for x <- min..max,
          do: IO.binwrite(state.image[{x, y}])

      IO.binwrite("\n")
    end

    IO.binwrite("\n")

    state
  end
end
