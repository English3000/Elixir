defmodule Islands.MixProject do
  use Mix.Project # `mix help <cmd>`

  def project, do: [
    apps_path:       "apps",
    start_permanent: Mix.env == :prod,
    deps:            deps()
  ]

  defp deps, do: [{:distillery, "~> 2.0"}] # unavailable to "apps"
end
