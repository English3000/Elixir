defmodule PropertyBasedTesting.MixProject do
  use Mix.Project

  def project, do: [
    app:             :property_based_testing,
    version:         "0.1.0",
    elixir:          "~> 1.7",
    start_permanent: Mix.env == :prod,
    deps:            deps()
  ]

  defp deps, do: [
    {:propcheck, "~> 1.1", only: [:dev, :test]},
    {:shorthand, "~> 0.0.3"},
  ]

  def application, do: [ extra_applications: [:logger] ]
end
