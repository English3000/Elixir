#(0) -- defining new data structures
defmodule IslandsEngine.DataStructures.Coordinate do
  alias __MODULE__ # DataStructures.Coordinate -> Coordinate
  @enforce_keys [:row, :col]
      defstruct [:row, :col]

  @doc "A coordinate is a struct with two integer values."
  ## range should not be defined at coordinate-level
  def new(row, col, range \\ 1..10)
  def new(row, col, first..last)
    when first > 0 and first < last
    and row >= first and row <= last
    and col >= first and col <= last,
      do: {:ok, %Coordinate{row: row, col: col}}
  def new(_row, _col, _range),
    do: {:error, :invalid_coordinate}
end
