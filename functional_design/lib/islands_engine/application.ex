defmodule IslandsEngine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # a list of processes to start & supervise
    children = [ {Registry, keys: :unique, name: Registry.Game},
                 IslandsEngine.Game.Supervisor ]

    # :ets.new(:game, [:public, :named_table])
    :dets.open_file(:game, []) # TEST!

    opts = [strategy: :one_for_one, name: IslandsEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
