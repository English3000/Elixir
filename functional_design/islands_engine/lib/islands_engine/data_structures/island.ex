defmodule IslandsEngine.DataStructures.Island do #(2)
  alias IslandsEngine.DataStructures.{Coordinate, Island, IslandSet}
  @enforce_keys [:coordinates, :hits]
      defstruct [:coordinates, :hits]

  @doc "An island is a mapset of coordinates that corresponds to a type atom."
  def new(type, %Coordinate{} = upper_left) do
    with [_|_] = coordinates <- coordinates(type),
     %MapSet{} = coords      <- build_island(coordinates, upper_left) do
      { :ok, %Island{coordinates: coords, hits: MapSet.new} }
    else
      error -> error
    end
  end

  def types, do: [:atoll, :dot, :L, :S, :square]
  # For all islands, we’ll assume that the starting coordinate is in the upper-left corner.
  defp coordinates(:square), do: [{0,0},{0,1},{1,0},{1,1}]
  defp coordinates(:atoll),  do: [{0,0},{0,1},{1,1},{2,1},{2,0}]
  defp coordinates(:dot),    do: [{0,0}]
  defp coordinates(:L),      do: [{0,0},{1,0},{2,0},{2,1}]
  defp coordinates(:S),      do: [{1,0},{1,1},{0,1},{0,2}]
  defp coordinates(_),       do: {:error, :invalid_island}

  defp build_island(coords, start) do
    Enum.reduce_while(coords, MapSet.new, fn coord, acc ->
      new_coordinate(acc, start, coord)
    end)
  end
  # Each time we build a new coordinate, we check to see if it is valid.
  defp new_coordinate(coords, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
         {:ok, coord}               -> {:cont, MapSet.put(coords, coord)}
      {:error, :invalid_coordinate} -> {:halt, {:error, :invalid_coordinate}}
    end
  end

  def hit?(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true -> { :hit, %{island | hits: MapSet.put(island.hits, coordinate)} }
      false -> :miss
    end
  end

  def result(:miss, islands),
    do: {:miss, :none, false, islands}
  def result({key, island}, islands) do
    islands  = %{islands | key => island}
    forested = if Map.fetch!(islands, key) |> filled?, do: key, else: :none
    {:hit, forested, IslandSet.winner?(islands), islands}
  end

  @doc "Checks whether island is 100% hit"
  def filled?(island),
    do: MapSet.equal?(island.coordinates, island.hits)
end
