defmodule IslandsEngine.Game.Supervisor do
  use Supervisor
  alias IslandsEngine.Game.Server

  def start_link(_options),
    do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  def init(:ok),
    do: Supervisor.init([Server], strategy: :simple_one_for_one)

  def start_game(player),
    do: Supervisor.start_child(__MODULE__, [player])
  def stop_game(player) do # could record game result in another table
    :dets.delete(:game, player)
    Supervisor.terminate_child(__MODULE__, Server.registry_tuple(player) |> GenServer.whereis)
  end
end
