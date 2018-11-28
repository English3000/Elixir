defmodule Islands.MixProject do
  use Mix.Project # https://hexdocs.pm/mix/Mix.Project.html

  def project, do: [
    apps_path:       "apps",
    start_permanent: Mix.env == :prod,
    deps:            deps()
  ]
  # Dependencies listed here aren't available to `/apps`
  defp deps, do: [{:distillery, "~> 2.0"}] # `mix help deps`
end
