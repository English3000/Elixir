defmodule IslandsEngine.DataStructures.IslandSet do
  alias IslandsEngine.DataStructures.{Island, Coordinate, Guesses}
  @doc "An island-set is a map of islands, with types for keys."
  @spec new :: %{}
  def new do
    for type <- Island.types, into: %{}, do: (
      {:ok, island} = Island.new(type, %Coordinate{row: 0, col: 0}, false);
      {type, island}
    )
  end

  def remove(island_set, key),
    do: %{island_set | key => %{ Map.get(island_set, key) | placed: false }}

  def put(island_set, key, %Island{} = island),
    do: if collision?(island_set, key, island),
          do:   {:error, :overlaps},
        else: Map.put(island_set, key, island)
  defp collision?(island_set, new_key, new_island) do
    Enum.any?(island_set, fn
      {key, %{placed: placed} = island} when placed ->
        not MapSet.disjoint?(island.coordinates, new_island.coordinates)

      _ -> false
    end)
  end

  def set?(island_set),
    do: if Enum.all?(island_set, fn {key, %{placed: placed}} -> placed end),
          do:   true,
          else: {:error, :unplaced_islands}

  def hit?(guesses, opp_islands, %Coordinate{} = coord) do
    case Enum.find_value(opp_islands, :miss, fn {key, island} ->
           case Island.hit?(island, coord) do
             {:hit, island} -> {key, island}
                      :miss -> false
           end
         end)
    do
              :miss -> {Guesses.put(guesses, :miss, coord), false, false}
      {key, island} -> {Guesses.put(guesses, :hit,  coord), key,   filled?(guesses, opp_islands)}
    end
  end
  defp filled?(guesses, opp_islands),
    do: Enum.all?(opp_islands, fn {_key, island} -> MapSet.subset?(island.coordinates, guesses.hits) end)
end
