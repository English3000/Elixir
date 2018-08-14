defmodule IslandsEngine.DataStructures.Island do
  alias IslandsEngine.DataStructures.{Coordinate, Island}
  @enforce_keys [:coordinates, :type]
      defstruct [:coordinates, :type]

  @doc "An island is a mapset of coordinates that corresponds to a type atom."
  def new(type, %Coordinate{} = upper_left) do
    with [_|_] = coordinates <- coordinates(type),
     %MapSet{} = coords      <- build_island(coordinates, upper_left) do
      { :ok, %Island{coordinates: coords, hits: MapSet.new, type: type} }
    else
      error -> error
    end
  end
  # Builds a mapset of coordinates, or errors out if invalid.
  defp build_island(coords, start) do
    Enum.reduce_while(coords, MapSet.new, fn coord, acc ->
      add_coordinate(acc, start, coord)
    end)
  end
  defp add_coordinate(coords, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
         {:ok, coord}               -> {:cont, MapSet.put(coords, coord)}
      {:error, :invalid_coordinate} -> {:halt, {:error, :invalid_coordinate}}
    end
  end

  def  types,                do: [:atoll, :dot, :L, :S, :square]
  defp coordinates(:square), do: [{0,0},{0,1},{1,0},{1,1}]
  defp coordinates(:atoll),  do: [{0,0},{0,1},{1,1},{2,1},{2,0}]
  defp coordinates(:dot),    do: [{0,0}]
  defp coordinates(:L),      do: [{0,0},{1,0},{2,0},{2,1}]
  defp coordinates(:S),      do: [{1,0},{1,1},{0,1},{0,2}]
  defp coordinates(_),       do: {:error, :invalid_island}

  def hit?(island, coordinate), 
    do: MapSet.member?(island.coordinates, coordinate)
end
