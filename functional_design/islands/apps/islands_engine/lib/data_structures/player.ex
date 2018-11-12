defmodule IslandsEngine.DataStructures.Player do
  alias IslandsEngine.DataStructures.{IslandSet, Guesses}
  # Jason bug when making this a struct (b/c nested MapSet)
  @player %{
    key:     :player2,
    name:    nil,
    stage:   :none,
    islands: IslandSet.new,
    guesses: Guesses.new
  }

  def new,         do: @player
  def new(player), do: %{@player | key: :player1, name: player, stage: :joined}

  def opponent(:player1), do: :player2
  def opponent(:player2), do: :player1
end
