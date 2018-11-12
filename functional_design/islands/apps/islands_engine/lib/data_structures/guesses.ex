defimpl Jason.Encoder, for: MapSet do
  def encode(struct, opts) do
    struct
    |> Enum.to_list
    |> Jason.Encode.list(opts)
  end
end

defmodule IslandsEngine.DataStructures.Guesses do
  alias IslandsEngine.DataStructures.{Coordinate, Guesses}

  @derive Jason.Encoder
  defstruct hits:   MapSet.new,
            misses: MapSet.new

  def new, do: %Guesses{}

  def put(%Guesses{} = guesses, :hit, %Coordinate{} = coord),
    do: %{guesses | hits: MapSet.put(guesses.hits, coord)}
  def put(%Guesses{} = guesses, :miss, %Coordinate{} = coord),
    do: %{guesses | misses: MapSet.put(guesses.misses, coord)}
end
