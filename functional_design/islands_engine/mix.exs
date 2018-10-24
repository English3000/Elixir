# for pre-SSR, git revert 1a2f3e2b3ced8c3faadfcdc4afdca8e99fa876aa
defmodule IslandsEngine.MixProject do
  use Mix.Project # https://hexdocs.pm/mix/Mix.Project.html

  def project, # metadata
    do: [ app: :islands_engine,
          version: "0.1.0",
          elixir: "~> 1.6",
          start_permanent: Mix.env() == :prod,
          deps: deps() ]

  defp deps, # compile-time deps
    do: [ {:stream_data, "~> 0.1", only: :test}, # Run "mix help deps" to learn about dependencies.
          {:shorthand, "~> 0.0.3"} ]

  def application, # run-time deps
    do: [ extra_applications: [:logger],
          mod:                {IslandsEngine.Application, []} ] # Run "mix help compile.app" to learn about applications.
end
