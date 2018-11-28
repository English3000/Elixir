defmodule IslandsInterface.MixProject do
  use Mix.Project

  def project, do: [
    app:             :islands_interface,
    version:         "0.1.0",
    elixir:          "~> 1.7",
    elixirc_paths:   elixirc_paths(Mix.env),
    compilers:       [:phoenix, :gettext] ++ Mix.compilers,
    build_path:      "​​../../_build",
    config_path:     "​​../../config/config.exs",
    deps_path:       "../../deps",
    lockfile:        "../../mix.lock",
    build_embedded:  Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps:            deps()
  ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps, do: [
    {:phoenix, "~> 1.4.0"},
    {:phoenix_pubsub, "~> 1.1"},
    {:phoenix_html, "~> 2.11"},
    # {:phoenix_live_reload, "~> 1.2", only: :dev},
    {:gettext, "~> 0.11"},
    {:jason, "~> 1.0"},
    {:plug_cowboy, "~> 2.0"},
    {:shorthand, "~> 0.0.3"},
    {:islands_engine, in_umbrella: true}
  ]

  def application, do: [ # `mix help compile.app`
    mod:                {IslandsInterface.Application, []},
    extra_applications: [:logger, :runtime_tools, :islands_engine]
  ]
end
