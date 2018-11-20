defmodule Spiral do
  # NOTE: Could use keyword list w/ number-atom keys
  @doc ~S"""
  Given the dimension, return a square matrix of numbers in clockwise spiral order.


  ### Pattern

  traverse by dimension (right)
  traverse by dimension - 1 (down)
  traverse by dimension - 1 (left)
  traverse by dimension - 2 (up)
  traverse by dimension - 2 (right)
  ...
  traverse by 0


  ### Diagram

  col: 0    1    2    3       (A) :right, {0, 0}, 1, 4, true ; new_count - 1 = 4
  {    1    2    3    4
    { nil, nil, nil, nil },
                              (B) :down, {1, 3}, 5, 3, false ; new_count - 1 = 7
                               ROW
    { nil, nil, nil, nil }, 5   1
    { nil, nil, nil, nil }, 6   2
    { nil, nil, nil, nil }, 7   3
  }   10    9    8            (C) :left, {3, 2}, 8, 3, true ; new_count - 1 = 10
  """
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
  end

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
end
