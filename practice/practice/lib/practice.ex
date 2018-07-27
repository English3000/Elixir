defmodule Practice do
  @doc """
  Time complexity = L, length of list (except, appending to a list takes L too)
                  * F, time complexity of function

  So, func is called length(list) times (F * L).
  Additionally, call/3 is called L+1 times.
    Each time call/3 is called, F is called, then appended to output (takes O, length of output = (L/2)^2 I think).
    These are not nested but rather sequential.
  So time complexity reduces to the greater of (F * L) or (L^2 * L / 4)

  For an array (in another language), mapping would take (F * L)


  Auxiliary space = length of list? (that's the longest output will ever be)
  Space complexity = (L + L) or F

  These would certainly be the case with mutating an array... but with a call stack,
  each recursive call takes another layer of memory??

  https://www.geeksforgeeks.org/auxiliary-space-recursive-functions/

  Stack space in recursive calls counts too as extra space required by a program.

  ...passing arguments recursively instead of mutating them iteratively takes A LOT more space
  UNLESS you use tail-recursion: https://stackoverflow.com/questions/310974/what-is-tail-call-optimization
  """

  # body-call, space complexity would be L + 1 recursive calls * (L + 1 + F's space) of inputs
    # could do an @spec for each
  # def map([], _func), do: []
  # def map([ head | tail ], func), do: [ func.(head) | map(tail, func) ]

  # tail-call
  @spec map([any], (... -> any)) :: [any]
  def map(list, func), do: call([], list, func)

  defp call(output, [], _func), do: output
  defp call(output, [ head | tail ], func) do
    call(output ++ [ func.(head) ], tail, func)
  end
end
