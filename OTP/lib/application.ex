defmodule OTP.Application do
  use Application # https://hexdocs.pm/elixir/Application.html#module-the-application-callback-module
  @moduledoc """
  `application.ex` is where a project's supervisor is spawned.
  The supervisor then spawns and monitors its children:
    * the repo, and # https://hexdocs.pm/ecto/Ecto.Repo.html (not much of an explanation re: this...)
    * the web endpoint. # https://hexdocs.pm/phoenix/Phoenix.Endpoint.html

  So a server is literally a configurable endpoint that sets up and sends
  requests to a router... and the templates are used as responses (which is where JS comes in) -- hence SSR

  CSR is when the JS takes over routing, leaving the server to only handle data requirements
  (i.e. validation and communicating with the db).


  The supervisor, the endpoint, and the repo are all processes.
  A process is essentially a function that listens for message tuples,
  executes accordingly, then (in success cases) recurses.

  So a process starts the endpoint config... # Should look into `socket/2` (i.e.
  how does the endpoint listen for requests?)
  """
                         # from `application/1, mod: {__MODULE__, args}`
  @spec start(atom | {}, mod :: []) :: { :ok, pid } | { :ok, pid, state :: [] }
  def start(_type, _args), do: OTP.Supervisor.start_link()

  @spec stop([]) :: :ok
  @doc "for cleanup"
  def stop(_state), do: :ok
end
