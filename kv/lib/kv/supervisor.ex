defmodule KV.Supervisor do
  use Supervisor

  def start_link(options) do
    Supervisor.start_link(__MODULE__, :ok, options)
  end

  def init(:ok) do
    children = [KV.Registry]

    Supervisor.init(children, strategy: :one_for_one)
    # The supervision strategy dictates what happens when one of the children crashes. :one_for_one means that if a child dies, it will be the only one restarted.
  end
end
