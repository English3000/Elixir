defmodule IslandsEngine.MixProject do
  use Mix.Project

  def project, do: [
    app:             :islands_engine,
    version:         "0.1.0",
    elixir:          "~> 1.7",
    build_path:      "​​../../_build",
    config_path:     "​​../../config/config.exs",
    deps_path:       "../../deps",
    lockfile:        "../../mix.lock",
    build_embedded:  Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps:            deps()
  ]

  defp deps, do: [# compile-time deps
    {:stream_data, "~> 0.1", only: :test},
    {:shorthand, "~> 0.0.3"}
  ]

  def application, do: [# run-time deps
    mod:                {IslandsEngine.Application, []},
    extra_applications: [:logger]
  ]
end
