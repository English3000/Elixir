defmodule IslandsEngine.DataStructures.Island do
  alias IslandsEngine.DataStructures.{Coordinate, Island}
  @enforce_keys [:coordinates, :bounds, :type, :placed]
      defstruct [:coordinates, :bounds, :type, :placed]

  @doc "An island is a mapset of coordinates that corresponds to a type atom."
  def new(type, %Coordinate{} = top_left, placed \\ true) do
    with        %{} = bounds <- bounds(type, top_left),
         [_|_] = coordinates <- coordinates(type),
          %MapSet{} = coords <- build_island(coordinates, top_left) do
      { :ok, %Island{coordinates: coords, bounds: bounds, type: type, placed: placed} }
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

  defp coordinates(:atoll),  do: [{0,0},{0,1},{1,1},{2,1},{2,0}]
  defp coordinates(:dot),    do: [{0,0}]
  defp coordinates(:L),      do: [{0,0},{1,0},{2,0},{2,1}]
  defp coordinates(:S),      do: [{1,0},{1,1},{0,1},{0,2}]
  defp coordinates(:square), do: [{0,0},{0,1},{1,0},{1,1}]
  defp coordinates(_),       do: {:error, :invalid_island}

  defp bounds(:atoll,  top_left), do: %{width: 2, height: 3, top_left: top_left}
  defp bounds(:dot,    top_left), do: %{width: 1, height: 1, top_left: top_left}
  defp bounds(:L,      top_left), do: %{width: 2, height: 3, top_left: top_left}
  defp bounds(:square, top_left), do: %{width: 2, height: 2, top_left: top_left}
  defp bounds(:S, %Coordinate{row: row} = coord),
    do: %{width: 3, height: 2, top_left: %{coord | row: row - 1}}
  defp bounds(_, _),              do: {:error, :invalid_island}

  def hit?(island, coordinate),
    do: MapSet.member?(island.coordinates, coordinate)
end
