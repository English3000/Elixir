defmodule Recursion do
  @doc """
  Given an integer, write a function to determine if it is a power of two.
  """

  def power_of?(num, base, exp \\ 0) do
    if abs(base) == 1 or base == 0 do
      if abs(num) == base do
        IO.puts true
      else
        IO.puts false
      end
    else
      cond do
        abs(num) < abs(:math.pow(base, exp)) -> IO.puts false
        abs(num) == abs(:math.pow(base, exp)) -> IO.puts true
        abs(num) > abs(:math.pow(base, exp)) -> power_of?(num, base, exp + 1)
      end
    end
  end
end

Recursion.power_of?(2, 2)
Recursion.power_of?(3, 2)
Recursion.power_of?(4, 2)
Recursion.power_of?(2, -1)
