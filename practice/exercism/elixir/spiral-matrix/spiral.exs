defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: [ [integer] ]
  def matrix(dimension) do
    table = nil
            |> Tuple.duplicate(dimension)
            |> Tuple.duplicate(dimension)

    traverse(table, :right, {0,0}, 1, dimension, true)
    |> Tuple.to_list
    |> Enum.map(&Tuple.to_list(&1))
    # low  = 1
    # high = dimension
    #
    # head = Enum.reduce(low..high, {}, &Tuple.append(&2, &1))
    #
    # multiple = low + 1
    # new_low  = low + high
    # new_high = high * multiple - 1
    #
    # tail = Enum.reduce( new_low..new_high, {}, &Tuple.append(&2, Tuple.duplicate(&1, dimension)) )
    #
    # table = Tuple.insert_at(tail, 0, head)
    #
    # left(table, new_high + 1, new_high * (multiple + 1) - multiple, dimension)
  end

  # col: 0    1    2    3       (A) :right, {0, 0}, 1, 4, true ; new_count = 4
  # {    1    2    3    4
  #   { nil, nil, nil, nil },
  #                             (B) :down, {1, 3}, 5, 3, false ; new_count = 8
  #                              ROW
  #   { nil, nil, nil, nil }, 5   1
  #
  #   { nil, nil, nil, nil }, 6   2
  #
  #   { nil, nil, nil, nil }, 7   3
  # }

  @spec traverse(table :: {{integer | nil}}
                 direction :: atom,
                 coords :: {integer, integer},
                 count :: integer,
                 steps :: integer,
                 decrement? :: boolean) :: table
  defp traverse(table, _direction, _coords, _count, 0, _decrement?), do: table
  defp traverse(table, :right, {row, col}, count, steps, decrement?) do
    {new_count, new_steps} = check_params(count, steps, decrement?)

    tuple                = elem(table, row)
    {new_tuple, new_col} = Enum.reduce(count..(new_count - 1), {tuple, col},
                             fn number, {tuple, col} ->
                               { put_elem(tuple, col, number), col + 1 }
                             end)

    table
    |> put_elem(row, new_tuple)
    |> traverse(:down, {row + 1, new_col}, new_count, new_steps, !decrement?)
  end

  defp traverse(table, :down, {row, col}, count, steps, decrement?) do
    #
  end

  defp check_params(count, steps, decrement?),
    do: { count + steps,
          if decrement?, do: steps - 1, else: steps }

  # traverse by dimension (right)
  # traverse by dimension - 1 (down)
  # traverse by dimension - 1 (left)
  # traverse by dimension - 2 (up)
  # traverse by dimension - 2 (right)
  # ...
  # traverse by 0
end
