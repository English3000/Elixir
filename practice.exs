defmodule Practice do
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

  @doc """
  Given a linked list whose nodes have data in ascending order, delete some nodes so that no value occurs more than once.
  """
  def delete_dups(list) do
    list
    |> Enum.with_index
    |> Enum.map(fn({value, index}) ->
         first = Enum.find_index(list, fn x -> x == value end)
         case first == index do
           true  -> value
           false -> []
         end
       end)
    |> List.flatten # any way to solve w/o this call?
  end
end

# Practice.power_of?(2, 2)
# Practice.power_of?(3, 2)
# Practice.power_of?(4, 2)
# Practice.power_of?(2, -1)

# IO.puts Practice.delete_dups([1,1,1,2]) == [1, 2]
