defmodule IslandsEngine.DataStructures.Island do #(2)
  alias IslandsEngine.DataStructures.{Coordinate, Island}
  @enforce_keys [:coordinates, :hits]
      defstruct [:coordinates, :hits]

  def new(type, %Coordinate{} = upper_left) do
    with [_|_] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      { :ok, %Island{coordinates: coordinates, hits: MapSet.new} }
    else
      error -> error
    end
  end

  def types, do: [:atoll, :dot, :L, :S, :square]

  # For all islands, we’ll assume that the starting coordinate is in the upper-left corner.
  defp offsets(:square), do: [{0,0},{0,1},{1,0},{1,1}]
  defp offsets(:atoll),  do: [{0,0},{0,1},{1,1},{2,1},{2,0}]
  defp offsets(:dot),    do: [{0,0}]
  defp offsets(:L),      do: [{0,0},{1,0},{2,0},{2,1}]
  defp offsets(:S),      do: [{1,0},{1,1},{0,1},{0,2}]
  defp offsets(_),       do: {:error, :invalid_island}

  defp add_coordinates(offsets, start) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, start, offset)
    end)
  end

  # Each time we build a new coordinate, we check to see if it is valid.
  defp add_coordinate(coords, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok,    coord}          -> {:cont, MapSet.put(coords, coord)}
      {:error, :invalid_coord} -> {:halt, {:error, :invalid_coord}}
    end
  end

  @doc "To determine if islands overlap"
  def overlap?(existing, new),
    do: not MapSet.disjoint?(existing.coordinates, new.coordinates)

  def hit_(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true -> { :hit, %{island | hits: MapSet.put(island.hits, coordinate)} }
      false -> :miss
    end
  end

  @doc "Checks whether island is 100% hit"
  def forested?(island),
    do: MapSet.equal?(island.coordinates, island.hits)
end
