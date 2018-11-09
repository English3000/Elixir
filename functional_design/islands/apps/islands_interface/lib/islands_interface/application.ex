defmodule IslandsInterface.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    [
      supervisor(IslandsInterfaceWeb.Endpoint, []),
      supervisor(IslandsInterfaceWeb.Presence, [])
    ]
    |> Supervisor.start_link(strategy: :one_for_one,
                             name:     IslandsInterface.Supervisor)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    IslandsInterfaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
