defmodule IslandsEngine.DataStructures.Coordinate do
  alias __MODULE__
  @enforce_keys [:row, :col]
      defstruct [:row, :col]

  def new(row, col),
    do: %Coordinate{row: row, col: col}
end
