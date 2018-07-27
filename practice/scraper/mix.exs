# https://www.stevenmercatante.com/elixir-cli-web-scraper/
defmodule Scraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :scraper,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.2.0"},
      {:floki,     "~> 0.20.2"},
      {:html5ever, "~> 0.5.0"}
    ]
  end
end
