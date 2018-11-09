defmodule IslandsEngine.Application do
  use Application

  def start(_type, _args) do
    :dets.open_file(:game, []) # on-disk database

    [
      {Registry, keys: :unique, name: Registry.Game}, # node-local registry
      IslandsEngine.Game.Supervisor
    ] # start & supervise as processes
    |> Supervisor.start_link(strategy: :one_for_one, name: IslandsEngine.Supervisor)
  end
end
