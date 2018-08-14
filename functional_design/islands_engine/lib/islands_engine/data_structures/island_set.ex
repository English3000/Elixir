defmodule IslandsEngine.DataStructures.IslandSet do
  alias IslandsEngine.DataStructures.{Island, Coordinate, Guesses}
  @doc "An islandset is a map of islands by type atom."
  def new, do: %{}

  def delete(islands, key),
    do: Map.delete(islands, key)

  def put(islands, key, %Island{} = island),
    do: if collision?(islands, key, island),
          do:   {:error, :overlaps},
          else: Map.put(islands, key, island)
  defp collision?(islands, new_key, new_island),
    do: Enum.any?(islands, fn {key, island} ->
          new_key == key or  # allows for updates
          not MapSet.disjoint?(island.coordinates, new_island.coordinates)
        end)

  @spec set?(%{}) :: boolean
  def set?(islands),
    do: if Enum.all?( Island.types, &(Map.has_key?(islands, &1)) ),
          do:   true,
          else: {:error, :unplaced_islands}

  def hit?(guesses, islands, %Coordinate{} = coord) do
    case Enum.find_value(islands, :miss, fn {key, island} ->
           case Island.hit?(island, coord) do
             {:hit, island} -> {key, island}
                      :miss -> false
           end
         end)
    do
              :miss -> {Guesses.put(guesses, :miss, coord), islands,                 false, false}
      {key, island} -> {Guesses.put(guesses, :hit,  coord), put(islands, key, island), key, filled?(islands)}
    end
  end

  def filled?(islands), # refactor to check opposing player's hits against IslandSet coords
    do: Enum.all?(islands, fn {_key, island} -> Island.filled?(island) end)
end
