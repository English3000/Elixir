# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :app_0,
  ecto_repos: [App0.Repo]

# Configures the endpoint
config :app_0, App0Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "e1JW7Zjf7kFENymYaZhWcmM41rvrkkSoK3T8l8yee1OjKj4qThIRdnRFoCw3JbWP",
  render_errors: [view: App0Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: App0.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
