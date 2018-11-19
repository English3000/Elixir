defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: [ [integer] ]
  def matrix(dimension) do
    low  = 1
    high = dimension

    head = Enum.reduce(low..high, {}, &Tuple.append(&2, &1))

    multiple = low + 1
    new_low  = low + high
    new_high = high * multiple - 1

    tail = Enum.reduce( new_low..new_high, {}, &Tuple.append(&2, Tuple.duplicate(&1, dimension)) )

    table = Tuple.insert_at(tail, 0, head)

    left(table, new_high + 1, new_high * (multiple + 1) - multiple, dimension)
  end

  defp left(table, low, high, dimension) do
    #
  end

  defp up

  defp right

  defp down

  # traverse by dimension (right)
  # traverse by dimension - 1 (down)
  # traverse by dimension - 1 (left)
  # traverse by dimension - 2 (up)
  # traverse by dimension - 2 (right)
  # ...
  # traverse by 0
end
