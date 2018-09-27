defmodule IslandsEngine.DataStructures.IslandSet do
  alias IslandsEngine.DataStructures.{Island, Coordinate, Guesses}
  @doc "An island-set is a map of islands, with types for keys."
  @spec new :: %{}
  def new do
    for type <- Island.types, into: %{placed: false}, do: (
      {:ok, island} = Island.new(type, %Coordinate{row: 0, col: 0}, false);
      {type, island}
    )
  end

  def valid?(island_set) do
    Enum.reduce(island_set, fn island, coords -> island.coordinates ++ coords end)
    |> Enum.reduce_while(MapSet.new, fn coord, mapset ->
      case MapSet.member?(mapset, coord) do
         true -> {:halt, false}
        false -> {:cont, MapSet.put(mapset, coord)}
      end
    end)
    |> ( &(!!&1) ).() # converts result to boolean
  end

  def convert(payload),
    do: for %{type: type, bounds: %{top_left: %{row: row, col: col}}} <- payload,
        into: %{},
          do: (
            {:ok, island} = String.to_atom(type) |> Island.new(%Coordinate{row: row, col: col}) ;
            {island.type, island}
          )

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
