defmodule IslandsEngine.Game.Stage do ## validate
  alias IslandsEngine.DataStructures.Player

  def check(%Player{stage: :none} = player, {:add_player, name}),
    do: { :ok, %Player{player | name: name, stage: :joined} }
  def check(%Player{stage: :joined}, :place_island),
    do: :ok
  def check(%Player{stage: :joined} = player, :set_islands),
    do: { :ok, %Player{player | stage: :ready} }
  def check(%Player{stage: :ready} = player1, %Player{stage: :ready} = player2),
    do: { :ok, %Player{player1 | stage: :turn}, %Player{player2 | stage: :wait} }
  def check(_state, _action),
    do: :error
  def check(%Player{stage: :turn} = guesser, waiting, status) do
    case status do
       true -> { :ok, %Player{guesser | stage: :won},  %Player{waiting | stage: :lost} }
      false -> { :ok, %Player{guesser | stage: :wait}, %Player{waiting | stage: :turn} }
    end
  end
  def check(_state, _action, _status),
    do: :error
end
