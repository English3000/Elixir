defmodule KV.MixProject do
  use Mix.Project

  # project config.
  def project do
    [
      app: :kv,
      version: "0.1.0",
      elixir: "~> 1.6",
      # starts your application in permanent mode, which means the Erlang VM will crash if your application’s supervision tree shuts down
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  # gen's an application file
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  # private method defining project dependencies
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
