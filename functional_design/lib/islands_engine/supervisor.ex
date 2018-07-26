defmodule IslandsEngine.GameSupervisor do
  use Supervisor
  alias IslandsEngine.Game

  def start_link(_options),
    do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  def init(:ok),
    do: Supervisor.init([Game], strategy: :simple_one_for_one)

  def start_game(title),
    do: Supervisor.start_child(__MODULE__, [title])
  def stop_game(title),
    do: Supervisor.terminate_child(__MODULE__, Game.registry_tuple(title) |> GenServer.whereis)
end
