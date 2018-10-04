defmodule IslandsEngine.DataStructures.Island do
  alias IslandsEngine.DataStructures.{Coordinate, Island}
  @enforce_keys [:coordinates, :bounds, :type]
      defstruct [:coordinates, :bounds, :type]

  @doc "An island is a mapset of coordinates that corresponds to a type atom."
  def new(type, %Coordinate{row: row, col: col} = top_left) do
    bounds = bounds(type, top_left)
    coords = coordinates(type)

    case is_list(coords) do
       true -> coordinates = for {y, x} <- coords, into: MapSet.new,
                               do: %Coordinate{row: row + y, col: col + x}

               {:ok, %Island{coordinates: coordinates, bounds: bounds, type: type}}
      false -> coords # error tuple
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
