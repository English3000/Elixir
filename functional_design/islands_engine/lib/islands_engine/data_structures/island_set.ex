defmodule IslandsEngine.DataStructures.IslandSet do
  alias IslandsEngine.DataStructures.{Island, Coordinate}
  @doc "An islandset is a map of islands by type atom."
  def new, do: %{}

  def delete(islands, key),
    do: Map.delete(islands, key)

  def put(islands, key, %Island{} = island),
    do: if collision?(islands, island),
          do:   {:error, :overlaps},
          else: Map.put(islands, key, island)
  defp collision?(islands, new_island),
    do: Enum.any?(islands, fn {_key, island} ->
          not MapSet.disjoint?(island.coordinates, new_island.coordinates)
        end)

  @spec set?(%{}) :: boolean
  def set?(islands),
    do: if Enum.all?( Island.types, &(Map.has_key?(islands, &1)) ),
          do:   true,
          else: {:error, :unplaced_islands}

  def guess(islands, %Coordinate{} = coordinate) do
    Enum.find_value(islands, :miss, fn {key, island} ->
      case Island.hit?(island, coordinate) do
        {:hit, island} -> {key, island}
                 :miss -> false
      end
    end) |> Island.result(islands)
  end

  def winner?(islands),
    do: Enum.all?(islands, fn {_key, island} -> Island.filled?(island) end)
end
