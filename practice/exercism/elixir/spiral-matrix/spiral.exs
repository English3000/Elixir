defmodule Spiral do
  @doc "Given the dimension, return a square matrix of numbers in clockwise spiral order."
  # NOTE: Could use keyword list w/ number-atom keys
  @spec matrix(dimension :: integer) :: [ [integer] ]
  def matrix(0), do: []
  def matrix(dimension) do
    IO.puts("\ntest")
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

  # col: 0    1    2    3       (A) :right, {0, 0}, 1, 4, true ; new_count - 1 = 4
  # {    1    2    3    4
  #   { nil, nil, nil, nil },
  #                             (B) :down, {1, 3}, 5, 3, false ; new_count - 1 = 7
  #                              ROW
  #   { nil, nil, nil, nil }, 5   1
  #
  #   { nil, nil, nil, nil }, 6   2
  #
  #   { nil, nil, nil, nil }, 7   3
  # }   10    9    8            (C) :left, {3, 2}, 8, 3, true ; new_count - 1 = 10

  @type table :: {{integer | nil}}
  @spec traverse(table,
                 direction :: atom,
                 coords :: {integer, integer},
                 count :: integer,
                 steps :: integer,
                 decrement? :: boolean) :: table
  defp traverse(table, _direction, _coords, _count, 0, _decrement?), do: table
  defp traverse(table, direction, {row, col} = coords, count, steps, decrement?) do
    IO.inspect(coords)
    {new_count, new_steps} = check_params(count, steps, decrement?)
    range                  = count..(new_count - 1)

    if direction in [:right, :left] do
      {operator, new_direction} = case direction do
                                    :right -> {&+/2, :down}
                                    :left  -> {&-/2, :up}
                                  end

      {new_tuple, new_col} = table
                             |> elem(row)
                             |> traverse_row(operator, range, col)

      table
      |> put_elem(row, new_tuple)
      |> traverse(new_direction, {operator.(row, 1), operator.(new_col, -1)}, new_count, new_steps, !decrement?)
    else
      {operator, new_direction} = case direction do
                                    :up   -> {&+/2, :right}
                                    :down -> {&-/2, :left}
                                  end

      {new_table, new_row} = traverse_col(table, operator, range, coords)

      new_table
      |> traverse(new_direction, {operator.(new_row, -1), operator.(col, 1)}, new_count, new_steps, !decrement?)
    end
  end

  defp check_params(count, steps, decrement?),
    do: { count + steps,
          (if decrement?, do: steps - 1, else: steps) }

  # traverse by dimension (right)
  # traverse by dimension - 1 (down)
  # traverse by dimension - 1 (left)
  # traverse by dimension - 2 (up)
  # traverse by dimension - 2 (right)
  # ...
  # traverse by 0

  defp traverse_row(tuple, operator, range, col) do
    Enum.reduce(range, {tuple, col}, fn number, {tuple, col} ->
      { put_elem(tuple, col, number), operator.(col, 1) }
    end)
  end

  defp traverse_col(table, operator, range, {row, col}) do
    Enum.reduce(range, {table, row}, fn number, {table, row} ->
      IO.inspect(row)
      tuple = table
              |> elem(row)
              |> put_elem(col, number)
              |> IO.inspect()

      { put_elem(table, row, tuple), operator.(row, 1) }
    end)
  end
  # defp traverse(table, :right, {row, col}, count, steps, decrement?) do
  #   {new_count, new_steps} = check_params(count, steps, decrement?)
  #
  #   tuple                = elem(table, row)
  #   {new_tuple, new_col} = Enum.reduce(count..(new_count - 1), {tuple, col},
  #                            fn number, {tuple, col} ->
  #                              { put_elem(tuple, col, number), col + 1 }
  #                            end)
  #
  #   table
  #   |> put_elem(row, new_tuple)
  #   |> traverse(:down, {row + 1, new_col}, new_count, new_steps, !decrement?)
  # end

  # defp traverse(table, :down, {row, col}, count, steps, decrement?) do
  #   {new_count, new_steps} = check_params(count, steps, decrement?)
  #
  #   {new_table, new_row} = Enum.reduce(count..(new_count - 1), {table, row},
  #                            fn number, {table, row} ->
  #                              tuple = table
  #                                      |> elem(row)
  #                                      |> put_elem(col, number)
  #
  #                              { put_elem(table, row, tuple), row + 1 }
  #                            end)
  #
  #   traverse(new_table, :left, {new_row, col - 1}, new_count, new_steps, !decrement?)
  # end

  # defp traverse(table, :left, {row, col}, count, steps, decrement?) do
  #   {new_count, new_steps} = check_params(count, steps, decrement?)
  #
  #   tuple                = elem(table, row)
  #   {new_tuple, new_col} = Enum.reduce(count..(new_count - 1), {tuple, col},
  #                            fn number, {tuple, col} ->
  #                              { put_elem(tuple, col, number), col - 1 }
  #                            end)
  #
  #   table
  #   |> put_elem(row, new_tuple)
  #   |> traverse(:up, {row - 1, new_col}, new_count, new_steps, !decrement?)
  # end
end
