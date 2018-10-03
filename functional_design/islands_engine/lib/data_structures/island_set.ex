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

  def validate(island_set) do
    Enum.reduce_while(island_set, {MapSet.new, %{}},
      fn {type, island}, {map_set, islandset} when is_map(island) ->
        %{"row" => row, "col" => col} = get_in(island, ["bounds", "top_left"])
        {:ok, coordinate} = Coordinate.new(row, col, false)
        {:ok, island_} = Island.new(String.to_atom(type), coordinate)

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
           case Island.hit?(island, coord) do
             {:hit, island} -> {key, island}
                      :miss -> false
           end
         end)
    do
               :miss -> {Guesses.put(guesses, :miss, coord), false, false}
      {key, _island} -> {Guesses.put(guesses, :hit,  coord), key,   filled?(guesses, opp_islands)}
    end
  end
  defp filled?(guesses, opp_islands),
    do: Enum.all?(opp_islands, fn {_key, island} -> MapSet.subset?(island.coordinates, guesses.hits) end)
end
