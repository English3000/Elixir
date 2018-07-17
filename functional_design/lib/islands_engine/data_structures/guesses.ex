defmodule IslandsEngine.DataStructures.Guesses do #(1)
  alias IslandsEngine.DataStructures.{Coordinate, Guesses}
  @enforce_keys [:hits, :misses]
      defstruct [:hits, :misses]

  def new, do: %Guesses{hits: MapSet.new, misses: MapSet.new}

  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coord),
    do: update_in(guesses.hits, &MapSet.put(&1, coord))
  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coord),
    do: update_in(guesses.misses, &MapSet.put(&1, coord))
end
