defmodule Erlang.MixProject do
  use Mix.Project

  def project do
    [
      app: :erlang,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # NIFs in Elixir: https://spin.atomicobject.com/2015/03/16/elixir-native-interoperability-ports-vs-nifs/
      # compilers: [:make, :elixir, :app],
      # aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [ {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:cowboy, "~> 2.5"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  # defp aliases do
  #   # Execute the usual mix clean and our Makefile clean task
  #   [ clean: ["clean", "clean.make"] ]
  # end
end
