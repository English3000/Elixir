defmodule IslandsEngine.DataStructures.Player do
  alias IslandsEngine.DataStructures.{Player, IslandSet, Guesses}
  defstruct key:     :player2,
            name:    nil,
            stage:   :none,
            islands: IslandSet.new,
            guesses: Guesses.new

  def new      , do: %Player{}
  def new(name), do: %Player{key: :player1, name: name, stage: :joined}

  def opponent(:player1), do: :player2
  def opponent(:player2), do: :player1
end
