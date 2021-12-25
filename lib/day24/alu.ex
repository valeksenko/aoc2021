defmodule AoC2021.Day24.ALU do
  defmodule Instruction do
    @enforce_keys [:op, :arguments]
    defstruct @enforce_keys
  end

  def exec(code, input) do
    code
    |> Enum.reduce({input, %{"w" => 0, "x" => 0, "y" => 0, "z" => 0}}, &exec_op/2)
  end

  defp exec_op(%Instruction{op: "inp", arguments: {var}}, {[number | input], vars}) do
    {input, Map.replace!(vars, var, number)}
  end

  defp exec_op(%Instruction{op: "add", arguments: {var, arg}}, {input, vars}) do
    {input, Map.update!(vars, var, &(&1 + argument(arg, vars)))}
  end

  defp exec_op(%Instruction{op: "mul", arguments: {var, arg}}, {input, vars}) do
    {input, Map.update!(vars, var, &(&1 * argument(arg, vars)))}
  end

  defp exec_op(%Instruction{op: "div", arguments: {var, arg}}, {input, vars}) do
    {input, Map.update!(vars, var, &div(&1, argument(arg, vars)))}
  end

  defp exec_op(%Instruction{op: "mod", arguments: {var, arg}}, {input, vars}) do
    {input, Map.update!(vars, var, &rem(&1, argument(arg, vars)))}
  end

  defp exec_op(%Instruction{op: "eql", arguments: {var, arg}}, {input, vars}) do
    {input, Map.put(vars, var, if(vars[var] == argument(arg, vars), do: 1, else: 0))}
  end

  defp argument(arg, _) when is_number(arg), do: arg
  defp argument(arg, vars), do: vars[arg]
end
