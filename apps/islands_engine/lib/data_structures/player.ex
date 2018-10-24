defmodule IslandsEngine.DataStructures.Player do
  alias IslandsEngine.DataStructures.{IslandSet, Guesses}
  @player %{ key:     :player2,
             name:    nil,
             stage:   :none,
             islands: IslandSet.new,
             guesses: Guesses.new }

  def new      , do: @player
  def new(name), do: %{@player | key: :player1, name: name, stage: :joined}

  def opponent(:player1), do: :player2
  def opponent(:player2), do: :player1
end
