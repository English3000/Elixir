defmodule IslandsEngine.DataStructures.Guesses do
  alias IslandsEngine.DataStructures.{Coordinate, Guesses}
  defstruct hits:   MapSet.new,
            misses: MapSet.new

  def new, do: %Guesses{}

  def put(%Guesses{} = guesses, :hit, %Coordinate{} = coord),
    do: %{guesses | hits: MapSet.put(guesses.hits, coord)}
  def put(%Guesses{} = guesses, :miss, %Coordinate{} = coord),
    do: %{guesses | misses: MapSet.put(guesses.misses, coord)}
end
