# TODO: refactor DataStructures API
defmodule IslandsEngine.DataStructures.Player do
  alias IslandsEngine.DataStructures.{Player, IslandSet, Guesses}
  defstruct name:    nil,
            stage:   :none,
            islands: IslandSet.new,
            guesses: Guesses.new
            # key??

  def new,
    do: %Player{}
  def new(name),
    do: %Player{name: name, stage: :joined}

  # Rules API

  # look at other data structures
  # possibly add Game struct too
end
