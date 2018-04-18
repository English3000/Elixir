defmodule InfoSys do
  use Application
  @moduledoc """
  Documentation for InfoSys.
  """

  # See http://elixir-lang.org/docs/stable/elixir/Application.html​
  # for more information on OTP Applications
  def start(_type, _args) do
    InfoSys.Supervisor.start_link()
    # import Supervisor.Spec, warn: false
    #
    # children = []
    # opts = [​strategy:​ ​:one_for_one​, ​name:​ InfoSys.Supervisor]
    #
    # Supervisor.start_link(children, opts)
  end
end
