defmodule AoC2021.Day24.Part1 do
  @moduledoc """
    @see https://adventofcode.com/2021/day/24

    Magic smoke starts leaking from the submarine's arithmetic logic unit (ALU). Without the ability to perform basic arithmetic and logic functions, the submarine can't produce cool patterns with its Christmas lights!

    It also can't navigate. Or run the oxygen system.

    Don't worry, though - you probably have enough oxygen left to give you enough time to build a new ALU.

    The ALU is a four-dimensional processing unit: it has integer variables w, x, y, and z. These variables all start with the value 0. The ALU also supports six instructions:

    inp a - Read an input value and write it to variable a.
    add a b - Add the value of a to the value of b, then store the result in variable a.
    mul a b - Multiply the value of a by the value of b, then store the result in variable a.
    div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
    mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
    eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
    In all of these instructions, a and b are placeholders; a will always be the variable where the result of the operation is stored (one of w, x, y, or z), while b can be either a variable or a number. Numbers can be positive or negative, but will always be integers.

    The ALU has no jump instructions; in an ALU program, every instruction is run exactly once in order from top to bottom. The program halts after the last instruction has finished executing.

    (Program authors should be especially cautious; attempting to execute div with b=0 or attempting to execute mod with a<0 or b<=0 will cause the program to crash and might even damage the ALU. These operations are never intended in any serious ALU program.)

    Once you have built a replacement ALU, you can install it in the submarine, which will immediately resume what it was doing when the ALU failed: validating the submarine's model number. To do this, the ALU will run the MOdel Number Automatic Detector program (MONAD, your puzzle input).

    Submarine model numbers are always fourteen-digit numbers consisting only of digits 1 through 9. The digit 0 cannot appear in a model number.

    When MONAD checks a hypothetical fourteen-digit model number, it uses fourteen separate inp instructions, each expecting a single digit of the model number in order of most to least significant. (So, to check the model number 13579246899999, you would give 1 to the first inp instruction, 3 to the second inp instruction, 5 to the third inp instruction, and so on.) This means that when operating MONAD, each input instruction should only ever be given an integer value of at least 1 and at most 9.

    Then, after MONAD has finished running all of its instructions, it will indicate that the model number was valid by leaving a 0 in variable z. However, if the model number was invalid, it will leave some other non-zero value in z.

    MONAD imposes additional, mysterious restrictions on model numbers, and legend says the last copy of the MONAD documentation was eaten by a tanuki. You'll need to figure out what MONAD does some other way.

    To enable as many submarine features as possible, find the largest valid fourteen-digit model number that contains no 0 digits. What is the largest model number accepted by MONAD?
  """
  import AoC2021.Day24.Parser
  import AoC2021.Day24.ALU

  @behaviour AoC2021.Day

  @impl AoC2021.Day
  def run(data) do
    code = parse_code(data)

    {0, [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9]}
    |> Stream.iterate(&next/1)
    |> Stream.drop_while(&invalid?(&1, code))
    |> Enum.take(1)
    |> hd
    |> elem(1)
    |> Enum.join()
    |> String.to_integer()
  end

  defp invalid?({count, digits}, code) do
    variables = code |> exec(digits) |> elem(1)

    if rem(count, 100_000) == 0, do: IO.inspect({digits, variables})

    0 != Map.get(variables, "z")
  end

  defp next({count, prev}) do
    num = (prev |> Enum.join() |> String.to_integer()) - 1
    digits = num |> Integer.digits()

    if num |> Integer.to_string() |> String.contains?("0"),
      do: next({count + 1, digits}),
      else: {count + 1, digits}
  end
end
