defmodule IslandsEngine.MixProject do
  use Mix.Project # https://hexdocs.pm/mix/Mix.Project.html

  def project, # metadata
    do: [ app: :islands_engine,
          version: "0.1.0",
          elixir: "~> 1.7",
          build_path: "​​../../_build",
          config_path: "​​../../config/config.exs",
          deps_path: "../../deps",
          lockfile: "../../mix.lock",
          build_embedded: Mix.env() == :prod,
          start_permanent: Mix.env() == :prod,
          deps: deps() ]

  defp deps, # compile-time deps
    do: [ {:distillery, "~> 2.0"}, # Run "mix help deps" to learn about dependencies.
          {:stream_data, "~> 0.1", only: :test},
          {:shorthand, "~> 0.0.3"} ]

  def application, # run-time deps
    do: [ extra_applications: [:logger],
          mod:                {IslandsEngine.Application, []} ] # Run "mix help compile.app" to learn about applications.
end
