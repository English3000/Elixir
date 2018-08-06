defmodule IslandsEngine.Game.Supervisor do
  use Supervisor
  alias IslandsEngine.Game.Server

  def start_link(_options),
    do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  def init(:ok),
    do: Supervisor.init([Server], strategy: :simple_one_for_one)

  def start_game(game, player),
    do: Supervisor.start_child(__MODULE__, [game, player])
  def stop_game(game) do # could record game result in another table
    :dets.delete(:game, game)
    Supervisor.terminate_child(__MODULE__, Server.registry_tuple(game) |> GenServer.whereis)
  end
end
