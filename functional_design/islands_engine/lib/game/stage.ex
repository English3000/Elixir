defmodule IslandsEngine.Game.Stage do
  def check(%{stage: :none} = player, {:add_player, name}),
    do: { :ok, %{player | name: name, stage: :joined} }
  def check(%{stage: :ready} = player1, %{stage: :ready} = player2),
    do: { :ok, %{player1 | stage: :turn}, %{player2 | stage: :wait} }
  def check(_state, _action),
    do: :error
  def check(%{stage: :turn} = guesser, waiting, status) do
    case status do
       true -> { :ok, %{guesser | stage: :won},  %{waiting | stage: :lost} }
      false -> { :ok, %{guesser | stage: :wait}, %{waiting | stage: :turn} }
    end
  end
  def check(_state, _action, _status),
    do: :error
end
