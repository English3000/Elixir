defmodule IslandsEngine.DataStructures.Coordinate do #(0) -- defining new data structures
  @moduledoc """
  Since we’ve aliased the Coordinate module,
  we can now refer to coordinate structs as %Coordinate{}
  instead of %IslandsEngine.Coordinate{}.
  """
  alias __MODULE__
  @enforce_keys [:row, :col]
      defstruct [:row, :col]

  @doc "Coordinate.new(integer, integer, range)"
  # @spec new(non_neg_integer, non_neg_integer, non_neg_integer..non_neg_integer) ::
  #   %Coordinate{row: non_neg_integer, col: non_neg_integer}
  def new(row, col, range \\ 1..10)
  def new(row, col, first..last)
    when first > 0 and first < last
    and row >= first and row <= last
    and col >= first and col <= last,
      do: {:ok, %Coordinate{row: row, col: col}}

  def new(_row, _col, _range), do: {:error, :invalid_coordinate}
end
