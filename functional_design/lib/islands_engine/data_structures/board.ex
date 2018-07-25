defmodule IslandsEngine.DataStructures.Board do
  alias IslandsEngine.DataStructures.{Island, Coordinate}

  def new, do: %{}

  @spec place_island(%{}, atom, %Island{}) :: %{}
  def place_island(board, key, %Island{} = island) do
    case collision?(board, key, island) do
      false -> Map.put(board, key, island)
       true -> {:error, :overlaps}
    end
  end

  defp collision?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlap?(island, new_island)
    end)
  end

  @spec ready?(%{}) :: boolean
  def ready?(board),
    do: Enum.all?( Island.types, &(Map.has_key?(board, &1)) )

  def player_guess(board, %Coordinate{} = coordinate),
    do: board |> hit_(coordinate) |> record(board)

  defp hit_(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, island} ->
      case Island.hit_(island, coordinate) do
        {:hit, island} -> {key, island}
                 :miss -> false
      end
    end)
  end

  defp record(:miss, board),
    do: {:miss, :none, false, board}
  defp record({key, island}, board) do
    board = %{board | key => island}
    {:hit,
     (if Map.fetch!(board, key) |> Island.forested?, do: key, else: :none),
     winner?(board),
     board}
  end

  defp winner?(board),
    do: Enum.all?(board, fn {_key, island} -> Island.forested?(island) end)
end
