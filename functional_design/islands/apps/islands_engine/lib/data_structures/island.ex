defmodule IslandsEngine.DataStructures do
  defmodule Coordinate do
    @derive Jason.Encoder
    defstruct [row: 0, col: 0]
  end

  defmodule Island do
    @derive Jason.Encoder
    @enforce_keys [:coordinates, :bounds, :type]
        defstruct [:coordinates, :bounds, :type]

    @doc "An island is a mapset of coordinates that corresponds to a type atom."
    def new(type, top_left \\ %Coordinate{})
    def new(type, %Coordinate{row: row, col: col} = top_left) do
      with bounds <- bounds(type, top_left), true <- is_map(bounds),
           coords <- coordinates(type),      true <- is_list(coords)
      do
        coordinates = for {y, x} <- coords, into: MapSet.new,
                        do: %Coordinate{row: row + y, col: col + x}

        {:ok, %Island{coordinates: coordinates, bounds: bounds, type: type}}
      else
        error -> error
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

    def hit?(island, coord), do: MapSet.member?(island.coordinates, coord)
  end
end
