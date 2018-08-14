defmodule IslandsEngine.DataStructures.Guesses do
  alias IslandsEngine.DataStructures.{Coordinate, Guesses}
  defstruct hits:   MapSet.new, # O(n) search??
            misses: MapSet.new

  def new, do: %Guesses{}

  def put(%Guesses{} = guesses, :hit, %Coordinate{} = coord),
    do: update_in(guesses.hits, &MapSet.put(&1, coord))
  def put(%Guesses{} = guesses, :miss, %Coordinate{} = coord),
    do: update_in(guesses.misses, &MapSet.put(&1, coord))
end
