# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wrap_test,
  ecto_repos: [WrapTest.Repo]

# Configures the endpoint
config :wrap_test, WrapTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hOLfbJbg8RYsDg3k2/xLOyQRopot6IK6AtymVjcagoCqkG1UDg2bekeF0Mb8uLLv",
  render_errors: [view: WrapTestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WrapTest.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
