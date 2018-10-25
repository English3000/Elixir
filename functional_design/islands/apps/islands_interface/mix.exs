defmodule IslandsInterface.Mixfile do
  use Mix.Project

  def project, do: [
    app: :islands_interface,
    version: "0.0.1",
    elixir: "~> 1.7",
    elixirc_paths: elixirc_paths(Mix.env),
    compilers: [:phoenix, :gettext] ++ Mix.compilers,
    build_path: "​​../../_build",
    config_path: "​​../../config/config.exs",
    deps_path: "../../deps",
    lockfile: "../../mix.lock",
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps()
  ]

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application, do: [
    mod: {IslandsInterface.Application, []},
    extra_applications: [
      :cowboy,
      :islands_engine,
      :gettext,
      :logger,
      :phoenix,
      :phoenix_html,
      :runtime_tools
    ]
  ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps, do: [
    {:phoenix, "~> 1.3.2"},
    {:phoenix_pubsub, "~> 1.0"},
    {:phoenix_html, "~> 2.10"},
    {:phoenix_live_reload, "~> 1.0", only: :dev},
    {:plug_cowboy, "~> 1.0"},
    {:gettext, "~> 0.11"},
    {:cowboy, "~> 1.0"},
    {:shorthand, "~> 0.0.3"},
    {:islands_engine, in_umbrella: true}
  ]
end