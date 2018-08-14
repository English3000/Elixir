# Introduction
# The Collatz Conjecture or 3x+1 problem can be summarized as follows:
#
# Take any positive integer n. If n is even, divide n by 2 to get n / 2. If n is
#
# odd, multiply n by 3 and add 1 to get 3n + 1. Repeat the process indefinitely.
#
# The conjecture states that no matter which number you start with, you will
#
# always reach 1 eventually.
#
# Given a number n, return the number of steps required to reach 1.
#
# Examples
# Starting with n = 12, the steps would be as follows:
#
# 12
#
# 6
#
# 3
#
# 10
#
# 5
#
# 16
#
# 8

defmodule RealReal.Collatz do
  # @spec conjecture(integer) :: integer
  def conjecture(n), do: conjecture(n, 0)

  defp conjecture(1, steps), do: steps
  defp conjecture(n, steps) when n > 0 and rem(n/2) == 0,
    do: conjecture(n/2, steps + 1)
  defp conjecture(n, steps) when n > 0 and rem(n/2) == 1, 

  defp conjecture(n, steps) when is_number(n) and n > 0 do
    cond do
      n == 1 -> steps
      trunc(n) |> rem(2) == 0 -> conjecture(n/2, steps + 1)
      true -> conjecture(3 * n + 1, steps + 1)
    end
  end
end
