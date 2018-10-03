defmodule IslandsEngine.DataStructures.Coordinate do
  alias __MODULE__
  @enforce_keys [:row, :col]
      defstruct [:row, :col]
  # NOTE: Put validation only on frontend...
  ## range should not be defined at coordinate-level
  @doc "A coordinate is a struct with two integer values."
  def new(row, col, validate \\ true, range \\ 1..10)
  def new(row, col, validate, first..last)
    when not validate
    or first > 0 and first < last
    and row >= first and row <= last
    and col >= first and col <= last,
      do: {:ok, %Coordinate{row: row, col: col}}
  def new(_row, _col, true, _range),
    do: {:error, :invalid_coordinate}
end
