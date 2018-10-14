defmodule IslandsEngine.DataStructures.IslandSet do
  alias IslandsEngine.DataStructures.{Island, Coordinate, Guesses}
  @doc "An island-set is a map of islands, with types for keys."
  @spec new :: %{}
  def new do
    for type <- Island.types, into: %{}, do: (
      {:ok, island} = Island.new(type);
      {type, island}
    )
  end

  def validate(island_set) do
    Enum.reduce_while(island_set, {MapSet.new, %{}},
      fn {type, island}, {map_set, islandset} when is_map(island) ->
        %{"row" => row, "col" => col} = get_in(island, ["bounds", "top_left"])
        {:ok, island_} = Island.new(String.to_atom(type), %Coordinate{row: row, col: col})

        case Enum.reduce_while(island_.coordinates, map_set, fn coord, mapset ->
               case MapSet.member?(mapset, coord) do
                 true -> {:halt, false}
                false -> {:cont, MapSet.put(mapset, coord)}
               end
             end)
        do
           false -> {:halt, false}
          mapset -> { :cont, {mapset, Map.put(islandset, String.to_atom(type), island_)} }
        end

         _, sets -> {:cont, sets}
      end)
  end

  def hit?(guesses, opp_islands, %Coordinate{} = coord) do
    case Enum.find_value(opp_islands, :miss, fn {key, island} ->
           if Island.hit?(island, coord), do: {key, island}
         end)
    do
      :miss -> {Guesses.put(guesses, :miss, coord), :miss, false}
          _ -> {Guesses.put(guesses, :hit,  coord), :hit,  filled?(guesses, opp_islands)}
    end
  end
  defp filled?(guesses, opp_islands),
    do: Enum.all?(opp_islands, fn {_key, island} -> MapSet.subset?(island.coordinates, guesses.hits) end)
end
